FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y build-essential

RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN apt-get update && apt-get install -y nodejs

ENV RAILS_ENV production

RUN gem install bundler:1.17.3

# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY . .
RUN rm Gemfile.lock

RUN bundle install --without development test build

RUN npm install

ENV DATABASE_URL sqlite3::memory:
ENV RAILS_SECRET_KEY_BASE ABCD000000000
RUN bundle exec rake assets:precompile

# CMD ["/bin/sh"]
