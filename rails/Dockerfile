# -*- sh -*-
FROM fcat/dotrb2013-rails-base

# dev tools
# TODO move to base image
RUN apt-get install -qy git
RUN apt-get install -qy tmux
RUN apt-get install -qy postgresql-client-9.1

# redis config
# TODO move to base image
RUN mkdir /var/run/redis
ADD redis.conf /etc/redis/redis.conf

# nginx config
ADD nginx.conf /etc/nginx/conf.d/rails.conf
# TODO move to base image
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm /etc/nginx/sites-available/default

# rails user
RUN adduser --disabled-password --home=/rails --gecos "" rails

# copy rails app
ADD railsapp /rails

# copy scripts and config
ADD unicorn.rb /rails/config/
ADD rails_setup.sh /rails/bin/
ADD Procfile-production /rails/
ADD start-production /rails/
ADD database.yml /rails/config/

# fix permissions
RUN chmod +x /rails/start-production
RUN chown -R rails:rails /rails

RUN su rails -c "/bin/sh /rails/bin/rails_setup.sh"

EXPOSE 80

CMD "/rails/start-production" rails
