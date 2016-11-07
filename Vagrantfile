Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_url = "https://vagrantcloud.com/ubuntu/trusty64"
    config.vm.network :private_network, ip: "192.168.56.1"

    config.vm.define :lamp
    config.vm.hostname = "www.lamp.local"
    config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        # commented out ram setting for change below
        # v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", "lamp"]
	v.customize ["modifyvm", :id, "--cpus", 1]
		
	# set ram copied from https://stefanwrobel.com/how-to-make-vagrant-performance-not-suck
	host = RbConfig::CONFIG['host_os']
	# Give VM 1/4 system memory
	if host =~ /darwin/
		# sysctl returns Bytes and we need to convert to MB
		mem = `sysctl -n hw.memsize`.to_i / 1024
	elsif host =~ /linux/
		# meminfo shows KB and we need to convert to MB
		mem = `grep 'MemTotal' /proc/meminfo | sed -e 's/MemTotal://' -e 's/ kB//'`.to_i
	elsif host =~ /mswin|mingw|cygwin/
		# Windows code via https://github.com/rdsubhas/vagrant-faster
		mem = `wmic computersystem Get TotalPhysicalMemory`.split[1].to_i / 1024
	end
	mem = mem / 1024 / 4
	v.customize ["modifyvm", :id, "--memory", mem]
    end

    config.vm.synced_folder "./www", "/var/www", create: true
    config.vm.synced_folder "./sqldump", "/var/sqldump", create: true
    config.vm.synced_folder "./scripts", "/var/scripts", create: true
    config.vm.synced_folder "./custom_config_files", "/var/custom_config_files", create: true

    config.vm.provision :shell, :path => "bootstrap.sh"
    #config.vm.provision :shell, run: "always", :path => "load.sh"
    config.vm.provision :shell, :path => "load.sh"
end
