# Setup a package mirror.
echo "https://ftp.usa.openbsd.org/pub/OpenBSD/" > /etc/installurl

# Update the system.
pkg_add -u

# Install a few basic tools.
pkg_add -I curl wget bash sudo-- vim--no_x11 git zsh rsync

# Since most scripts expect bash to be in the bin directory, create a symlink.
ln -s /usr/local/bin/bash /bin/bash

# Merge in each directory individually
rsync -abuP etc/ /etc/

# /tftpboot
rsync -abuP tftpboot/ /tftpboot
cp /usr/mdec/pxeboot /tftpboot
cp /bsd.rd /tftpboot

# /usr/local scripts
rsync -abuP usr/local/ /usr/local/
/usr/local/bin/malware.sh
/usr/local/bin/adhosts.sh

# Requires unbound setup first
/usr/local/bin/dnsblock.sh

# Requires acme-client to be setup
/usr/local/bin/get-oscp.sh ${HOSTNAME}
/usr/local/bin/get-pin.sh

rsync -abuP var/ /var/

# Initialize the locate database.
ln -s /usr/libexec/locate.updatedb /usr/bin/updatedb
/usr/libexec/locate.updatedb

# Reboot gracefully.
shutdown -r +1 &

syspatch
