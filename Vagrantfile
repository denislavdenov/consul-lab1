SERVER_COUNT = 2


Vagrant.configure("2") do |config|
  config.vm.synced_folder ".", "/vagrant", disabled: false
(1..SERVER_COUNT).each do |i|
  config.vm.define vm_name="consul-#{i}" do |node|
    node.vm.box = "denislavd/xenial64"
    node.vm.hostname = vm_name
    node.vm.provision :shell, path: "scripts/provision.sh", env: {"SERVER_COUNT" => SERVER_COUNT}
    node.vm.network "private_network", ip: "10.10.56.1#{i}"
    node.vm.network "forwarded_port", guest: 8500, host: 8500 + i
    end
  end
end