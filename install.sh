#! /usr/bin/env bash
#
# some functions were gracefully copied from https://github.com/Homebrew/install/blob/master/install.sh
#
set -e

# invalidate sudo
sudo -k

ENV_FILE=~/.env
HOMESERVER_PATH=~/.homeserver

# string formatters
if [[ -t 1 ]]
then
  tty_escape() { printf "\033[%sm" "$1"; }
else
  tty_escape() { :; }
fi

tty_mkbold() { tty_escape "1;$1"; }
tty_underline="$(tty_escape "4;39")"
tty_blue="$(tty_mkbold 34)"
tty_red="$(tty_mkbold 31)"
tty_bold="$(tty_mkbold 39)"
tty_reset="$(tty_escape 0)"

chomp() {
  printf "%s" "${1/"$'\n'"/}"
}

shell_join() {
  local arg
  printf "%s" "$1"
  shift
  for arg in "$@"
  do
    printf " "
    printf "%s" "${arg// /\ }"
  done
}

ohai() {
  printf "${tty_blue}==>${tty_bold} %s${tty_reset}\n" "$(shell_join "$@")"
}

warn() {
  printf "${tty_red}Warning${tty_reset}: %s\n" "$(chomp "$1")"
}

abort() {
  printf "${tty_bold}${tty_red}ABORT${tty_reset}: %s\n" "$(chomp "$1")" >&2
  exit 1
}

ohai "sudo is required to proceed"
sudo -v

ohai "Updating packages"
sudo apt-get update -y

ohai "Installing dependencies (avahi, git, ssh)"
sudo apt-get install -y \
  avahi-daemon \
  git \
  openssh-server

# read uses the standard input by default. when you use the pipe, standard input is the pipe, not the terminal
# https://stackoverflow.com/a/69665025
#
ohai "Set your hostname (currently is '$(hostname)', leave it blank to keep as is):"
read hostname </dev/tty

if [ -z "$hostname" ];
then
  ohai "Alright, we'll keep your hostname as '$(hostname)'"
else
  ohai "Cool, we're changing your hostname to '$hostname'"
  
  sudo hostnamectl set-hostname $hostname
fi

ohai "Your home-server will be available on '$(hostname).local' inside your LAN"

if [ ! -f "$ENV_FILE" ];
then
  touch $ENV_FILE

  echo "PUID=$(id -u)" >> $ENV_FILE
  echo "PGID=$(id -g)" >> $ENV_FILE
  echo "TZ=$(cat /etc/timezone)" >> $ENV_FILE
  echo "HOMESERVER_PATH=$HOMESERVER_PATH" >> $ENV_FILE

  ohai "Added home-server '.env'"
else
  ohai "Home-server '.env' already exists"
fi

if [ -d "$HOMESERVER_PATH" ];
then
  ohai "Your home-server is already installed at $HOMESERVER_PATH"
  ohai "Updating home-server repo"

  cd $HOMESERVER_PATH && git pull
else
  ohai "Your home-server will be installed at $HOMESERVER_PATH"
  ohai "Cloning home-server repo"

  git clone https://github.com/emaiax/home-server $HOMESERVER_PATH
fi

ohai "Cleaning up..."
sudo apt-get autoclean -y && sudo apt-get autoremove -y

ohai "Restarting services..."
sudo systemctl restart avahi-daemon
sudo systemctl restart ssh

# invalidate sudo
sudo -k

ohai "You can SSH into your home-server now"
ohai "We're ready to go!"
