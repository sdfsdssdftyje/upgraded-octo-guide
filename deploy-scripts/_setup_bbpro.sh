#!/usr/bin/env bash

OS_TYPE=""
ONTOR=false
TOR_PROXY=""
INJECT_SCRIPT=""

# Function to display help message
display_help() {
  cat << EOF
    Usage: $(basename $0) [OPTIONS]

    This script sets up and configures BrowserBox with optional Tor support.

    OPTIONS:
      -h, --help              Show this help message and exit.
      -p, --port PORT         Specify the main port for BrowserBox.
      -t, --token TOKEN       Set a specific login token for BrowserBox.
      -c, --cookie COOKIE     Set a specific cookie value for BrowserBox.
      -d, --doc-key DOC_API_KEY Set a specific document viewer API key for BrowserBox.
      --ontor                 Enable Tor support in BrowserBox.
      --inject  PATH          JavaScript file to inject into every browsed page

    EXAMPLES:
      $(basename $0) --port 8080 --token mytoken --cookie mycookie --doc-key mydockey
      $(basename $0) --port 8080 --ontor
      $(basename $0) --port 8080 --inject ~/extension.js

EOF
}

# Open port on CentOS
open_firewall_port_centos() {
  local port=$1
  sudo="$(command -v sudo)"
  $sudo firewall-cmd --permanent --add-port="${port}/tcp" >&2
  $sudo firewall-cmd --reload >&2 
}

is_port_free() {
  local port=$1
  if [[ "$port" =~ ^[0-9]+$ ]] && [ "$port" -ge 4022 ] && [ "$port" -le 65535 ]; then
    echo "$port valid port number." >&2
  else
    echo "$1" " invalid port number." >&2
    echo "" >&2
    echo "Select a main port between 4024 and 65533." >&2
    echo "" >&2
    echo "  Why 4024?" >&2
    echo "    This is because, by convention the browser runs on the port 3000 below the app's main port, and the first user-space port is 1024." >&2
    echo "" >&2
    echo "  Why 65533?" >&2
    echo "    This is because, each app occupies a slice of 5 consecutive ports, two below, and two above, the app's main port. The highest user-space port is 65535, hence the highest main port that leaves two above it free is 65533." >&2
    echo "" >&2
    return 1
  fi

  if [[ $(uname) == "Darwin" ]]; then
    if lsof -i tcp:"$port" > /dev/null 2>&1; then
      # If lsof returns a result, the port is in use
      return 1
    fi
  else
    # Prefer 'ss' if available, fall back to 'netstat'
    if command -v ss > /dev/null 2>&1; then
      if ss -lnt | awk '$4 ~ ":'$port'$" {exit 1}'; then
        return 0
      fi
    elif netstat -lnt | awk '$4 ~ ":'$port'$" {exit 1}'; then
      return 0
    fi
  fi

  return 0
}

# Detect Operating System
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [ -f /etc/debian_version ]; then
      OS_TYPE="debian"
    elif [ -f /etc/centos-release ]; then
      OS_TYPE="centos"
    else
      echo "Unsupported Linux distribution" >&2
      exit 1
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_TYPE="macos"
  else
    echo "Unsupported Operating System" >&2
    exit 1
  fi
}

find_torrc_path() {
  if [[ "$OS_TYPE" == "macos" ]]; then
    prefix=$(brew --prefix tor)
    TORRC=$(node -p "path.resolve('${prefix}/../../etc/tor/torrc')")
    TORDIR=$(node -p "path.resolve('${prefix}/../../var/lib/tor')")
    mkdir -p "$TORDIR"
    if [[ ! -f "$TORRC" ]]; then
      cp "$(dirname "$TORRC")/torrc.sample" "$(dirname "$TORRC")/torrc" || touch "$TORRC"
    fi
  else
    TORRC="/etc/tor/torrc"  # Default path for Linux distributions
    TORDIR="/var/lib/tor"
  fi
  echo "$TORRC"
}

