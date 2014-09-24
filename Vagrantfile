# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"
y = YAML.load File.open ".chef/rackspace_secrets.yaml"

Vagrant.configure("2") do |config|

#  config.butcher.enabled    = true
#  config.butcher.verify_ssl = false

  3.times do |num|

    index = "%02d" % [num + 1]

    config.vm.define :"certificate_theodi_org_#{index}" do |config|
      config.vm.box      = "dummy"
      config.vm.hostname = "certificate-#{index}"

      config.ssh.private_key_path = "./.chef/id_rsa"
      config.ssh.username         = "root"

      config.vm.provider :rackspace do |rs|
        rs.username         = y["username"]
        rs.api_key          = y["api_key"]
        rs.flavor           = /2GB/
        rs.image            = /Trusty/
        rs.public_key_path  = "./.chef/id_rsa.pub"
        rs.rackspace_region = :lon
      end

      config.vm.provision :shell, :inline => "wget https://opscode.com/chef/install.sh && bash install.sh"

      config.vm.provision :chef_client do |chef|
        chef.node_name              = "certificate-#{index}"
        chef.environment            = "odc-prod"
        chef.chef_server_url        = "https://chef.theodi.org"
        chef.validation_client_name = "chef-validator"
        chef.validation_key_path    = ".chef/chef-validator.pem"
        chef.run_list               = chef.run_list = [
            "recipe[chef-open-data-certificate]"
        ]
      end
    end
  end

  1.times do |num|

    index = "%02d" % [ num + 1 ]

    config.vm.define :"memcached_certificate_theodi_org_#{index}" do |config|
      config.vm.box      = "dummy"
      config.vm.hostname = "memcached-certificate-#{index}"

      config.ssh.private_key_path = "./.chef/id_rsa"
      config.ssh.username         = "root"

      config.vm.provider :rackspace do |rs|
        rs.username        = y["username"]
        rs.api_key         = y["api_key"]
        rs.flavor          = /1GB/
        rs.image           = /Trusty/
        rs.public_key_path = "./.chef/id_rsa.pub"
        rs.rackspace_region = :lon
      end

      config.vm.provision :shell, :inline => "wget https://opscode.com/chef/install.sh && bash install.sh"

      config.vm.provision :chef_client do |chef|
        chef.node_name              = "memcached-certificate-#{index}"
        chef.environment            = "odc-prod"
        chef.chef_server_url        = "https://chef.theodi.org"
        chef.validation_client_name = "chef-validator"
        chef.validation_key_path    = ".chef/chef-validator.pem"
        chef.run_list               = chef.run_list = [
            "role[open-data-certificate-attrs]",
            "role[memcached]"
        ]
      end
    end
  end

  1.times do |num|

    index = "%02d" % [num + 1]

    config.vm.define :"staging_certificate_theodi_org_#{index}" do |config|
      config.vm.box      = "dummy"
      config.vm.hostname = "staging-certificate-#{index}"

      config.ssh.private_key_path = "./.chef/id_rsa"
      config.ssh.username         = "root"

      config.vm.provider :rackspace do |rs|
        rs.username         = y["username"]
        rs.api_key          = y["api_key"]
        rs.flavor           = /2GB/
        rs.image            = /Trusty/
        rs.public_key_path  = "./.chef/id_rsa.pub"
        rs.rackspace_region = :lon
      end

      config.vm.provision :shell, :inline => "wget https://opscode.com/chef/install.sh && bash install.sh"

      config.vm.provision :chef_client do |chef|
        chef.node_name              = "staging-certificate-#{index}"
        chef.environment            = "odc-staging"
        chef.chef_server_url        = "https://chef.theodi.org"
        chef.validation_client_name = "chef-validator"
        chef.validation_key_path    = ".chef/chef-validator.pem"
        chef.run_list               = chef.run_list = [
            "recipe[chef-open-data-certificate]"
        ]
      end
    end
  end

  1.times do |num|

    index = "%02d" % [ num + 1 ]

    config.vm.define :"staging_memcached_certificate_theodi_org_#{index}" do |config|
      config.vm.box      = "dummy"
      config.vm.hostname = "staging-memcached-certificate-#{index}"

      config.ssh.private_key_path = "./.chef/id_rsa"
      config.ssh.username         = "root"

      config.vm.provider :rackspace do |rs|
        rs.username         = y["username"]
        rs.api_key          = y["api_key"]
        rs.flavor           = /1GB/
        rs.image            = /Precise/
        rs.public_key_path  = "./.chef/id_rsa.pub"
        rs.rackspace_region = :lon
      end

      config.vm.provision :shell, :inline => "wget https://opscode.com/chef/install.sh && bash install.sh"

      config.vm.provision :chef_client do |chef|
        chef.node_name              = "staging-memcached-certificate-#{index}"
        chef.environment            = "odc-staging"
        chef.chef_server_url        = "https://chef.theodi.org"
        chef.validation_client_name = "chef-validator"
        chef.validation_key_path    = ".chef/chef-validator.pem"
        chef.run_list               = chef.run_list = [
            "role[open-data-certificate-attrs]",
            "role[memcached]"
        ]
      end
    end
  end

end
