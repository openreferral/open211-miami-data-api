apt-get install wget
apt-get install build-essential
apt-get install libc6-dev

wget http://www.freetds.org/files/stable/freetds-1.1.6.tar.gz
tar -xzf freetds-1.1.6.tar.gz
cd freetds-1.1.6
./configure --prefix=/usr/local --with-tdsver=7.3
make
make install

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