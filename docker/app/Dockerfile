# Dockerfile

# Include the Ruby base image (https://hub.docker.com/_/ruby)
# in the image for this application, version 2.7.1.
FROM ruby:2.7.2

# Put all this application's files in a directory called /code.
# This directory name is arbitrary and could be anything.
ENV RAILS_ROOT /var/www/app
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
ENV RACK_ENV='production'
VOLUME SDBM01:$RAILS_ROOT/db
# Run this command. RUN can be used to run anything. In our
# case we're using it to install our dependencies.
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle config --local without development:test
RUN bundle install
# to create a database
# docker-compose run app rake db:create[db]

# Tell Docker to listen on port 4567.
EXPOSE 8080

# Tell Docker that when we run "docker run", we want it to
# run the following command:
# $ bundle exec rackup --host 0.0.0.0 -p 4567.

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
