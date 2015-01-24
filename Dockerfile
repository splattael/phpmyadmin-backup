FROM gliderlabs/alpine:3.1
MAINTAINER Peter Suschlik <peter@suschlik.de>

RUN apk update
RUN apk add ruby ruby-dev
RUN apk add build-base gcc libxml2-dev libxslt-dev

# TODO download cert

RUN gem install -s http://rubygems.org nokogiri -- --use-system-libraries
RUN gem install -s http://rubygems.org phpmyadmin-backup

RUN apk del libc-dev build-base libxml2-dev python gcc py-libxslt

RUN rm -rf /var/cache/apk/*

WORKDIR /var/backups

ENTRYPOINT ["phpmyadmin_backup"]
