#!/bin/sh

export SECRET_KEY_BASE=`rake secret`

bundle exec rails s -b 0.0.0.0