# Function to check if Tor is installed
check_tor_installed() {
  if command -v tor >/dev/null 2>&1; then
    echo "Tor is installed." >&2
    echo -n "Ensuring tor started..." >&2
    if [[ "$OS_TYPE" == "macos" ]]; then 
      brew services start tor
    else 
      sudo systemctl start tor
    fi
    echo "Done." >&2
    return 0
  else
    echo "Tor is not installed." >&2
    return 1
  fi
}

# Function to run Torbb if Tor is not installed
run_torbb_if_needed() {
  CONFIG_DIR="$1"
  test_env="${CONFIG_DIR}/test.env"
  if [ ! -f "$test_env" ]; then
    echo "Running setup_bbpro without --ontor first" >&2
    "$0" "${@/--ontor/}" # Remove --ontor and rerun the script
  fi
  echo "Running torbb" >&2
  torbb
  pm2 delete all
}

# Function to obtain SOCKS5 proxy address from tor
obtain_socks5_proxy_address() {
  torrc_path=$(find_torrc_path)
  # Parse the torrc file to find the SOCKS5 proxy address
  if grep -q "^SocksPort" "$torrc_path"; then
    # Extract and return the SOCKS5 proxy address from torrc
    socks_port=$(grep "^SocksPort" "$torrc_path" | awk '{print $2}')
    echo "socks5://127.0.0.1:$socks_port"
  else
    # Default SOCKS5 proxy address
    echo "socks5://127.0.0.1:9050"
  fi
}

detect_os

echo "Parsing command line args..." >&2
echo "" >&2

# determine if running on MacOS
if [[ $(uname) == "Darwin" ]]; then
  # check if brew is installed
  if ! command -v brew >/dev/null 2>&1; then
    echo "Error: Homebrew is not installed. Please install Homebrew first." >&2
    echo "Visit https://brew.sh for installation instructions." >&2
    exit 1
  fi

  # if gnu-getopt is not installed, install it
  if ! brew --prefix gnu-getopt > /dev/null 2>&1; then
    brew install gnu-getopt
  fi
  getopt=$(brew --prefix gnu-getopt)/bin/getopt
else
  # else use regular getopt
  getopt="/usr/bin/getopt"
fi

# Parsing command line args including --ontor
#OPTS=`$getopt -o p:t:c:d: --long port:,token:,cookie:,doc-key:,ontor -n 'parse-options' -- "$@"`
OPTS=$($getopt -o hp:t:c:d: --long help,port:,token:,cookie:,doc-key:,ontor,inject: -n 'parse-options' -- "$@")


if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help)
      display_help
      exit 0
    ;;
    --ontor )
      ONTOR=true
      shift
    ;;
    --inject )
      INJECT_SCRIPT="$2"
      shift 2
      if [[ -f "$INJECT_SCRIPT" ]]; then
        echo "Inject script valid." >&2
      else
        echo "Inject script does not exist. Exiting..." >&2
        exit 1
      fi
    ;;
    -p | --port ) 
      if [[ $2 =~ ^[0-9]+$ ]]; then
        PORT="$2"
      else
        echo "Error: --port requires a numeric argument.">&2
        exit 1
      fi
      shift 2
    ;;
    -t | --token ) TOKEN="$2"; shift 2;;
    -c | --cookie ) COOKIE="$2"; shift 2;;
    -d | --doc-key ) DOC_API_KEY="$2"; shift 2;;
    -- )
      shift
      break
    ;;
    * )
      echo "Invalid option: $1" >&2
      display_help
      exit 1
    ;;
  esac
done

echo "Done!">&2;

if [ -z "$PORT" ]; then
  echo "Error: --port option is required. Type --help for options." >&2
  exit 1
elif ! is_port_free "$PORT"; then
  echo "" >&2
  echo "Error: the suggested port $PORT is invalid or already in use." >&2
  echo "" >&2
  exit 1
elif ! is_port_free $(($PORT - 2)); then
  echo "Error: the suggested port range (audio) is already in use" >&2
  exit 1
elif ! is_port_free $(($PORT + 1)); then
  echo "Error: the suggested port range (devtools) is already in use" >&2
  exit 1
elif ! is_port_free $(($PORT - 1)); then
  echo "Error: the suggested port range (doc viewer) is already in use" >&2
  exit 1
