#!/bin/bash
#
# Script Name  : install.sh
# Description  : A custom message of the day (MOTD) for Raspberry Pi OS.
# Version      : 0.1.0
# Author       : Iolar Demartini Junior
# URL          : https://github.com/demartini/raspberrypi-motd
#
# Script borrowed from https://github.com/starship/starship
#
# Options
#
#   -V, --verbose
#     Enable verbose output for the installer
#
#   -f, -y, --force, --yes
#     Skip the confirmation prompt during installation
#
#   -l, --layout
#     Skip the layout selection prompt during installation
#
#   -d, --install-dir
#     Override the installation directory
#
#   -B, --base-url
#     Override the base URL used for downloading releases

set -euo pipefail
printf "\n"

BOLD="$(tput bold 2>/dev/null || echo '')"
GREY="$(tput setaf 0 2>/dev/null || echo '')"
UNDERLINE="$(tput smul 2>/dev/null || echo '')"
RED="$(tput setaf 1 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
BLUE="$(tput setaf 4 2>/dev/null || echo '')"
MAGENTA="$(tput setaf 5 2>/dev/null || echo '')"
NO_COLOR="$(tput sgr0 2>/dev/null || echo '')"

info() {
  printf "%s\n" "${BOLD}${GREY}>${NO_COLOR} $*"
}

warn() {
  printf "%s\n" "${YELLOW}! $*${NO_COLOR}"
}

error() {
  printf "%s\n" "${RED}x $*${NO_COLOR}" >&2
}

complete() {
  printf "%s\n" "${GREEN}✓${NO_COLOR} $*"
}

# Test if a location is writeable by trying to write to it.
test_writeable() {
  local path
  path="${1:-}/test.txt"
  if touch "${path}" 2>/dev/null; then
    rm "${path}"
    return 0
  else
    return 1
  fi
}

fetch() {
  local command
  if hash curl 2>/dev/null; then
    set +e
    command="curl --silent --fail --location $1"
    curl --silent --fail --location "$1"
    rc=$?
    set -e
  else
    if hash wget 2>/dev/null; then
      set +e
      command="wget -O- -q $1"
      wget -O- -q "$1"
      rc=$?
      set -e
    else
      error "No HTTP download program (curl, wget) found…"
      exit 1
    fi
  fi

  if [ $rc -ne 0 ]; then
    printf "\n" >&2
    error "Command failed (exit code $rc): ${BLUE}${command}${NO_COLOR}"
    printf "\n" >&2
    info "This is likely due to script not yet supporting your configuration." >&2
    exit $rc
  fi
}

fetch_and_unpack() {
  local sudo
  sudo="$1"
  fetch "${BASE_URL}/latest/download/raspberrypi-motd-${LAYOUT}.tar.gz" | ${sudo} tar xz"${VERBOSE}"f - -C "${INSTALL_DIR}"
}

elevate_priv() {
  if ! hash sudo 2>/dev/null; then
    error 'Could not find the command "sudo", needed to get permissions for install.'
    exit 1
  fi
  if ! sudo -v; then
    error "Superuser not granted, aborting installation."
    exit 1
  fi
}

install() {
  local msg
  local sudo

  if test_writeable "${INSTALL_DIR}"; then
    sudo=""
    msg="Installing, please wait…"
  else
    warn "Escalated permission are required to install to ${INSTALL_DIR}"
    elevate_priv
    sudo="sudo"
    msg="Installing as root, please wait…"
  fi

  if [ -n "${LAYOUT-}" ]; then
    true
  else
    layout_selection
  fi

  info "$msg"
  fetch_and_unpack "${sudo}"

  info "Changing the file owner..."
  sudo chown root:root "${INSTALL_DIR}"/motd.sh
  complete "Done!"

  info "Setting execution permissions..."
  sudo chmod +x "${INSTALL_DIR}"/motd.sh
  complete "Done!"

  FILE=/etc/motd
  if [ -f "$FILE" ]; then
    info "Removing the default MOTD..."
    sudo mv /etc/motd /etc/motd.orig
    complete "Done!"
  else
    warn "The $FILE file does not exist."
  fi
}

