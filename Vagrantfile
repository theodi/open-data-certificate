# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"
y = YAML.load File.open ".chef/rackspace_secrets.yaml"

Vagrant.configure("2") do |config|

  config.butcher.knife_config_file = '.chef/knife.rb'

  config.vm.define :mysql_certificate_theodi_org do |mysql_certificate_config|
    mysql_certificate_config.vm.box      = "dummy"
    mysql_certificate_config.vm.hostname = "mysql-certificate"

    mysql_certificate_config.ssh.private_key_path = "./.chef/id_rsa"
    mysql_certificate_config.ssh.username         = "root"

    mysql_certificate_config.vm.provider :rackspace do |rs|
      rs.username        = y["username"]
      rs.api_key         = y["api_key"]
      rs.flavor          = /1GB/
      rs.image           = /Precise/
      rs.public_key_path = "./.chef/id_rsa.pub"
      rs.endpoint        = "https://lon.servers.api.rackspacecloud.com/v2"
      rs.auth_url        = "lon.identity.api.rackspacecloud.com"
    end

    mysql_certificate_config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"

    mysql_certificate_config.vm.provision :chef_client do |chef|
      chef.node_name              = "mysql-certificate"
      chef.environment            = "odc-production"
      chef.chef_server_url        = "https://chef.theodi.org"
      chef.validation_client_name = "chef-validator"
      chef.validation_key_path    = ".chef/chef-validator.pem"
      chef.run_list               = chef.run_list = [
          "role[open-data-certificate-attrs]",
          "role[mysql-node]"
      ]
    end
  end

  2.times do |num|

    index = "%02d" % [ num + 1 ]

    config.vm.define :"certificate_theodi_org_#{index}" do |config|
      config.vm.box      = "dummy"
      config.vm.hostname = "certificate-#{index}"

      config.ssh.private_key_path = "./.chef/id_rsa"
      config.ssh.username         = "root"

      config.vm.provider :rackspace do |rs|
        rs.username        = y["username"]
        rs.api_key         = y["api_key"]
        rs.flavor          = /512MB/
        rs.image           = /Precise/
        rs.public_key_path = "./.chef/id_rsa.pub"
        rs.endpoint        = "https://lon.servers.api.rackspacecloud.com/v2"
        rs.auth_url        = "lon.identity.api.rackspacecloud.com"
      end

      config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"

      config.vm.provision :chef_client do |chef|
        chef.node_name              = "certificate-#{index}"
        chef.environment            = "odc-production"
        chef.chef_server_url        = "https://chef.theodi.org"
        chef.validation_client_name = "chef-validator"
        chef.validation_key_path    = ".chef/chef-validator.pem"
        chef.run_list               = chef.run_list = [
            "role[certificate]"
        ]
      end
    end
  end
end