fi

if $ONTOR; then
  if ! check_tor_installed; then
    run_torbb_if_needed "$CONFIG_DIR" "${@}"
  else
    TOR_PROXY=$(obtain_socks5_proxy_address)
    export TOR_PROXY="$TOR_PROXY"
  fi
  echo "Browser will connect to the internet using Tor" >&2
fi

if [ -z "$TOKEN" ]; then
  echo -n "Token not provided, so will generate...">&2
  TOKEN=$(openssl rand -hex 16)
  echo " Generated token: $TOKEN">&2
fi

if [ -z "$COOKIE" ]; then
  echo -n "Cookie not provided, so will generate...">&2
  COOKIE=$(openssl rand -hex 16)
  echo "Generated cookie: $COOKIE">&2
fi

if [ -z "$DOC_API_KEY" ]; then
  echo -n "Doc API key not provided, so will generate...">&2
  DOC_API_KEY=$(openssl rand -hex 16)
  echo "Generated doc API key: $DOC_API_KEY">&2
fi

DT_PORT=$((PORT + 1))
SV_PORT=$((PORT - 1))
AUDIO_PORT=$((PORT - 2))

echo "Received port $PORT and token $TOKEN and cookie $COOKIE">&2

echo "Setting up bbpro...">&2

echo -n "Creating config directory...">&2

CONFIG_DIR=$HOME/.config/dosyago/bbpro/
mkdir -p $CONFIG_DIR

echo $(date) > $CONFIG_DIR/.bbpro_config_dir

echo "Done!">&2

echo -n "Creating test.env...">&2

sslcerts="sslcerts"
cert_file="$HOME/${sslcerts}/fullchain.pem"
sans=$(openssl x509 -in "$cert_file" -noout -text | grep -A1 "Subject Alternative Name" | tail -n1 | sed 's/DNS://g; s/, /\n/g' | head -n1 | awk '{$1=$1};1')
HOST=$(echo $sans | awk '{print $1}')

if [[ -f /etc/centos-release ]]; then
  echo "Detected CentOS. Ensuring required ports are open in the firewall..." >&2
  open_firewall_port_centos "$PORT"
  open_firewall_port_centos "$DT_PORT"
  open_firewall_port_centos "$SV_PORT"
  open_firewall_port_centos "$AUDIO_PORT"
fi

cat > "${CONFIG_DIR}/test.env" <<EOF
export APP_PORT=$PORT
export LOGIN_TOKEN=$TOKEN
export COOKIE_VALUE=$COOKIE
export DEVTOOLS_PORT=$DT_PORT
export DOCS_PORT=$SV_PORT
export DOCS_KEY=$DOC_API_KEY
export INJECT_SCRIPT="${INJECT_SCRIPT}"

# true runs within a 'browsers' group
#export BB_POOL=true

export RENICE_VALUE=-19

# used for building or for installing from repo on macos m1 
# (because of some dependencies with native addons that do not support m1)
# export TARGET_ARCH=x64

export CONFIG_DIR="${CONFIG_DIR}"

# use localhost certs (need export from access machine, can then block firewall ports and not expose connection to internet
# for truly private browser)
# export SSLCERTS_DIR=$HOME/localhost-sslcerts
export SSLCERTS_DIR="${sslcerts}"

# compute the domain from the cert file
export DOMAIN="$HOST"

# only filled out if --ontor is used
export TOR_PROXY="$TOR_PROXY"

# for extra security (but may reduce performance somewhat)
# set the following variables.
# alternately if below are empty
# you can:
# npm install --save-optional bufferutil utf-8-validate
# to utilise these binary libraries to improve performance
# at possible risk to security
WS_NO_UTF_8_VALIDATE=true
WS_NO_BUFFER_UTIL=true

EOF

echo "Done!">&2

echo "The login link for this instance will be:">&2

DOMAIN=$HOST

echo https://$DOMAIN:$PORT/login?token=$TOKEN > $CONFIG_DIR/login.link
echo https://$DOMAIN:$PORT/login?token=$TOKEN

echo "Setup complete. Exiting...">&2