# Available layout:
#   - horizontal
#   - vertical
layout_selection() {
  info "Which layout do you want to install?"
  PS3="$(info)Select a option: "

  select LAYOUT in horizontal vertical; do

    case $LAYOUT in
    horizontal)
      complete "Horizontal layout selected."
      break
      ;;
    vertical)
      complete "Vertical layout selected."
      break
      ;;
    *)
      error "Invalid option $REPLY, please try again!"
      ;;
    esac
  done
}

confirm() {
  if [ -z "${FORCE-}" ]; then
    printf "%s " "${MAGENTA}?${NO_COLOR} $* ${BOLD}[y/N]${NO_COLOR}"
    set +e
    read -r yn </dev/tty
    rc=$?
    set -e
    if [ $rc -ne 0 ]; then
      error 'Error reading from prompt (please re-run with the --yes option).'
      exit 1
    fi
    if [ "$yn" != "y" ] && [ "$yn" != "yes" ]; then
      error 'Aborting (please answer "yes" to continue).'
      exit 1
    fi
  fi
}

check_install_dir() {
  if [ ! -d "$INSTALL_DIR" ]; then
    error "The installation location $INSTALL_DIR does not appear to be a directory."
    info "Make sure the location exists and is a directory, then try again."
    exit 1
  fi
}

# defaults
if [ -z "${INSTALL_DIR-}" ]; then
  INSTALL_DIR=/etc/profile.d
fi

if [ -z "${BASE_URL-}" ]; then
  BASE_URL="https://github.com/demartini/raspberrypi-motd/releases"
fi

# parse argv variables
while [ "$#" -gt 0 ]; do
  case "$1" in
  -l | --layout)
    LAYOUT="$2"
    shift 2
    ;;
  -d | --install-dir)
    INSTALL_DIR="$2"
    shift 2
    ;;
  -B | --base-url)
    BASE_URL="$2"
    shift 2
    ;;

  -V | --verbose)
    VERBOSE=1
    shift 1
    ;;
  -f | -y | --force | --yes)
    FORCE=1
    shift 1
    ;;

  -l=* | --layout=*)
    LAYOUT="${1#*=}"
    shift 1
    ;;
  -d=* | --install-dir=*)
    INSTALL_DIR="${1#*=}"
    shift 1
    ;;
  -B=* | --base-url=*)
    BASE_URL="${1#*=}"
    shift 1
    ;;
  -V=* | --verbose=*)
    VERBOSE="${1#*=}"
    shift 1
    ;;
  -f=* | -y=* | --force=* | --yes=*)
    FORCE="${1#*=}"
    shift 1
    ;;

  *)
    error "Unknown option: $1"
    exit 1
    ;;
  esac
done

printf "  %s\n" "${UNDERLINE}Configuration${NO_COLOR}"
info "${BOLD}Installation directory${NO_COLOR}: ${GREEN}${INSTALL_DIR}${NO_COLOR}"

if [ -n "${LAYOUT-}" ]; then
  LAYOUT=${LAYOUT}
  info "${BOLD}Layout${NO_COLOR}: ${LAYOUT}"
else
  true
fi

# non-empty VERBOSE enables verbose untarring
if [ -n "${VERBOSE-}" ]; then
  VERBOSE=v
  info "${BOLD}Verbose${NO_COLOR}: yes"
else
  VERBOSE=
fi

confirm "Do you want to install ${BOLD}${GREEN}MOTD${NO_COLOR} to ${BOLD}${GREEN}${INSTALL_DIR}${NO_COLOR}?"
check_install_dir "${INSTALL_DIR}"

install
complete "MOTD has been successfully installed. Have fun!"

echo
echo
info "${UNDERLINE}Please follow the steps to complete the installation:${NO_COLOR}"
echo
info "Remove the ${BLUE}last login${NO_COLOR} information disabling
  the ${BLUE}PrintLastLog${NO_COLOR} option from the ${BLUE}sshd${NO_COLOR} service."
echo
info "Edit the ${BLUE}/etc/ssh/sshd_config${NO_COLOR} file:
    ${GREEN}sudo nano /etc/ssh/sshd_config${NO_COLOR}"
echo
info "Uncomment and change the following line from:
    ${GREEN}#PrintLastLog yes${NO_COLOR}"
echo
info "to
    ${GREEN}PrintLastLog no${NO_COLOR}"
echo
info "Then restart the ${BLUE}sshd${NO_COLOR} service:
    ${GREEN}sudo systemctl restart sshd${NO_COLOR}"
