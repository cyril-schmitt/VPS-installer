apt-get -y update
apt-get -y install build-essential git-core curl libssl-dev libreadline5 libreadline5-dev zlib1g zlib1g-dev libsqlite3-dev libmysqlclient-dev libcurl4-openssl-dev libxslt-dev libxml2-dev python-software-properties htop sudo

# nginx
add-apt-repository ppa:nginx/stable
apt-get -y update
apt-get -y install nginx
service nginx start

# MongoDB
apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | sudo tee /etc/apt/sources.list.d/10gen.list
apt-get -y update
apt-get -y install mongodb-10gen

# Postfix
apt-get -y install telnet postfix

# Node.js
git clone https://github.com/joyent/node.git
cd node
# 'git tag' shows all available versions: select the latest stable.
#git checkout v0.6.8
./configure #--openssl-libpath=/usr/lib/ssl
make
make install

# Add deployer user
adduser deployer --ingroup adm
usermod -aG sudo deployer
su deployer
cd

# Install rbenv
git clone git://github.com/sstephenson/rbenv.git /usr/local/rbenv

# Add rbenv to the path:
echo '# rbenv setup' > /etc/profile.d/rbenv.sh
echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh
echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> /etc/profile.d/rbenv.sh
echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

chmod +x /etc/profile.d/rbenv.sh
source /etc/profile.d/rbenv.sh

# Install ruby-build:
pushd /tmp
  git clone git://github.com/sstephenson/ruby-build.git
  cd ruby-build
  ./install.sh
popd

sudo rbenv install 1.9.3-p429
sudo rbenv global 1.9.3-p429
sudo rbenv rehash

sudo gem install bundler --no-ri --no-rdoc

# get to know github.com
#ssh git@github.com

# after deploy:cold
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
sudo update-rc.d -f unicorn_blog defaults

