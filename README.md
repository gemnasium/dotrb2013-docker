dotrb2013-docker
================

Scripts and Dockerfiles to install the [gemnasium/dotrb2013](https://github.com/gemnasium/dotrb2013) project using [docker](http://docker.io).

The [gemnasium/dotrb2013](https://github.com/gemnasium/dotrb2013) project is a sample Rails application for the [Gemnasium workshop](http://www.dotrb.eu/workshops#gemnasium) at [dotRB2013](http://www.dotrb.eu/).

Requirements
------------

* [Docker](https://www.docker.io/gettingstarted/)
* Git
* Linux Ubuntu >= 12.04

Make sure `docker` runs without `sudo` (or create a shell alias to circumvent that).

**Warning**: If you are running any OS other than ubuntu, you can install [vagrant](http://downloads.vagrantup.com/) and follow the docker guide: 
http://docs.docker.io/en/latest/installation/vagrant/


Installation
------------

Clone this repository:

```
git clone https://github.com/gemnasium/dotrb2013-docker.git
cd dotrb2013-docker
```

Then, you can pull the docker images from the [docker index](https://index.docker.io/). It may take some time to download but this is faster than building the images.

```
make pull
```

Setup
-----

Part of the configuration for the Rails app comes from some environment variables. These variables must be set before the rails app is started using the `./bin/rails-start` script.

```
GITHUB_CLIENT_ID="1337"
GITHUB_CLIENT_SECRET="secret"
HOSTIP=192.168.0.19

export GITHUB_CLIENT_ID
export GITHUB_CLIENT_SECRET
export HOSTIP

./bin/rails-start
```

You can also create a `.env` file in the root directory of the project.

Here is a sample `.env` file:

```
GITHUB_CLIENT_ID="1337"
GITHUB_CLIENT_SECRET="secret"
HOSTIP=192.168.0.19
```

Look at `etc/env` for a list of the expected environment variables.

Usage
-----

Start a fresh postgresql container:

```
./bin/postgresql-start
```

Then do the same for the Rails app:

```
./bin/rails-start
```

This will start the Rails application in production mode. The app is automatically connected to the postgresql server you have just launched.

The rails container expose TCP port 80 (requests are handled by nginx). Run `docker ps` to know how this TCP port is mapped to the host, then connect to this port using you web browser.

You can also run an interactive bash session:

```
./bin/rails-console
```

Troubleshooting
---------------

If your rails app can not connect to the database, make sure that:

* postgresql container is up and running; have a look at `docker ps`
* `POSTGRES_PORT` environment variable is set when calling `bin/postgresql-info`
* you export `HOSTIP` environment variable before starting the rails container

If you want to inspect the log file of the Rails app:

1. find the ID of the rails container using `docker ps`
1. copy the log file from the container to the host using `docker cp`

Here is an example:

```
$ docker ps | grep rails
5272c3f328d6        fcat/dotrb2013-rails:latest   /bin/sh -c "/rails/s   About a minute ago   Up About a minute   49154->80

$ docker cp 5272c3f328d6:/rails/log/production.log .

$ less production.log
```

Inside the rails container
--------------------------

This command starts rails, redis and other dependencies:

```
/rails/start-production
```

The source code belongs to a `rails` user, so it's best to switch to that user to update the code or run some rake tasks.

Here is a bash session that shows you how to run the database migrations:

```
# start the "rails" container
# environment variables are sent to the container
./bin/rails-debug

# become "rails"
# environment variables are preserved
$ su -l -p rails
$ cd /rails

# set postgresql configuration
sed -i "s/host: .*/host: $POSTGRES_HOST/" config/database.yml
sed -i "s/port: .*/port: $POSTGRES_PORT/" config/database.yml

# run the migration
RAILS_ENV=production ./bin/rake db:migrate
```

Keep your data
--------------

The `rails-start` and `postgresql-start` scripts will both create a new container from a docker image, so you will loose all the modifications you have made to the filesystem. This means you also loose the data that has been commited to the database.

If you want to restore your entire environment, find the container you have created using `docker ps`, and restart it using `docker start`.

It's easy to save and share your running environment using `docker commit`:

1. create a new image from your container using `docker commit`
2. update the `bin/rails-start` script if you have changed the name of the image
3. push the image to the docker index

Same thing for postgresql.

Under the hood
--------------

The postgresql container only runs postgresql.

The rails container runs the rest:

* nginx
* rails with unicorn
* resque scheduler
* resque worker
* redis

It relies on [foreman](https://github.com/ddollar/foreman) to launch everything at the same time. But it could use a supervisor like [supervisord](http://supervisord.org/) or [monit](http://mmonit.com/monit/) to achieve this.

When a new container is started from the `rails` image, the `config/database.yml` file is updated to match postgresql host and port. These settings comes from the environment variables and are set using `bin/postgresql-info`.

Contributing
------------

To contribute and share:

* change the username in your Makefile, according to your Docker Index account
* change the commiter name in the Dockerfile files

You don't really need rails-base and ubuntu-multiverse docker images, but it may save you some time as the building process is pretty slow (and the docker caching mechanism is not reliable with commands like `apt-get update`).

To build the docker images locally:

```
make build
```

The Dockerfile expect the application source code to live in `rails/railsapp`.

```
git clone https://github.com/gemnasium/dotrb2013.git rails/railsapp
```

Warning! Building the images takes some time. To speed things up, you may install a proxy for the debian-like repositories using [Apt-Cacher NG](https://www.unix-ag.uni-kl.de/~bloch/acng/).


Good luck!

Licence
-------

MIT Licence.

Credits
-------

Thanks to [Sridhar Ratnakumar](https://github.com/srid) for sharing [discourse-docker](https://github.com/srid/discourse-docker).

