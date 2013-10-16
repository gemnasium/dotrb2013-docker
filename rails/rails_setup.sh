#!/bin/bash
set -e

bundle config path "$HOME/bundler"

APP_DIR="$HOME/app"
cd $APP_DIR

bundle install
