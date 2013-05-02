## ODI Open Data Certificate

The original prototype has been moved to [/prototype](https://github.com/theodi/open-data-certificate/tree/master/prototype).

The approach to the new app is outlined in a [google doc](https://docs.google.com/a/whiteoctober.co.uk/document/d/1Ot91x1enq9TW7YKpePytE-wA0r8l9dmNQLVi16ph-zg/edit#), which will be moved into this readme file.

## Running

The application can be run locally using [vagrant](http://www.vagrantup.com/), bringing in the chef cookbooks with [librarian-chef](https://github.com/applicationsonline/librarian-chef) 

    gem install librarian-chef
    librarian-chef install
    vagrant up