#!/bin/bash

cd ./src
BUNDLE_GEMFILE="./Gemfile.production" bundle install -j4
