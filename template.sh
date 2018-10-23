host=child
domain=foil
tld=lan
wan_em0
lan_em1=172.16.99.1
lan_em2=192.168.99.1

# All the direct references and aliases are safe
sed -i 's/acolyte.vedetta.lan/${host}.${domain}.${tld}/g' $(git ls-files)
sed -i 's/boot.vedetta.lan/boot.${domain}.${tld}/g' $(git ls-files)


sed -i 's/vedetta.lan/${domain}.${tld}/g' $(git ls-files)
sed -i 's/vedetta/${domain}/g' $(git ls-files)
