#!/bin/sh
set -e

if [ -f /app/wreeto/tmp/pids/server.pid ]; then
  rm /app/wreeto/tmp/pids/server.pid
fi

bundle exec rake db:migrate || bundle exec rake db:setup

exec bundle exec "$@"