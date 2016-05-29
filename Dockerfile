FROM ruby:2.3.1

# app dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

ENV APP_HOME /usr/src/cloudit
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN mkdir -p $APP_HOME/lib/cloudit

ADD . $APP_HOME/
RUN bundle

RUN gem install byebug
