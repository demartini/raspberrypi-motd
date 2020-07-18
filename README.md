<div align="center">
  <a href="https://github.com/demartini/raspberrypi-motd">
    <img src="images/logo.png" alt="Logo" width="120">
  </a>
</div>
<h1 align="center">MOTD for Raspberry Pi OS</h1>
<h5 align="center">A custom message of the day (MOTD) for Raspberry Pi OS.</h5>
<br>
<div align="center">
  <a href="https://github.com/demartini/raspberrypi-motd/actions?query=workflow%3AMain">
  <img src="https://img.shields.io/github/workflow/status/demartini/raspberrypi-motd/Main?logo=github&style=for-the-badge" alt="GitHub Workflow Status">
  </a>
  <a href="https://github.com/demartini/raspberrypi-motd/stargazers">
    <img src="https://img.shields.io/github/stars/demartini/raspberrypi-motd?style=for-the-badge" alt="GitHub stars">
  </a>
  <a href="https://github.com/demartini/raspberrypi-motd/network/members">
    <img src="https://img.shields.io/github/forks/demartini/raspberrypi-motd?style=for-the-badge" alt="GitHub forks">
  </a>
  <a href="https://github.com/demartini/raspberrypi-motd/issues">
    <img src="https://img.shields.io/github/issues/demartini/raspberrypi-motd?style=for-the-badge" alt="GitHub issues">
  </a>
  <a href="https://github.com/demartini/raspberrypi-motd/graphs/contributors">
    <img src="https://img.shields.io/github/contributors/demartini/raspberrypi-motd?style=for-the-badge" alt="GitHub contributors">
  </a>
  <a href="https://github.com/demartini/raspberrypi-motd/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/demartini/raspberrypi-motd?style=for-the-badge" alt="GitHub">
  </a>
</div>
<br>
<p align="center">
  <a href="https://github.com/demartini/raspberrypi-motd/wiki">Explore the Docs</a>
  -
  <a href="https://github.com/demartini/raspberrypi-motd/issues">Report Bug</a>
  -
  <a href="https://github.com/demartini/raspberrypi-motd/issues">Request Feature</a>
</p>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Screenshots](#screenshots)
- [Highlights](#highlights)
- [Installation](#installation)
  - [One-Step Automated Install](#one-step-automated-install)
- [Alternative Install Method](#alternative-install-method)
  - [Clone our Repository and Run](#clone-our-repository-and-run)
- [Post-Install](#post-install)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
  - [Contributors](#contributors)
- [Inspired By](#inspired-by)
- [Changelog](#changelog)
- [License](#license)

## Screenshots

**Layout Horizontal**
<p align="center">
  <img src="images/motd-horizontal.svg" alt="Layout Horizontal" width="900">
</p>

**Layout Hertical**
<p align="center">
  <img src="images/motd-vertical.svg" alt="Layout Hertical" width="900">
</p>

## Highlights

- Written in pure [Bash](https://www.gnu.org/software/bash).
- There is no need to install any packages.
- Tested with Arch Linux ARM and [Raspberry Pi OS](https://www.raspberrypi.org/downloads/raspberry-pi-os) (previously called Raspbian) distributions.

The information displayed are:

- Date and Time
- Disk Space
- DNS Servers
- Hostname
- LAN IP
- Last Login
- Load Average
- Logged Users
- Memory
- Running Processes
- Temperature
- Uptime
- WAN IP
- Welcome Message

## Installation

### One-Step Automated Install

Those who want to get started quickly and conveniently may install using the following command:

```sh
$ curl -sSL https://git.io/install-raspberrypi-motd | bash
```

## Alternative Install Method

### Clone our Repository and Run

Those who wish to review the code before installation may install using the following command:

```sh
$ git clone https://github.com/demartini/raspberrypi-motd.git
$ sudo bash raspberrypi-motd/install/install.sh
```

## Post-Install

Follow the steps to complete the installation:

Remove the `last login` information disabling the `PrintLastLog` option from the `sshd` service editing the `/etc/ssh/sshd_config` file:

```sh
$ sudo nano /etc/ssh/sshd_config
```

Uncomment and change the following line from:

```sh
#PrintLastLog yes
```

to

```sh
PrintLastLog no
```

Then restart the `sshd` service:

```sh
$ sudo systemctl restart sshd
```

## Roadmap

See the [open issues](https://github.com/demartini/raspberrypi-motd/issues) for a list of proposed features (and known issues).

## Contributing

If you are interested in helping contribute, please take a look at our [Contributing](CONTRIBUTING.md) guide.

### Contributors

<a href="https://github.com/demartini/raspberrypi-motd/graphs/contributors">
  <img src="https://contributors-img.web.app/image?repo=demartini/raspberrypi-motd" />
</a>

## Inspired By

- [gagle/raspberrypi-motd](https://github.com/gagle/raspberrypi-motd)
- [Stuzer05/raspberrypi-motd](https://github.com/Stuzer05/raspberrypi-motd)
- [UncleInf/raspberrypi-motd](https://github.com/UncleInf/raspberrypi-motd)

## Changelog

See [Changelog](CHANGELOG.md) for a human-readable history of changes.

## License

Distributed under the MIT License. See [LICENSE](LICENSE) for more information.