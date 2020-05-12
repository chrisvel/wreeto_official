#!/bin/sh
set -e

if [ -f /app/wreeto/tmp/pids/server.pid ]; then
  rm /app/wreeto/tmp/pids/server.pid
fi

bundle exec bin/rails db:environment:set RAILS_ENV=development
bundle exec rake db:migrate || bundle exec rake db:setup

exec bundle exec "$@"