# BrowserBox News

BrowserBox is an embeddable, multiplayer browser that facilitates RBI (remote browser isolation) and zero trust protection. We've just integrated support for Tor. 

***tor-iframe:***
```html
<iframe src="https://mybrowserbox.server.com:9999/login?token=cviuygf3498tysifud&ui=false&url=[&quot;https://check.torproject.org&quot;]"
        style="border:none; width:100%; height:100%;"
        allowfullscreen
        scrolling="no">
</iframe>
```

On server:
```bash
$ IFRAME_LINK=$(setup_bbpro -p 9999 --ontor)
```

You can now [browse the web through Tor when using BrowserBox](#rotating_light-browserbox-on-tor). BrowserBox also supports running itself as a [Tor hidden service](#rotating_light-latest-news-browserbox-hidden-services), so you can access your BrowserBox instances over the Tor network.

<img width="1192" alt="BrowserBox with --ontor on macOS successfully on the Tor network as checked at https://check.torproject.org" src="https://github.com/BrowserBox/BrowserBox/assets/22254235/5b92a312-4d4e-49e4-bffe-7088f3abe7b1">

*[Donate to Tor](https://donate.torproject.org)*

## 🌟 What's New in BrowserBox 

We're thrilled to announce the following major updates to BrowserBox that will enhance your user experience and streamline your workflow!

### Table of Contents

- [What's New in BrowserBox](#-whats-new-in-browserbox)
- [BrowserBox on Tor](#rotating_light-browserbox-on-tor)
- [Installable PWAs on Desktop](#-installable-pwas-on-desktop)
- [Protocol Links Support](#-protocol-links-support)
- [Latest News: BrowserBox Hidden Services!](#rotating_light-latest-news-browserbox-hidden-services)
- [AWS EC2 Installation](#browserbox---aws-ec2-installation)
- [Docker Quick Start](#docker-quick-start-gem-version-6)
- [Special Event: Ephemeral Web Proxy](#special-event--create-a-private-ephemeral-web-proxy-hosted-on-your-github-actions-minutes-by-opening-an-issue-on-this-repo)
- [General README](#browserbox---general-readme)

-----

### :rotating_light: BrowserBox on Tor!

#### 🌍 Enhanced Privacy with Tor Support

We are excited to announce that BrowserBox now supports Tor, providing you with a more private and secure browsing experience. This feature is still in alpha, but we're committed to continuously improving it to match the security level of the Tor Browser over time.

**Key Features:**
- **Onion Sites Accessibility**: Browse [`.onion`](https://en.wikipedia.org/wiki/.onion) websites seamlessly.
- **Privacy-First Browsing**: Enhanced encryption for anonymity and security. Tor conceals the IP address of your RBI server.
- **Socks5 Proxy Integration**: Traffic securely routed over a Socks5 proxy.
- **Simple Tor Activation**: Easy activation using the `--ontor` flag.
- **Platform Compatibility**: Tested on macOS and Debian.

#### :gear: Using BrowserBox with Tor

Activate Tor in BrowserBox with this command:

```shell
$ setup_bbpro <your-normal-args> --ontor
$ bbpro
```

*If you want to switch it off again, shut down as normal (`pm2 delete all`), and re-run `setup_bbpro` without the `--ontor` flag.*

Start exploring the web with Tor's added security.

#### :warning: Important Caveats and Commitment to Security

As this Tor integration is in *alpha*, there are several important considerations:

- **Proxy and Tor Escapes**: There's a potential for some requests to bypass the Socks5 Tor proxy or Tor itself, which could impact privacy. We are actively working to identify and mitigate these risks.
- **Adherence to Tor Guidelines**: We aspire to aligning our Tor integration as closely as possible with the best practices recommended by the Tor Project. This includes careful configuration to prevent leaks and maintaining the anonymity that Tor provides.
- **Ongoing Security Enhancements**: Our goal is to eventually provide a level of security comparable to the Tor Browser. We'll be regularly updating and improving the Tor functionality in BrowserBox.
- **Exploring Alternatives**: We are considering the integration of alternative browsers like Brave as the underlying engine for RBI, which may offer a more secure base than Chrome for Tor browsing.

#### :speech_balloon: Your Input is Valuable

Your feedback is crucial for our continuous improvement. Please report any issues or suggestions to enhance the Tor functionality on our GitHub issues page. Contributions, especially those that help achieve parity with Tor Browser's security, are highly appreciated.

Stay tuned for more updates and enhancements in BrowserBox, and as always, enjoy a secure browsing experience!

-----

### 🚀 Installable PWAs on Desktop

You can now install BrowserBox as a Progressive Web App (PWA) on your desktop! This means smoother performance, offline capabilities, and a more integrated experience with your operating system. 

**Key Benefits:**
- **Seamless Integration:** Feel the power of a native app with the flexibility of a web application.
- **Offline Access:** Access essential features even without an internet connection.
- **Reduced Resource Usage:** Enjoy a more efficient use of system resources compared to traditional web browsing.

### 🔗 Protocol Links Support

Introducing protocol links support with `web+bb://`. Now, you can open links directly in BrowserBox by prefacing them with `web+bb://`. This feature allows for more efficient navigation and a streamlined process to access web content.

**How it Works:**
- Simply prefix your URL with `web+bb://`.
- For example, to open `https://example.com`, use `web+bb://https://example.com`.
- The link will automatically open in BrowserBox, providing a seamless browsing experience.

This update is part of our ongoing commitment to enhance BrowserBox and make your web experience as efficient and enjoyable as possible. Try out these new features and let us know what you think!

Stay tuned for more updates, and as always, happy browsing with BrowserBox!

-----

## :rotating_light: Latest News: BrowserBox Hidden Services!

### GitHub Actions Method

Before starting, [fork](../fork) or [generate](../generate) this repo to your account.

Then ensure that:

1. [Issues](../settings#issue-feature) are switched on, and
2. [Actions](../actions) are enabled.

To begin the action to create your BrowserBox Tor Hidden Service, click **Submit New Issue**, on [this special issue template](../issues/new?assignees=&labels=enhancement&projects=&template=Torbb.md&title=BrowserBox+Tor+Hidden+Service).


### DIY Method with [`torbb`](https://github.com/BrowserBox/BrowserBox/blob/boss/deploy-scripts/_torbb.sh)

Alternately, use the new **torbb** command:

```shell
$ git clone https://github.com/BrowserBox/BrowserBox.git
$ cd BrowserBox
$ yes | ./deploy-scripts/global_install.sh localhost
$ setup_bbpro --port <my_port>
$ torbb
```

-----

💎 We're excited to announce that BrowserBox can now run as a hidden service on the Tor network! This significant update brings enhanced privacy and security, allowing you to access BrowserBox with the anonymity of Tor. Check out our [Show HN post: torbb - Now with Tor, run BrowserBox as a hidden service](https://news.ycombinator.com/item?id=38336686).

### Getting Started with BrowserBox on Tor
- **Download Mkcert Root CA**: For a smoother experience on Tor, download and install the Mkcert Root CA, unique to each installation, to avoid certificate warnings. [Installation Guide](https://github.com/BrowserBox/BrowserBox/blob/boss/src/public/torca/rootca-import-guidance.md), and [Helpful Video Tutorial How-To for macOS](https://youtu.be/ADN26iqtSZ8).
- **Create Your Hidden Service**: Fork this repository and open an issue using the "Make BB Hidden Service" template. A GitHub action will automatically create your unique .onion link. [Learn more](https://github.com/BrowserBox/BrowserBox/issues/new?assignees=&labels=enhancement&projects=&template=Torbb.md&title=BrowserBox+Tor+Hidden+Service).
- **Try it now**: Fork or generate this repository, and create an issue from the template to get your BrowserBox running on Tor! [Fork here](../../fork) / [Generate here](../../generate).

-----

## BrowserBox - AWS EC2 Installation 

**[New Video: Installing BrowserBox on Amazon AWS EC2 Amazon Linux](https://www.youtube.com/watch?v=-YEOHXXid9g)**

General install instructions:

```shell
git clone https://github.com/BrowserBox/BrowserBox.git
cd BrowserBox
./deploy-scripts/global_install.sh <my_hostname> <my_email>
setup_bbpro --port <my_port>
bbpro
```

-----

## Docker Quick Start :gem: *Version 6*

**November 4 2023**: New version released. Docker image v6.

First ensure you have docker installed and running! :) Then run:

```console
PORT=8080 # or your preferred port
bash <(curl -s https://raw.githubusercontent.com/BrowserBox/BrowserBox/f2162a8553c0f91068127bd3063eaf2fdc4d005d/deploy-scripts/run_docker.sh) $PORT
```

That's it! Follow the prompts to set up certificates and it will emit a link that you can send open in any web browser. 

**Update:** Docker image now works on macOS!!! 🎉

-----

# *Special Event!* 🤙 Create a private ephemeral Web Proxy hosted on your GitHub Actions minutes by opening an issue on this repo

**HOLD UP** You need to [fork](../../fork) or [generate](../../generate) this repo first, so you have your own copy. Then open an issue and you will be guided through the process (1 manual step, rest is automatic), while your browser VPN is created. 

By default they remain open for 5 minutes, but you can make that longer by editing the workflow YAML file. Each minute used counts against your GitHub actions quota. Also, don't do anything abusive with this, remember you are browsing the web from inside GitHub's infrastructure (actions runners), so treat them with respect!

Limitations: no audio, no DevTools, no docviewer (Because the ports are not accesible, although the services are running)

-----

# BrowserBox - General README

BrowserBox is a leading-edge solution in the Zero Trust landscape, enabling embeddable multiplayer browsers in any web page on any device. Our cybersecurity focus is on ensuring that every web interaction is treated as potentially hostile, and isolating it, so that we protect your devices and network from harm. 

## BrowserBox Availability

**Cross-platform support status:**

| Platform                 | Status       |
|--------------------------|--------------|
| Docker                   | ✅           |
| Ubuntu                   | ✅           |
| Debian                   | ✅           |
| CentOS 9                 | ✅           |
| macOS                    | ✅           |
| Amazon Linux (AWS EC2)   | ✅           |
| Windows\*                | ❌           |
| Windows WSL              | ✅           |

\*Windows support is currently in development, but not yet officially supported.

**Content delivery services status:**


| Channel                  | Browser Service       | Audio    | Secure Document Viewer | Remote DevTools | WebRTC |
|--------------------------|-----------------------|----------|------------------------|-----------------|--------|
| HTTPS/DNS                | ✅                    | ✅        | ✅                     | ✅               | ✅     |
| Installed Web App (PWA)  | ✅                    | ✅        | ✅                     | ✅               | ✅     |
| Tor Hidden Service       | ✅                    | ✅        | ✅                     | ✅               | ❌     |
| SSH Tunnel               | ✅                    | ✅        | ✅                     | ✅               | ✅     |
| ngrok*                   | ✅                    | ❌        | ❌                     | ❌               | ✅     |

\*audio, doc viewer, remote devtools not currently configured to work with ngrok, but support will be added in future. 

# Web application virtualization via Zero Trust Remote Browser Isolation and Secure Document Gateway

By leveraging the principles of Remote Browser Isolation (RBI), real-time streaming and collaborative browserin (co-browsing or "multiplayer browsers"), BrowserBoxPro ensures that no web content directly interacts with the end user's device, while remaining accessible through a shareable, collaborative interface. 

This guide will walk you through the seamless integration of BrowserBoxPro into your Zero Trust architecture.

# Table of Contents

- [BrowserBox: Zero Trust Browsing](#browserbox-zero-trust-browsing)
  - [Embracing Zero Trust with BrowserBox](#embracing-zero-trust-with-browserbox)
  - [Key Features](#key-features)
  - [Deploying BrowserBoxPro in a Zero Trust Environment with Docker](#deploying-browserboxpro-in-a-zero-trust-environment-with-docker)
  - [Zero Trust Installation Guide](#zero-trust-installation-guide)
  - [Installation](#installation)
    - [Initial Machine Setup](#initial-machine-setup)
    - [Installation Process](#installation-process)
  - [Applications in a Zero Trust Framework](#applications-in-a-zero-trust-framework)
    - [Product Space Applications](#product-space-applications)
    - [Creative Ways that Clients are Using BrowserBox](#creative-ways-that-clients-are-using-browserbox)
    - [Internal Tooling Applications](#internal-tooling-applications)
    - [Tech and Framework Applications](#tech-and-framework-applications)
  - [Features of BrowserBox Pro in a Zero Trust Environment](#features-of-browserbox-pro-in-a-zero-trust-environment)
  - [Licensing for Zero Trust](#licensing-for-zero-trust)
    - [Purchasing a commercial license](#purchasing-a-commercial-license)
    - [Hardware Appliance (OEM) Licensing](#hardware-appliance-oem-licensing)
    - [Sanctions Compliance](#sanctions-compliance)
    - [Licensing Summary](#licensing-summary)
  - [Pricing](#pricing)
  - [Elevate Your Zero Trust Strategy with BrowserBoxPro](#elevate-your-zero-trust-strategy-with-browserboxpro)
  - [Copyright](#copyright)

## Embracing Zero Trust with BrowserBox

In the evolving cybersecurity landscape, the Zero Trust model has emerged as a cornerstone. By assuming no trust by default and verifying every access request irrespective of its source, Zero Trust ensures robust security. BrowserBoxPro is at the forefront of this paradigm shift, offering:

- **Web Isolation**: Every web session is isolated, ensuring malicious content doesn't reach the end-user's device.
- **Co-Browsing**: Collaborative browsing without compromising security.
- **Zero Trust Integration**: Easily integrates into your existing Zero Trust infrastructure.

For the latest on how BrowserBox is shaping the Zero Trust landscape, visit our [Company Blog](https://blog.dosyago.com).

- [Updated Pricing](https://dosyago.com) - now with even more tiers for smaller use cases!
- [BrowserBox Pro Goes Open Source with Multiple Licenses
](https://blog.dosyago.com/2023/06/26/browserbox-pro-goes-open-source-with-multiple-licenses.html)
- [Tunnelling over SSH - You're guide to using Localhost Certificates and SSH port-forwarding to run BrowserBox Pro on a remote machine without a domain name, using SSH tunneling](https://blog.dosyago.com/tutorials/2023/06/17/tunneling-browserbox-pro-over-SSH-complete-guide-to-using-port-forwarding-to-run-RBI-on-a-router.html)

## Key Features

- **Advanced Streaming**: BrowserBoxPro offers advanced streaming capabilities, allowing you to seamlessly browse websites, stream videos, and access web applications with superior performance.
- **Enhanced Feature Set**: Enjoy a wide range of enhanced features that enhance your browsing experience, including improved security, customizable settings, and optimized resource management.
- **Superior Performance**: BrowserBoxPro delivers exceptional performance, ensuring smooth and responsive browsing even for resource-intensive websites and applications.
- **Flexible Usage**: Whether you are a non-commercial user or using BrowserBoxPro for commercial purposes, you can benefit from the full range of pro features to enhance your browsing capabilities.

## Deploying BrowserBoxPro in a Zero Trust Environment with Docker

Before diving in, ensure you have [docker](https://www.docker.com/) installed!

Deploying BrowserBoxPro within a Zero Trust framework is straightforward:

1. Obtain the latest Docker container for BrowserBoxPro from our [packages page](https://github.com/orgs/dosyago/packages/container/package/browserboxpro) on GitHub Container Registry.

2. Deploy the Docker container using our Zero Trust compliant run script. Choose a primary port number (`$PORT`) ensuring two extra ports are free both preceding and succeeding `$PORT`. Deploy by running:

```console
PORT=8080 # or your preferred port
bash <(curl -s https://raw.githubusercontent.com/BrowserBox/BrowserBox/2034ab18fd5410f3cd78b6d1d1ae8d099e8cf9e1/deploy-scripts/run_docker.sh) $PORT
```

Upon successful deployment, BrowserBoxPro will be operational, reinforcing your Zero Trust strategy. Access the browser using the provided login link: `https://<your-host>:$PORT/login?token=<random token>`.

For support or to purchase licenses, connect with us at sales@dosyago.com or visit: https://dosyago.com.

## Zero Trust Installation Guide

**🌟 Video Installation Guide for Pro: [https://youtu.be/cGUJCCPDWNE](https://youtu.be/cGUJCCPDWNE)**

For detailed information and progress updates, please refer to the [official documentation](https://github.com/dosyago/BrowserBox).

## Installation

Follow these instructions to install BrowserBoxPro on your system.

### Initial Machine Setup

Before installing BrowserBoxPro, ensure that your system meets the following requirements:

- Debian VPS with 1 cores, 1 GB RAM, and 25 GB SSD (e.g. Nanode from Linode)
- At least 5 Mbps internet connection
- A public hostname with a DNS A record pointing to your VPS's IP address, or localhost certificates installed on your local and remote machine (for example using [mkcert](https://github.com/FiloSottile/mkcert))

First, update your distribution:

`apt update && apt -y upgrade`

And install a few basic tools:

`apt install curl git wget`

Now, prepare the machine by following these steps:

1. Create a new user to operate BrowserBoxPro:
   ```
   adduser pro
   ```

2. Disable the password for the newly created user:
   ```
   usermod -L pro
   ```

3. Create a new group for sudo privileges:
   ```
   addgroup sudoers
   ```

4. Add the following line to the sudoers file to avoid entering a password for sudo operations:
   ```
   %sudoers ALL=(ALL) NOPASSWD:ALL
   ```
   Use the `visudo` command to edit the sudoers file.

5. Grant sudo privileges to the user:
   ```
   usermod -G sudoers pro
   ```

Switch to the `pro` user by executing the following command:
```
sudo -u pro bash
```

### Installation Process

Follow these steps to install BrowserBoxPro:

1. Clone the BrowserBoxPro repository:
   ```
   git clone https://github.com/dosyago/BrowserBoxPro
   ```

2. Navigate to the cloned repository:
   ```
   cd BrowserBoxPro
   ```

3. Run the global installation script, replacing `<domain_name>` with your domain name that points to the machine you're setting up (if you want to use it without a domain name, just use localhost here for the domain name, but you'll still need to copy the correct mkcert localsthost certificates to $HOME/sslcerts later):
   ```
   ./deploy-scripts/global_install.sh <domain_name>
   ```

4. Start the main service on port 8080 and generate the login link:
   ```
   setup_bbpro --port 8080
   ```

5. Launch BrowserBox:
   ```
   bbpro
   ```

During the installation process, BrowserBoxPro will automatically install the required dependencies and configure the necessary settings.

## Applications in a Zero Trust Framework

BrowserBoxPro isn't just a tool; it's a comprehensive solution designed to fit seamlessly into a Zero Trust architecture. Here's how:

### Product Space Applications:

- **Remote Browser Isolation**: Fundamental to Zero Trust, ensuring no direct content interaction with user devices.
- **Co-Browsing**: Collaborate without compromising on security.
- **VPN Alternatives**: A more secure solution than traditional VPNs.
- **Email Threat Mitigation**: Content Disarm & Reconstruction (CDR) ensures safe email attachments.
- **Secure Web Interaction**: A user-friendly UI for secure third-party processes.

### Creative Ways that Clients are Using BrowserBox 

- A user-friendly UI that allows clients to perform 3rd-party processes without leaving your website.
- A fully customizable online hosted web browser that provides an alternative to downloadable browsers.
- The ability to record web app interactions to document bugs by capturing the event stream and viewport.
- A mechanism to create visual "How-To" guides illustrating key user stories.

### Internal Tooling Applications:

- A tool for human-in-the-loop intervention to resolve stuck browser automation jobs and identify "selector drift" and script-page mismatch issues.
- A robust web proxy to seamlessly integrate 3rd-party processes lacking APIs.
- An interactive console to inspect, observe, and interact with browser automation tasks.
- A browser that can be automated, offering effective evasion of bot detection mechanisms that target pure headless Chrome.
- A scriptable console and interactive simulator for automation tasks, creating an intuitive feedback loop.

### Tech and Framework Applications:

- An open web `<WebView>` tag.
- An `<iframe>` without cross-origin restrictions.
- A 'head' for headless browsers.

For a comprehensive list of features and their availability in BrowserBoxPro, refer to the feature table below.

## Features of BrowserBox Pro in a Zero Trust Environment

BrowserBox Pro offers an array of advanced features that set it apart from other versions of remote browser isolation. With fully open source-code, non-commercial use for free, frequent updates and cutting-edge technology, BrowserBox Pro provides an enhanced browsing experience with superior rendering, top-tier graphics, and minimal lag. Here are the key features of BrowserBox Pro:

- Advanced streaming technology and variable bitrate innovations for smoother browsing experience
- Superior rendering and graphics capabilities
- Structured, weekly update schedule with quarterly major improvements
- Exclusive advanced features not available in other versions
- Commercial use availability with Individual server and Self-hosted options
- Advanced security mechanisms and privacy safeguards
- Customizable browser UI
- Docker image compatibility for easy deployment
- Cloud and platform independence
- Multi-user security features (Pro exclusive)
- Auto-scaling and resource control (Pro exclusive)
- WebRTC/WebSocket viewport streaming (Pro exclusive)
- Fastest-path lag reduction (Pro exclusive)
- Built-in multiplayer mode with chat (Pro exclusive)
- Puppeteer scripting REPL console (Pro exclusive)
- Embeddable inside `<iframe>` (Pro exclusive)
- Kiosk mode (Pro exclusive)
- Adobe Flash Player compatibility (Pro exclusive)
- User-friendly API (Pro exclusive)
- SSH tunneling (Pro exclusive)

These features make BrowserBox Pro the ideal choice for businesses and organizations looking to enhance their cybersecurity, privacy, and browsing capabilities.

For more information about commercial options and licensing, please refer to the relevant sections below.

## Licensing for Zero Trust

BrowserBoxPro is licensed separately under the following licenses:

- [GNU Affero General Public License v3 (or later)](LICENSES/AGPL-3.0.txt)
- [Polyform Non-Commercial License 1.0](LICENSES/PolyForm-Noncommercial-1.0.0.md)
- [BrowserBox Pro perpetual commercial license](LICENSES/LicenseRef-BBP-Commercial-Perpetual.md)
- [BrowserBox Pro subscription commercial license](LICENSES/LicenseRef-BBP-Commercial-Subscription.md)

#### What does this mean for me?

##### Are you using BrowserBox Pro as it ships?

  You may use BrowserBox Pro under the terms of the AGPLv3 (or later).

##### Are you modifying BrowserBox Pro or developing software that uses BrowserBox Pro and willing to license those changes under the AGPL?

  You may use BrowserBox Pro under the terms of the AGPLv3 (or later).

##### Are you using BrowserBox Pro, modifying BrowserBox Pro, or developing software that uses BrowserBox Pro in a non-commercial capacity but do not wish to comply with the license terms of the AGPLv3?

  You may use BrowserBox Pro under the terms of the Polyform Non-Commercial License 1.0.0.

##### Are you using BrowserBox Pro, modifying BrowserBox Pro, or developing software that uses BrowserBox Pro in a commercial capacity but do not wish to comply with the license terms of the AGPLv3?

  You may purchase a [perpetual or subscription based commercial license](#purchasing-a-commercial-license).

### Purchasing a commercial license

Purchasing takes a minute. Our purchasing form accepts credit cards, bank transfers and many other forms of payment. Once purchased, you'll receive a commercial license PDF including your agreement and valid Order receipt and you will be all set to use BrowserBox Pro in your commercial applications. With the purchase of a commercial license:

- You may use BrowserBox Pro in as many commercial applications you like.
- You may use BrowserBox Pro in your own commercial applications and products. For example: premium VPN services, RBI systems, system integration portals, web automation and scraping products, educational platforms, and other products and apps.
- Customers and users of your products do not need to purchase their own license &mdash; so long as they are not developing their own commercial products with BrowserBox Pro.

*Please note that we cannot transact with sanctioned countries, entities or individuals.* 

Commercial Licenses are priced per seat. A seat is someone who uses the BrowserBox Pro system, either in an internal application (like secure email attachment viewing), or an external customer-facing application (such as a customer of your remote browser isolation product). Commercial Licenses come in two flavors:

- **Perpetual License** This is a license to use the version of BrowserBox Pro you purchase forever. The version can be updated to the latest via purchase of yearly licenses.
- **Yearly License** This is a license to use the latest version available within the 12-months from your purchase. It can be manually renewed every year, or you can subscribe so it renews automatically.

Commercial Licenses are available in two sizes:

- **Individual License** Purchasable at [our GumRoad site](https://dosyo.gumroad.com). This is suitable for individuals or small teams working on commercial projects who don't want to use the AGPLv3.
- **License Pack** Available in multiple sizes, from the small to the truly epic, with commensurately epic discounts at scale. These are purchasable at [our main website](https://dosyago.com).

By obtaining a commercial license, you gain the freedom to tailor BrowserBox Pro to your specific requirements and integrate it seamlessly into your workflow. This empowers organizations to leverage the advanced features and capabilities of BrowserBox Pro while maintaining full control over its customization and usage. 

Support tiers and customization may be separately negotiated and purchased. To discuss your needs, please [reach out to our helpful support team here](mailto:support@dosyago.com?subject=BrowserBox%20Pro).

### Hardware Appliance (OEM) Licensing

Are you an OEM and want to deploy BBPro on a hardware device that you sell to your customers? [Contact us for special access to Appliance License pricing with Volume Discounts](mailto:sales@dosyago.com?subject=OEM%20License). This pricing sheet and terms are tailored to suit OEM's delivering security products for business and industry. Please note that if you are supplying government or other non-commercial users you cannot "pass through" DOSYAGO's non-commercial license to your customers without licensing a Commercial license from us. 

### Sanctions Compliance

Unfotunately if you or your company are an OFAC sanctioned entity or other entity sanctioned by the US Government (e.g. designated on OFAC's SDN List, BIS's DPL or Entity List, DDTC's DPL, or on the FBI's various lists, among others) we are unable to offer you a license of any form. Please note that in some cases we may conduct necessary checks to ensure sanctions compliance. 

### Licensing Summary 

BrowserBox Pro offers flexible licensing options to cater to different usage scenarios. As previously mentioned, BBPro software is available for free for non-commercial use under the PolyForm NonCommercial license. This allows individuals and non-profit organizations to enjoy the benefits of BrowserBox Pro without any licensing fees when using the software without any participation in or anticipation of commercial application. The PolyForm NonCommercial license ensures that the software is used strictly for non-commercial purposes.

Whether it's for non-commercial or commercial purposes, BrowserBox Pro provides a range of licensing options to accommodate different user needs and ensure a secure and powerful browsing experience.

-----

## Pricing

See [our website](https://dosyago.com) and [our GumRoad](https://dosy.gumroad.com) for accurate latest pricing or [reach out to us](mailto:sales@dosyago.com?subject=Pricing), but here is a summary below:

| License Type | Quantity | Price Per Unit/Pack | Includes |
| :----------: | :------: | :-----------------: | :------ |
| Yearly | Up to 1 | $84/seat/year | <ul><li>Purchase from 1 to 1 million licenses</li><li>Each license is valid for 1 year</li><li>Volume discounts for multiple licenses</li><li>Source code access</li><li>Use in customer-facing products or internally</li><li>Email support</li><li>Additional support tiers purchasable</li><li>Customize yourself or contract us</li></ul> |
| Yearly | 2-50 | $64.92 | Same as above |
| Yearly | 51-500 | $46.25 | Same as above |
| Yearly | 501-5000 | $35.58 | Same as above |
| Yearly | 5001-100000 | $10.67 | Same as above |
| Yearly | 100001+ | $9.99 | Same as above |
| Perpetual | 10-pack | $1,947.60 | <ul><li>Use forever</li><li>Email support for 1 year</li><li>Optionally buy more support</li><li>Use in customer-facing products or internally</li><li>Customize source code yourself, or contract us</li></ul> |
| Perpetual | 100-pack | $13,875.00 | Same as above |
| Perpetual | 10,000-pack | $320,100.00 | Same as above |

**Notes:**
- *Perpetual Packs contain multiple seats. For example, the 10-pack contains 10 licenses.*
- *Each 'seat' represents a concurrent user.*

## Elevate Your Zero Trust Strategy with BrowserBoxPro

In the modern digital landscape, Zero Trust isn't just a model; it's a necessity. BrowserBoxPro stands as a testament to this, offering an unparalleled browsing experience while ensuring every interaction is verified, validated, and secure.

Our commitment goes beyond just providing a product. We offer a partnership, ensuring that as the cybersecurity landscape evolves, so do our solutions. With BrowserBoxPro, you're not just adopting a tool; you're embracing a future where every interaction is secure.

Join us in navigating the Zero Trust landscape. Secure your commercial license today and fortify your cybersecurity strategy with BrowserBoxPro.

## Copyright

This project is copyright The Dosyago Corporation 2018-2023. All rights reserved.

For detailed information and progress updates, please refer to the [official documentation](https://github.com/dosyago/BrowserBox).
