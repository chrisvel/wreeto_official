FROM ruby:2.7.1-alpine

ENV BUNDLER_VERSION=2.0.2

# RUN apk add --update --no-cache \
#         libpq-dev \
#         build-essential \
#         nodejs \
#         ruby-dev \
#         postgresql-client \
#         poppler-utils \
#         software-properties-common \ 
#         yarn

RUN apk add --update --no-cache \
      binutils-gold \
      build-base \
      curl \
      file \
      g++ \
      gcc \
      git \
      less \
      libstdc++ \
      libffi-dev \
      libc-dev \ 
      linux-headers \
      libxml2-dev \
      libxslt-dev \
      libgcrypt-dev \
      make \
      netcat-openbsd \
      nodejs \
      openssl \
      pkgconfig \
      postgresql-dev \
      python \
      tzdata \
      yarn 

RUN gem install bundler -v 2.0.2
ENV APP_HOME /app/wreeto
WORKDIR $APP_HOME
COPY Gemfile Gemfile.lock $APP_HOME/
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 20 --retry 5

COPY . $APP_HOME/
COPY config/database.docker.yml $APP_HOME/config/database.yml

RUN bundle exec rake assets:precompile

EXPOSE 8383
