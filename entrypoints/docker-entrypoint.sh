#!/bin/sh

set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rake db:exists || bundle exec rake db:create
bundle exec rake db:migrate

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

