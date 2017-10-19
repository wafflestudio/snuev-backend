FROM ruby:2.4.1

RUN apt-get update -qq && \
    apt-get install -y build-essential

ENV APP_PATH /usr/src/app
RUN mkdir -p $APP_PATH
WORKDIR $APP_PATH

ADD Gemfile* $APP_PATH/

ENV BUNDLE_GEMFILE=$APP_PATH/Gemfile \
  BUNDLE_JOBS=3 \
  BUNDLE_RETRY=3 \
  BUNDLE_PATH=/bundle

RUN bundle install

ADD . $APP_PATH
