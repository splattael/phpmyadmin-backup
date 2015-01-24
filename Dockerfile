FROM gliderlabs/alpine:3.1
MAINTAINER Peter Suschlik <peter@suschlik.de>

RUN apk update
RUN apk add ruby
RUN apk add ruby-dev
RUN rm -rf /var/cache/apk/*

RUN gem install -s http://rubygems.org phpmyadmin-backup

WORKDIR /var/backups

ENTRYPOINT ["phpmyadmin_backup"]
