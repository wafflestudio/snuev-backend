FROM ruby:2.4.2

RUN apt-get update -qq && \
    apt-get install -y build-essential

# Add ko locale
RUN apt-get install -y locales && \
    sed -i -e 's/# ko_KR.UTF-8 UTF-8/ko_KR.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="ko_KR.UTF-8 UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    echo 'export LANG=ko_KR.utf-8' >> /etc/bash.bashrc
#    locale-gen ko_KR.UTF-8


ENV LANG ko_KR.UTF-8 \
    LANGUAGE ko_KR.UTF-8 \
    LC_ALL ko_KR.UTF-8

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
