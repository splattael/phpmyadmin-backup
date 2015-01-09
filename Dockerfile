FROM ruby:2.1
MAINTAINER Peter Suschlik <peter@suschlik.de>

RUN gem install phpmyadmin-backup

WORKDIR /var/backups

ENTRYPOINT ["phpmyadmin_backup"]
