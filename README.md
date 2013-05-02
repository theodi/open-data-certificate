## ODI Open Data Certificate

The original prototype has been moved to [/prototype](https://github.com/theodi/open-data-certificate/tree/master/prototype).

The approach to the new app is outlined in a [google doc](https://docs.google.com/a/whiteoctober.co.uk/document/d/1Ot91x1enq9TW7YKpePytE-wA0r8l9dmNQLVi16ph-zg/edit#), which will be moved into this readme file.

## Running (with Vagrant)

The application can be run locally using [vagrant](http://www.vagrantup.com/), bringing in the chef cookbooks with [librarian-chef](https://github.com/applicationsonline/librarian-chef) 

    gem install librarian-chef
    librarian-chef install
    vagrant up

Once the vm has started, access it and start the app:

    # access the VM
    vagrant ssh
    cd /vagrant/

    # get the dependencies
    bundle install

    # start the app
    rails s

Port 3000 is forwarded from the VM to the host, so visiting http://localhost:3000 will hit through to the VM.