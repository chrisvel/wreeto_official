#!/bin/sh
set -e

if [ -f /app/tmp/pids/server.pid ]; then
  rm /app/tmp/pids/server.pid
fi

bundle exec bin/rails db:environment:set RAILS_ENV=development
bundle exec rake db:migrate || bundle exec rake db:setup

export RUBYOPT='-W:no-deprecated' 
bundle exec rails server -p 8383 -b 0.0.0.0