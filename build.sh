#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile
MIX_ENV=prod mix assets.deploy

# Build the release and overwrite the existing release directory
MIX_ENV=prod mix release --overwrite

# Run migrations
_build/prod/rel/rush_hour/bin/rush_hour eval "Release.migrate"
