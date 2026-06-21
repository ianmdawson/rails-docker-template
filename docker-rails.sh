#!/bin/sh

echo "docker-rails entrypoint begins"

rm -f tmp/pids/server.pid
bundle exec rails server -b 0.0.0.0
