FROM ruby:2.6.3

RUN apt-get update && apt-get install -y curl
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get install -y \
    libpq-dev \
    build-essential \
    nodejs \
    ruby-dev \
    postgresql-client \
    poppler-utils \
    software-properties-common

RUN npm install yarn -g

ENV APP_HOME /app/wreeto
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY Gemfile $APP_HOME/Gemfile
COPY Gemfile.lock $APP_HOME/Gemfile.lock

ARG RAILS_ENV="development"
ARG RACK_ENV="development"

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5

COPY . $APP_HOME/
COPY config/database.docker.yml $APP_HOME/config/database.yml

RUN bundle exec rake assets:precompile

# ARG CURRENT_UID
# ARG CURRENT_GID
# RUN groupadd --gid $CURRENT_GID builder && useradd --uid $CURRENT_UID --gid builder --shell /bin/bash --create-home builder
# RUN mkdir -p $APP_HOME/tmp $APP_HOME/log && chown -R builder $APP_HOME/tmp $APP_HOME/public $APP_HOME/log

EXPOSE 8383
ENTRYPOINT ["bundle", "exec"]
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "4321"]
