apt-get install wget
apt-get install build-essential
apt-get install libc6-dev

apt-get --assume-yes install freetds-dev freetds-bin

BUNDLE_INSTALL_LOCATION="/tmp/bundle"
SITE_CONFIG_DIR="/home/site/config"
RBENV_VERSION=$(ls /usr/local/.rbenv/versions | grep 2.4.5 | tail -n 1)
eval "$(rbenv init -)"
rbenv global $RBENV_VERSION
bundle clean --force
mkdir -p $BUNDLE_INSTALL_LOCATION
bundle config --global path $BUNDLE_INSTALL_LOCATION
bundle install --no-deployment
tar -zcf /tmp/gems.tgz -C $BUNDLE_INSTALL_LOCATION .
mkdir -p $SITE_CONFIG_DIR
mv -f /tmp/gems.tgz $SITE_CONFIG_DIR

bundle exec rails s