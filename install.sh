apt-get -y update
apt-get -y install build-essential git-core curl libssl-dev libreadline5 libreadline5-dev zlib1g zlib1g-dev libmysqlclient-dev libcurl4-op$

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
add-apt-repository ppa:chris-lea/node.js
apt-get -y update
apt-get -y install nodejs

# Add deployer user
adduser deployer --ingroup admin
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

rbenv install 1.9.3-p429
rbenv global 1.9.3-p429
rbenv rehash

gem install bundler --no-ri --no-rdoc

# get to know github.com
#ssh git@github.com

# after deploy:cold
sudo rm /etc/nginx/sites-enabled/default
sudo service nginx restart
sudo update-rc.d -f unicorn_blog defaults

