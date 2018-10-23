# fl8s fork of `vedetta (alpha)`
*Open*BSD Router Boilerplate

![Vedetta Logo](https://avatars2.githubusercontent.com/u/29383850)
## About
> an opinionated, best practice, vanilla OpenBSD base configuration for bare-metal, or cloud routers

What would an OpenBSD router configured using examples from the OpenBSD FAQ and Manual pages look like?


## fl8s Changelog
Add some find and replace scripts to automate and customize vedetta for your environment/hostname/whatever. A more structured (config managed) approach would likely have taken the same amount of time, but where's the fun in that?

Added test scripts and some infrastructure to run inside [Vagrant](https://vagrantup.org) with some other hosts attached, to observe your changes. I'm hoping to figure out how to use it as an intermedieary between your box and the rest of the network.

## Features
Share what you've got, keep what you need:
* [acme-client](https://man.openbsd.org/acme-client) - Automatic Certificate Management Environment (ACME) client
  - *Configure:*
    - [`etc/acme`](src/etc/acme)
    - [`etc/acme-client.conf`](src/etc/acme-client.conf)
    - [`etc/httpd.conf`](src/etc/httpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/relayd.conf`](src/etc/relayd.conf)
    - [`etc/ssl/acme`](src/etc/ssl/acme)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
    - `var/www/htdocs/acme`
    - [`var/www/htdocs/freedns.afraid.org`](src/var/www/htdocs/freedns.afraid.org)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`acme-client`](https://man.openbsd.org/acme-client)` -vAD freedns.afraid.org`
    - [`usr/local/bin/get-ocsp.sh`](src/usr/local/bin/get-ocsp.sh)` freedns.afraid.org`
* [authpf](https://man.openbsd.org/authpf) - authenticating gateway user shell
  - *Configure:*
    - [`etc/authpf`](src/etc/authpf)
    - [`etc/login.conf`](src/etc/login.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/ssh/sshd_config`](src/etc/ssh/sshd_config)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` reload sshd`
    - [`ssh`](https://man.openbsd.org/ssh)` pauth@freedns.afraid.org`
* [autoinstall](https://man.openbsd.org/autoinstall) - unattended OpenBSD installation and upgrade ([pxeboot](https://man.openbsd.org/pxeboot) and [mirror](https://www.openbsd.org/ftp.html) example)
  - *Configure:*
    - [`etc/dhcpd.conf`](src/etc/dhcpd.conf)
    - [`etc/httpd.conf`](src/etc/httpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`tftpboot`](src/tftpboot)
    - [`var/www/htdocs/boot.vedetta.lan`](src/var/www/htdocs/boot.vedetta.lan)
    - `mount host:/path/name /var/www/pub`
  - *Usage:*
    - `mkdir -p /tftpboot/etc`
    - `cd /tftpboot && ftp https://ftp.openbsd.org/pub/OpenBSD/snapshots/amd64/bsd.rd`
    - `cp /usr/mdec/pxeboot /tftpboot/`
    - `chmod 555 -R /tftpboot`
    - `cd /tftpboot && ln -s pxeboot auto_install`
    - `echo "boot bsd.rd" > /tftpboot/etc/boot.conf && chmod 444 /tftpboot/etc/boot.conf`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set tftpd flags -l boot.vedetta.lan -v /tftpboot`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set tftpproxy flags -v`
    - [`rcctl`](https://man.openbsd.org/rcctl)` restart dhcpd httpd`[`tftpd`](https://man.openbsd.org/tftpd) [`tftpproxy`](https://man.openbsd.org/tftp-proxy)
* [dhclient](https://man.openbsd.org/dhclient) - Dynamic Host Configuration Protocol (DHCP) client
  - *Configure:*
    - [`etc/dhclient.conf`](src/etc/dhclient.conf)
    - [`etc/hostname.em0`](src/etc/hostname.em0)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`sh`](https://man.openbsd.org/sh)` /etc/netstart em0` *or*
    - [`dhclient`](https://man.openbsd.org/dhclient)` em0`
* [dhcpd](https://man.openbsd.org/dhcpd) - Dynamic Host Configuration Protocol (DHCP) server
  - *Configure:*
    - [`etc/dhcpd.conf`](src/etc/dhcpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set dhcpd flags athn0 em1 em2`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start dhcpd`
* (optional) [wide-dhcpv6](https://github.com/openbsd/ports/tree/master/net/wide-dhcpv6) - client and server for the WIDE DHCPv6 protocol
  - *Configure:*
    - [`etc/dhcp6s.conf`](src/etc/dhcp6s.conf)
    - `etc/dhcp6c.conf`
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/rc.d/dhcp6c`](src/etc/rc.d/dhcp6c)
    - [`etc/rc.d/dhcp6s`](src/etc/rc.d/dhcp6s)
    - [`etc/rtadvd.conf`](src/etc/rtadvd.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set dhcp6s flags -c /etc/dhcp6s.conf -dD -k /etc/dhcp6sctlkey em1`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start dhcp6s`
* [ftp-proxy](https://man.openbsd.org/ftp-proxy) - Internet File Transfer Protocol proxy daemon
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set ftp-proxy flags -b 10.10.10.10 -T FTP_PROXY`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set ftp-proxy6 flags -b fd80:1fe9:fcee:1337::ace:face -T FTP_PROXY6`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start ftp-proxy ftp-proxy6`
* [hostname.if](https://man.openbsd.org/hostname.if) - interface-specific configuration files with Dual IP stack implementation
  - *Configure:*
    - [`etc/hostname.athn0`](src/etc/hostname.athn0)
    - [`etc/hostname.em0`](src/etc/hostname.em0)
    - [`etc/hostname.em1`](src/etc/hostname.em1)
    - [`etc/hostname.em2`](src/etc/hostname.em2)
    - [`etc/hostname.enc1`](src/etc/hostname.enc1)
    - [`etc/hostname.gif0`](src/etc/hostname.gif0)
    - [`etc/hostname.switch0`](src/etc/hostname.switch0)
    - [`etc/hostname.tun0`](src/etc/hostname.tun0)
    - [`etc/hostname.vether0`](src/etc/hostname.vether0)
    - [`etc/hostname.vlan5`](src/etc/hostname.vlan5)
    - [`etc/hostname.vlan7`](src/etc/hostname.vlan7)
  - *Usage:*
    - `sh /etc/netstart`
* [hotplugd](https://man.openbsd.org/hotplugd) - devices hot plugging monitor daemon
  - *Configure:*
    - [`etc/hotplug/attach`](src/etc/hotplug/attach)
    - `etc/hotplug/detach`
    - `chmod 750 /etc/hotplug/{attach,detach}`
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable hotplugd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start hotplugd`
* [httpd](https://man.openbsd.org/httpd) - HTTP daemon as primary, fallback, and [autoinstall](https://man.openbsd.org/autoinstall)
  - *Configure:*
    - [`etc/httpd.conf`](src/etc/httpd.conf)
    - [`etc/newsyslog.conf`](src/etc/newsyslog.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/ssl/acme/freedns.afraid.org.fullchain.pem`](src/etc/ssl/acme/freedns.afraid.org.fullchain.pem)
    - [`etc/ssl/acme/freedns.afraid.org.ocsp.resp.der`](src/etc/ssl/acme/freedns.afraid.org.ocsp.resp.der)
    - [`etc/ssl/acme/private/freedns.afraid.org.key`](src/etc/ssl/acme/private/freedns.afraid.org.key)
    - [`var/www/htdocs`](src/var/www/htdocs)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` reload syslogd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable httpd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start httpd`
* [ifstated](https://man.openbsd.org/ifstated) - Interface State daemon to reconnect, update IP, and log
  - *Configure:*
    - [`etc/ifstated.conf`](src/etc/ifstated.conf)
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ifstated`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start ifstated`
* IKEv2 VPN (IPv4 and IPv6)
  - *Configure:*
    - `etc/iked`
    - [`etc/iked.conf`](src/etc/iked.conf)
    - [`etc/iked-vedetta.conf`](src/etc/iked-vedetta.conf)
    - [`etc/ipsec.conf`](src/etc/ipsec.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - `etc/ssl/ikeca.cnf`
    - `etc/ssl/vedetta`
  - *Usage:*
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta install`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org install`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan create`
    - `cd /etc/iked/export`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan export`
    - `tar -C /etc/iked/export -xzpf mobile.vedetta.lan.tgz`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan revoke`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta key mobile.vedetta.lan delete`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ipsec`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set iked flags -6`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start iked`
* IKEv1 VPN (IPv4)
  - *Configure:*
    - `etc/isakmpd` 
    - [`etc/ipsec.conf`](src/etc/ipsec.conf)
    - [`etc/ipsec-vedetta.conf`](src/etc/ipsec-vedetta.conf)
    - [`etc/npppd`](src/etc/npppd)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - `etc/ssl/ikeca.cnf` 
    - `etc/ssl/vedetta` 
  - *Usage:*
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta install /etc/isakmpd`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org create`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate freedns.afraid.org install /etc/isakmpd`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan create`
    - `cd /etc/isakmpd/export`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan export`
    - `tar -C /etc/isakmpd/export -xzpf mobile.vedetta.lan.tgz`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta certificate mobile.vedetta.lan revoke`
    - [`ikectl`](https://man.openbsd.org/ikectl)` ca vedetta key mobile.vedetta.lan delete`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ipsec npppd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set isakmpd flags -K`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start npppd isakmpd`
    - [`ipsecctl`](https://man.openbsd.org/ipsecctl)` -d -f /etc/ipsec-vedetta.conf`
* [nsd](https://man.openbsd.org/nsd) - Name Server Daemon (NSD) as authoritative DNS nameserver for LAN
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`var/nsd`](src/var/nsd)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set nsd flags -c /var/nsd/etc/nsd.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start nsd`
* [ntpd](https://man.openbsd.org/ntpd) - Network Time Protocol daemon
  - *Configure:*
    - [`etc/ntpd.conf`](src/etc/ntpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable ntpd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start ntpd`
* [pf](https://man.openbsd.org/pf) - packet filter with IP based adblock
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`usr/local/bin/adhosts.sh`](src/usr/local/bin/adhosts.sh)
    - [`usr/local/bin/malware.sh`](src/usr/local/bin/malware.sh)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -vvs queue`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -s info`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -s states`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -vvs rules`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -v -s rules -R 4`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -s memory`
    - `tcpdump -n -e -ttt -r /var/log/pflog`
    - `tcpdump -neq -ttt -i pflog0`
* [rebound](https://man.openbsd.org/rebound) - DNS proxy
  - *Configure:*
    - [`etc/dhclient.conf`](src/etc/dhclient.conf)
    - [`etc/resolv.conf`](src/etc/resolv.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - `dig ipv6.google.com aaaa`
* [relayd](https://man.openbsd.org/relayd) - relay daemon for loadbalancing, SSL/TLS acceleration, DNS-sanitizing, SSH gateway, transparent HTTP proxy, and TLS inspection ([MITM](https://github.com/vedetta-com/vedetta/issues/82#issuecomment-363907251))
  - *Configure:*
    - [`etc/acme-client.conf`](src/etc/acme-client.conf)
    - [`etc/httpd.conf`](src/etc/httpd.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/relayd.conf`](src/etc/relayd.conf)
    - [`usr/local/bin/get-pin.sh`](src/usr/local/bin/get-pin.sh)
    - `cd `[`/etc/ssl`](src/etc/ssl)
    - `ln -s acme/freedns.afraid.org.fullchain.pem 10.10.10.11:443.crt`
    - `ln -s acme/freedns.afraid.org.fullchain.pem fd80:1fe9:fcee:1337::ace:babe:443.crt`
    - `cd `[`/etc/ssl/private`](src/etc/ssl/private)
    - `ln -s ../acme/private/freedns.afraid.org.key 10.10.10.11:443.key`
    - `ln -s ../acme/private/freedns.afraid.org.key fd80:1fe9:fcee:1337::ace:babe:443.key`
    - `mkdir -p /etc/ssl/relayd/private`
    - `openssl req -x509 -days 365 -newkey rsa:2048 -keyout /etc/ssl/relayd/private/ca.key -out /etc/ssl/relayd/ca.crt`
    - `echo 'subjectAltName=DNS:relay.vedetta.lan' > /etc/ssl/relayd/server.ext`
    - `openssl genrsa -out /etc/ssl/relayd/private/relay.vedetta.lan.key 2048`
    - `openssl req -new -key /etc/ssl/relayd/private/relay.vedetta.lan.key -out /etc/ssl/relayd/private/relay.vedetta.lan.csr -nodes`
    - `openssl x509 -sha256 -req -days 365 -in /etc/ssl/relayd/private/relay.vedetta.lan.csr -CA /etc/ssl/relayd/ca.crt -CAkey /etc/ssl/relayd/private/ca.key -CAcreateserial -extfile /etc/ssl/relayd/server.ext -out /etc/ssl/relayd/relay.vedetta.lan.crt`
    - `cd /etc/ssl`
    - `ln -s relayd/relay.vedetta.lan.crt 127.0.0.1.crt`
    - `ln -s relayd/relay.vedetta.lan.crt ::1.crt`
    - `cd /etc/ssl/private`
    - `ln -s ../relayd/private/relay.vedetta.lan.key 127.0.0.1.key`
    - `ln -s ../relayd/private/relay.vedetta.lan.key ::1.key`
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable relayd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start relayd`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -T add -t httpfilter $ip`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -T add -t tlsinspect $ip`
* [rtadvd](https://man.openbsd.org/rtadvd) - router advertisement daemon
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/rtadvd.conf`](src/etc/rtadvd.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` set rtadvd flags athn0 em1 em2`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start rtadvd`
* [sensorsd](https://man.openbsd.org/sensorsd) - hardware sensors monitor
  - *Configure:*
    - [`etc/sensorsd.conf`](src/etc/sensorsd.conf)
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable sensorsd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start sensorsd`
* [slaacd](https://man.openbsd.org/slaacd) - a stateless address autoconfiguration daemon
  - *Configure:*
    - [`ifconfig`](https://man.openbsd.org/ifconfig)` em0 inet6 autoconf`
  - *Usage:*
    - [`slaacctl`](https://man.openbsd.org/slaacctl)` show interface em0`
* [smtpd](https://man.openbsd.org/smtpd) - Simple Mail Transfer Protocol daemon, see [Caesonia](https://github.com/vedetta-com/caesonia/)
  - *Configure:*
    - [`etc/mail/aliases`](src/etc/mail/aliases)
    - [`etc/mail/smtpd.conf`](src/etc/mail/smtpd.conf)
    - `touch `[`/etc/mail/secrets`](src/etc/mail/secrets)
    - `chmod 640 /etc/mail/secrets`
    - `chown root:_smtpd /etc/mail/secrets`
    - `echo "puffy puffy@example.com:password" > /etc/mail/secrets`
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` restart smtpd`
* [sshd](https://man.openbsd.org/sshd) - OpenSSH SSH daemon with internal-sftp
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/ssh`](src/etc/ssh)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start sshd`
* [switchd](https://man.openbsd.org/switchd) - software-defined networking (SDN) sflow controller
  - *Configure:*
    - [`etc/hostname.switch0`](src/etc/hostname.switch0)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`etc/switchd.conf`](src/etc/switchd.conf)
  - *Usage:*
    - `sh /etc/netstart switch0`
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable switchd`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start switchd`
    - [`switchctl`](https://man.openbsd.org/switchctl)` connect /dev/switch0`
* [syslogd](https://man.openbsd.org/syslogd) - log system messages
  - *Configure:*
    - [`etc/newsyslog.conf`](src/etc/newsyslog.conf)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
  - *Usage:*
    - [`rcctl`](https://man.openbsd.org/rcctl)` set syslogd flags \${syslogd_flags} -a /var/unbound/dev/log -a /var/nsd/dev/log`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start syslogd`
* [unbound](https://man.openbsd.org/unbound) - Unbound DNS validating resolver from root nameservers, with caching and DNS based adblock
  - *Configure:*
    - [`etc/dhclient.conf`](src/etc/dhclient.conf)
    - [`etc/resolv.conf`](src/etc/resolv.conf)
    - [`etc/pf.conf`](src/etc/pf.conf)
    - [`usr/local/bin/dnsblock.sh`](src/usr/local/bin/dnsblock.sh)
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
    - [`var/unbound`](src/var/unbound)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`rcctl`](https://man.openbsd.org/rcctl)` enable unbound`
    - [`rcctl`](https://man.openbsd.org/rcctl)` start unbound`

Sysadmin:
* [crontab](https://man.openbsd.org/crontab) - maintain crontab files for individual users
  - *Configure:*
    - [`var/cron`](src/var/cron)
  - *Usage:*
    - [`crontab`](https://man.openbsd.org/crontab)` -e`
* [doas](https://man.openbsd.org/doas) - execute commands as another user
  - *Configure:*
    - [`etc/doas.conf`](src/etc/doas.conf)
  - *Usage:*
    - [`doas`](https://man.openbsd.org/doas)` tmux`
* [ftp](https://man.openbsd.org/ftp) - Internet file transfer program
  - *Configure:*
    - [`etc/pf.conf`](src/etc/pf.conf)
  - *Usage:*
    - [`pfctl`](https://man.openbsd.org/pfctl)` -f /etc/pf.conf`
    - [`ftp`](https://man.openbsd.org/ftp)` -o - "https://www.openbsd.org/donations.html"`
* [mail](https://man.openbsd.org/mail) - send and receive mail, for daily reading
  - *Usage:*
    - [`mail`](https://man.openbsd.org/mail)
* [syspatch](https://man.openbsd.org/syspatch) - manage base system binary patches
  - *Configure:*
    - `etc/installurl`
    - [`var/cron/tabs/root`](src/var/cron/tabs/root)
  - *Usage:*
    - [`syspatch`](https://man.openbsd.org/syspatch)` -c`
* [systat](https://man.openbsd.org/systat) - display system statistics
  - *Usage:*
    - [`systat`](https://man.openbsd.org/systat)` queues`
    - [`systat`](https://man.openbsd.org/systat)` pf`
    - [`systat`](https://man.openbsd.org/systat)` states`
    - [`systat`](https://man.openbsd.org/systat)` rules`
* [tmux](https://man.openbsd.org/tmux) - terminal multiplexer
  - *Configure:*
    - `~/.tmux.conf`
  - *Usage:*
    - [`tmux`](https://man.openbsd.org/tmux)

## Hardware
OpenBSD likes small form factor, low-power, lots of ECC memory, AES-NI support, open source boot, and the fastest supported network cards. This configuration has been tested on [APU2](https://pcengines.ch/apu2c4.htm).

## Install
Encryption is the easiest method for media sanitization and disposal. OpenBSD supports [full disk encryption](https://www.openbsd.org/faq/faq14.html#softraidFDE) using a [keydisk](https://www.openbsd.org/faq/faq14.html#softraidFDEkeydisk) (e.g. a USB stick).

Partitions are important for [security, stability, and integrity](https://www.openbsd.org/faq/faq4.html#Partitioning). A minimum partition layout [example for router](src/var/www/htdocs/boot.vedetta.lan/disklabel.min) with (upgrade itself) binary base, and no packages (comfortable fit on flash memory cards/drives):

| Filesystem | Mount       | Size    |
|:---------- |:----------- | -------:|
| a          | /           |    512M |
| b          | /swap       |   1024M |
| d          | /var        |    512M |
| e          | /var/log    |    128M |
| f          | /tmp        |   1024M |
| g          | /usr        |   1024M |
| h          | /usr/local  |     64M |
| i          | /home       |     16M |
| *Total*    |             |**4304M**|

## SSL
It's best practice to create CAs on a single purpose secure machine, with no network access.

Specify which certificate authorities (CAs) are allowed to issue certificates for your domain, by adding [DNS Certification Authority Authorization (CAA)](https://tools.ietf.org/html/rfc6844) Resource Record (RR) to [`var/nsd/zones/master/vedetta.lan.zone`](src/var/nsd/zones/master/vedetta.lan.zone)

Revoke certificates as often as possible.

## SSH

[SSH fingerprints verified by DNS](http://man.openbsd.org/ssh#VERIFYING_HOST_KEYS) is done by adding Secure Shell (Key) Fingerprint (SSHFP) Resource Record (RR) to [`var/nsd/zones/master/vedetta.lan.zone`](src/var/nsd/zones/master/vedetta.lan.zone): `ssh-keygen -r vedetta.lan.`  
Verify: `dig -t SSHFP vedetta.lan`  
Usage: `ssh -o "VerifyHostKeyDNS ask" child.foil.lan`

Manage keys with [ssh-agent](https://man.openbsd.org/ssh-agent).

Detect tampered keyfiles or man in the middle attacks with [ssh-keyscan](http://man.openbsd.org/ssh-keyscan).

Control access to local users with [principals](https://github.com/vedetta-com/vedetta/blob/master/src/usr/local/share/doc/vedetta/OpenSSH_Principals.md).

## Firewall
Guests can use the DNS nameserver to access the ad-free web, while authenticated users gain desired permissions. It's best to authenticate an IP after connecting to VPN. There are three users in this one person scenario: one for wheel, one for sftp, and one for authpf.

## Performance
Consider using [mount_mfs](https://man.openbsd.org/mount_mfs) in order to reduce wear and tear, as well as to speed up the system. Remember to set the [sticky bit](https://man.openbsd.org/chmod.1#1000) on mfs /tmp, see [etc/fstab](src/etc/fstab).

## Caveats
* VPN with IKEv2 or IKEv1, not both. *While there are many tecnologies for VPN, only IKEv2 and IKEv1 are standard (considerable effort was put into testing and securing)*
* relayd does not support CRL, SNI, nor OCSP (yet)
* httpd without custom error pages (can be patched)
* 11n is max WiFi mode, [is this enough?](https://arstechnica.com/information-technology/2017/03/802-eleventy-what-a-deep-dive-into-why-wi-fi-kind-of-sucks/)
* authpf users have sftp access

## Support
Via [issues](https://github.com/vedetta-com/vedetta/issues) and [#vedetta:matrix.org](https://riot.im/app/#/room/#vedetta:matrix.org)

## Contribute
Want to help out? :star: [Fork this repo](https://github.com/vedetta-com/vedetta/fork) :star:

