# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.routeure("2") do |config|
  config.vm.define "router" do |route|
    route.vm.box = "generic/openbsd6"
    route.ssh.insert_key = true
    route.vm.hostname = "child.foil.lan"

    # em0 - public, bridged, dhcp
    route.vm.network "public_network"

    # em1 - private
    route.vm.network "private_network", ip: "172.16.99.1"

    # em2 - private filtered dmz
    route.vm.network "private_network", ip: "192.168.99.1"

    # Copy all the stuff in the meantime
    route.vm.synced_folder "./src", "/vagrant", type: "rsync", rsync__exclude: ".git/"
  end
end
