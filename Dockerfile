FROM ruby:2.4.5
MAINTAINER Shelby Switzer <shelby@civicunrest.com>

RUN apt-get update && apt-get install -y wget gcc make && \
  apt-get install -y build-essential && \
  apt-get install -y libc6-dev && \
  wget ftp://ftp.freetds.org/pub/freetds/stable/freetds-1.00.92.tar.gz && \
  tar -xzf freetds-1.00.92.tar.gz && \
  cd freetds-1.00.92 && \
  ./configure --prefix=/usr/local --with-tdsver=7.3 && \
  make && make install && make clean


RUN mkdir /usr/app
WORKDIR /usr/app

COPY Gemfile /usr/app/
COPY Gemfile.lock /usr/app/

RUN gem install bundler

RUN bundle install

COPY . /usr/app

EXPOSE 3000

CMD ["./deploy/startup.sh"]