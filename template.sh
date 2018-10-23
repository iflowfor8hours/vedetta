host=child
domain=foil
tld=lan
wan_em0=
lan_em1=172.16.99.1
lan_em2=192.168.99.1
lan_ether0=10.10.10.10
lan_ether0_alias=10.10.10.11

# All the direct references and aliases are safe
sed -i 's/acolyte.vedetta.lan/${host}.${domain}.${tld}/g' $(git ls-files)
sed -i 's/boot.vedetta.lan/boot.${domain}.${tld}/g' $(git ls-files)

# Same for the static ip addresses, although I didn't change them
# I'm also not sure how to test these very well using vagrant
# without heavy manual intervention, or (more likely) docker madness.
sed -i 's/10.10.10.10/${lan_ether0}/g' $(git ls-files)
sed -i 's/10.10.10.11/${lan_ether0_alias}/g' $(git ls-files)

# Nothing magical here, mostly single instance stragglers or filenames
sed -i 's/vedetta.lan/${domain}.${tld}/g' src/var/unbound/etc/unbound.conf
sed -i 's/vedetta/${domain}/g' src/etc/ipsec*
sed -i 's/vedetta/${domain}/g' src/etc/iked*
sed -i 's/vedetta/${domain}/g' src/etc/resolv.conf
mv src/etc/iked-vedetta.conf src/etc/iked-foil.conf
mv src/etc/ipsec-vedetta.conf src/etc/ipsec-foil.conf
