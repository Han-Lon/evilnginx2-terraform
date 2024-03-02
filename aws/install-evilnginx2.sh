#!/bin/bash
DEBIAN_FRONTEND=noninteractive apt-get update -y && \
  DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" dist-upgrade -y && \
  # These libs are only needed for the build of evilnginx2 from source
  DEBIAN_FRONTEND=noninteractive apt-get -o "Dpkg::Options::=--force-confold" install git nodejs npm -y

# Install golang 1.22 (only needed for building evilnginx2 from source)
wget -O /home/admin/go1.22.0.linux-amd64.tar.gz https://go.dev/dl/go1.22.0.linux-amd64.tar.gz && \
  rm -rf /usr/local/go && tar -C /usr/local -xzf /home/admin/go1.22.0.linux-amd64.tar.gz

# Set PATH and other necessary environment variables
echo "export GOROOT=/usr/local/go" >> /etc/profile
echo "export GOPATH=\$HOME/go" >> /etc/profile
echo "export PATH=\$PATH:/usr/local/go/bin:\$GOPATH/bin" >> /etc/profile

# Apply the environment variables immediately for the current session
export HOME=/home/admin
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

# Honestly the build process as a whole doesn't need to be executed every time the instance(s) spin up
# Can just build on a dedicated builder instance and ship to S3 or something, then download to live host
git clone https://github.com/kgretzky/evilginx2.git /home/admin/evilnginx2-source && \
    make -C /home/admin/evilnginx2-source

mkdir -p /home/admin/evilnginx/phishlets
mkdir /home/admin/evilnginx/redirectors
cp -r /home/admin/evilnginx2-source/build/* /home/admin/evilnginx

# Install an example phishlet from someone's repo
curl -o /home/admin/evilnginx/phishlets/westernunion.yaml https://raw.githubusercontent.com/An0nUD4Y/Evilginx2-Phishlets/master/westernunion.yaml

# Set ownership of generated files to appropriate user
chown -R admin:admin /home/admin/

# Cleanup
rm -rf /home/admin/go1.22.0.linux-amd64.tar.gz