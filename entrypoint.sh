#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /segdev-desafio/tmp/pids/server.pid

# Check for bundler and install deps
gem install bundler --conservative
bundle check || bundle install

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"