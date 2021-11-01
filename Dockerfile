FROM ruby:2.2.7

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app
COPY Gemfile.lock /usr/src/app
COPY vendor/gems/ /usr/src/app/vendor/gems

RUN bundle install

COPY . /usr/src/app
COPY docker/database.yml.example /usr/src/app/config

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
