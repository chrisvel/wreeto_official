FROM ruby:2.6.6-alpine

ENV BUNDLER_VERSION=2.0.2

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
      python2 \
      tzdata \
      yarn \
      zip \
      imagemagick \
      poppler-utils

RUN gem install bundler -v 2.0.2

ENV APP_HOME /app/wreeto
WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock $APP_HOME/
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 20 --retry 5

COPY package.json package-lock.json $APP_HOME/
RUN yarn install --force

COPY . $APP_HOME/
COPY config/database.docker.yml $APP_HOME/config/database.yml

RUN bundle exec rake assets:precompile
RUN bundle exec rake webpacker:compile

EXPOSE 8383

ENTRYPOINT ["./docker-entrypoint.sh"]
