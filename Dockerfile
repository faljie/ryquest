##
# Base - basic image use to run dev tools
#
FROM ruby:3.0.2

WORKDIR /app

ADD . .
RUN bundle install
