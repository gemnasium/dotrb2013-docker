# -*- sh -*-
FROM fcat/ubuntu-universe:12.04

# prevent apt from starting nginx right after the installation
RUN echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

# redis
RUN apt-get -qy install redis-server

# nginx
RUN apt-get -qy install nginx

# ruby & build dependencies
RUN apt-get -qy install ruby1.9.1 ruby1.9.1-dev build-essential
RUN apt-get -qy install libpq-dev libv8-dev libsqlite3-dev

# bundler
RUN gem install bundler

# git, because some gems are downloaded from git repos
RUN apt-get -qy git

# dev tools
RUN apt-get -qy install vim
