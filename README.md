
[![Build Status](https://img.shields.io/travis/theodi/open-data-certificate.svg)](https://travis-ci.org/theodi/open-data-certificate)
[![Dependency Status](https://img.shields.io/gemnasium/theodi/open-data-certificate.svg)](https://gemnasium.com/theodi/open-data-certificate)
[![Coverage Status](https://img.shields.io/coveralls/theodi/open-data-certificate.svg)](https://coveralls.io/r/theodi/open-data-certificate)
[![Code Climate](https://img.shields.io/codeclimate/github/theodi/open-data-certificate.svg)](https://codeclimate.com/github/theodi/open-data-certificate)
[![License](https://img.shields.io/github/license/theodi/open-data-certificate.svg)](http://theodi.mit-license.org/)
[![Badges](https://img.shields.io/:badges-6/6-ff6799.svg)](https://github.com/badges/badgerbadgerbadger)

# Open Data Certificates

This source code is for the ODI's Open Data Certificates app at [certificates.theodi.org](https://certificates.theodi.org).
The online assessment tool allows publishers to assess how good their open data release is across technical, social, legal and other areas. When published, a certificate (which can be Bronze, Silver, Gold or Platinum) shows data reusers how much they can trust and rely on the dataset

## License

This code is open source under the MIT license. See [LICENSE.md](LICENSE.md) file for full details.

## Summary of features

Open Data Certificate is an online assessment tool for open data releases powered by Rails. 

Follow the [public feature roadmap for Open Data Certificates](https://trello.com/b/2xc7Q0kd/labs-public-toolbox-roadmap?menu=filter&filter=label:Certificates)

## Development

### Requirements
ruby version 2.1.8

### Environment variables

Some extra environment variables are required for the certificates site; these can be set in a .env file in the root of the project. The docker setup will create this file if it doesn't already exist.

#### Required

```
# A hostname to create links in emails
CERTIFICATE_HOSTNAME="localhost:3000"

# Redis server URL
ODC_REDIS_SERVER_URL="redis://redis:6379"
```

#### Optional

The following extra are needed in production or for optional features:

```
# Rackspace credentials for saving certificate dumps
RACKSPACE_USERNAME
RACKSPACE_API_KEY
RACKSPACE_CERTIFICATE_DUMP_CONTAINER

# Juvia details to allow commenting
JUVIA_BASE_URL
CERTIFICATE_JUVIA_SITE_KEY

# Sending error reports to airbrake
AIRBRAKE_CERTIFICATE_KEY

# Enable footnotes for debugging info
ENABLE_FOOTNOTES=true
```

### Specific Development Notes

### Development: Running the full application locally

#### With Docker

The simplest way to get a certificates app up and running is under Docker.

##### OSX 

1. Install [Docker Desktop](https://www.docker.com/products/docker-desktop)
2. Run `bin/dockerize`
3. Make tea
4. Everything should be set up and be open in your browser.
5. Run `docker-compose run web bin/setup`

##### Linux 
WARNING: Untested - may be out of date - docker works slightly differently now

1. Install [docker-engine](https://docs.docker.com/engine/), [docker-compose](https://docs.docker.com/compose/overview/), and then [docker-machine](https://docs.docker.com/machine/overview/)
2. Set up a Docker host with `docker-machine create -d virtualbox default`
3. Run `bin/dockerize`
4. Make tea
5. Everything should be ready and the script will try to open the browser
  * If it doesn't, hit ctrl-c and check all 4 containers are up with `docker-compose ps`
  * Then point your browser to the address:port for the `opendatacertificate_web_1` container (likely `0.0.0.0:3000`)
6. Run `docker-compose run web bin/setup`

##### Without Docker

1. Install Ruby 2.1.8, and bundler.
2. Install and run Redis and MySQL servers.
3. Run `bin/setup` (generates `.env` file)
4. edit the default config/database.yml #TODO with what?
5. Run `bundle exec rails s`

If you're not using docker, ignore the `docker-compose run web` prefix on the commands below.

###### Known issues

eventmachine
rubyracer

#### Application Configuration

##### Default Admin User

Both of the above methods should set up your local app with a default admin user:

* Username: `test@example.com`
* Password: `testtest`


##### Internationalisation
    
By default, only the UK survey is built in development, as building more can take a while.    

To build a specific country survey (AU used as an example):

    docker-compose run web bundle exec rake surveyor:build_changed_survey FILE=surveys/generated/surveyor/odc_questionnaire.AU.rb

To build a few surveys:

    docker-compose run web bundle exec rake surveyor:build_changed_surveys LIMIT=5

To build *all* the other surveys (remember, this can take a while):

    docker-compose run web bundle exec rake surveyor:build_changed_surveys

For information on how to translate and localise surveys, see below.

#### Testing

To run tests:

    docker-compose run web bundle exec rake test

You can also run tests continuously whenever a file is changed:

    docker-compose run web bundle exec guard

### API

Certificates can be created and updated using a JSON API. See the [API documentation](doc/api.md) for details.

### Application Functionality

#### Admin functions

To mark a user as being an admin use the rails console to set the `admin` field to true. The easiest way to find the ID is to look on the URL of their account page.

    User.find(<id>).update_attributes(admin: true)

Admins are able to block a dataset from displaying on the public /datasets page by visiting the dataset and toggling the visibility at the top of the page.

Removed datasets are listed at `/datasets/admin` (only accessible by admin users).

#### Autocompletion

The survey attempts to fetch answers from the documentation URL and fill them into the questionnaire. These answers are marked as autocompleted.

Surveys can be autocompleted if the pages machine-readable metadata in the following formats:

- DCAT
- Datapackage
- CKAN

Some examples of URLS that can be autocompleted:

- http://data.gov.uk/dataset/overseas_travel_and_tourism
- http://data.gov.uk/dataset/apprenticeship-success-rates-in-england-2011-2012
- http://data.ordnancesurvey.co.uk/datasets/50k-gazetteer
- http://data.ordnancesurvey.co.uk/datasets/boundary-line
- http://smtm.labs.theodi.org/download/

### Additional documentation

[App approach document](https://docs.google.com/a/whiteoctober.co.uk/document/d/1Ot91x1enq9TW7YKpePytE-wA0r8l9dmNQLVi16ph-zg/edit#)

The original prototype has been moved to [/prototype](https://github.com/theodi/open-data-certificate/tree/master/prototype).

