host=child
domain=foil
tld=lan
wan_em0
lan_em1=172.16.99.0
lan_em2

# All the direct references go first
sed -i 's/acolyte.vedetta.lan/${host}.${domain}.${tld}/g' $(git ls-files)

sed -i 's/vedetta.lan/${domain}.${tld}/g' $(git ls-files)
sed -i 's/vedetta/${domain}/g' $(git ls-files)
