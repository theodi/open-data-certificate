# In case of fire, break glass

Now shit is on fire, _and_ broken glass is everywhere. Well done you.

OK, so this is all Vagrant-powered now, which is awesome. You'll need a recent version of Vagrant, plus [my fork of the _vagrant-rackspace_ plugin](https://github.com/mitchellh/vagrant-rackspace/pull/4#issuecomment-19056323). You may need to [install the dummy box](https://github.com/mitchellh/vagrant-rackspace#quick-start), too. And you need to `vagrant plugin install vagrant-butcher`. You'll also need the `.chef/rackspace_secrets.yaml` file, which looks like

    username: <our_login>
    api_key: <our_key>
    
Jeni has a couple of tar archives containing the `.chef` and `.vagrant` configurations. Just grab these and untar into here.
    
Now you should be able to do `vagrant status` and see what's what. If a node is acting up, then you can do like

    vagrant destroy <bad_node>
    vagrant up <bad_node> --provider rackspace

That `--provider` is very important, it defaults to VirtualBox otherwise.

If you need more nodes, edit line 80 in the _Vagrantfile_:

      10.times do |num|

to however many total nodes you want.

## Load-balancing

Be aware that the load-balancer requires manual intervention: if you destroy and re-provision a node, then you need to remove the dead node (in the list of nodes on the LB, it will now be showing as a 10.x.y.z address instead of with a proper name) and add your replacement. Any new nodes will need to be added by hand, too.

Oh, and because we're now doing Shao-lin SSL Redirect-fu, the nodes need to be added to [two](https://mycloud.rackspace.co.uk/a/raxdemotheodi/load_balancers#rax%3Aload-balancer%2CcloudLoadBalancers%2CLON/71943) [different](https://mycloud.rackspace.co.uk/a/raxdemotheodi/load_balancers#rax%3Aload-balancer%2CcloudLoadBalancers%2CLON/73139) load-balancers.
