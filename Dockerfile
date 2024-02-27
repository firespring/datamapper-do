FROM ruby:2.6.10-slim-bullseye

RUN apt-get update \
    && apt-get install -y build-essential default-libmysqlclient-dev vim \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Do things
RUN gem install rake-compiler
RUN gem install bundler -v 2.4.22

WORKDIR /usr/src/app
COPY . .
RUN bundle install
WORKDIR /usr/src/app/do_mysql
RUN bundle install
WORKDIR /usr/src/app

