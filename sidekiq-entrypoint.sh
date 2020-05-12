#!/bin/sh

set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

export RUBYOPT='-W:no-deprecated' 
bundle exec sidekiq -C ./config/sidekiq.yml