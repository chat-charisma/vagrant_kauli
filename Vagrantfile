require "yaml"

name = YAML.load_file("conf.yaml")["name"]

Vagrant.configure(2) do |config|
  config.vm.hostname = "#{name}.local.kau.li"

  config.vm.box = "kauli/dev"
  config.vm.box_url = "http://op3.dev.kau.li/dev.json"
  config.vm.network "private_network", ip: "172.28.128.3"
  config.ssh.forward_agent = true
  config.vm.synced_folder "/Volumes/#{name}/kauli", "/kauli", :nfs => true

  # domain = "local.kau.li"
  # config.hostsupdater.aliases = %W(#{domain} dmp-api.#{domain} dmp.#{domain} sysop.#{domain} exui.#{domain} api.#{domain} dr.#{domain})

  config.vm.provision :shell, :path => "http://op3.dev.kau.li/shell/apt-get.sh", :args => %w(redis-server tokyotyrant)
  config.vm.provision :shell, :path => "http://op3.dev.kau.li/shell/dmp.sh"
  config.vm.provision :shell, :path => "http://op3.dev.kau.li/shell/memcached.sh"
  config.vm.provision :shell, :path => "http://op3.dev.kau.li/shell/postfix.sh"

  config.vm.provision :shell, :path => "shell/common.sh"
  config.vm.provision 'database', :type => :shell, :path => "shell/database.sh"
  config.vm.provision :shell, :path => "shell/dmp.sh"
  config.vm.provision :shell, :path => "shell/kamikaze.sh"
  config.vm.provision :shell, :path => "shell/ssp.sh"
  config.vm.provision :shell, :path => "shell/sysop.sh"
  config.vm.provision :shell, :path => "shell/user.sh"
  config.vm.provision :shell, :path => "shell/exui.sh"
  config.vm.provision :shell, :path => "shell/custom.sh", :privileged => false
end