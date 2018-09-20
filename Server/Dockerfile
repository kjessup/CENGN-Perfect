FROM ubuntu:16.04

ARG phpapphome=/var/www/html/laravel
ARG swiftversion=4.2
ARG goversion=1.11

ENV TERM=xterm

SHELL [ "/bin/bash", "-l", "-c" ]
RUN apt-get -y update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y \
	locales apt-utils zip unzip pkg-config git wget curl gnupg2 && \
	locale-gen en_US.UTF-8 && \
	update-locale en_US.UTF-8 && \
	apt-get install -y \
	software-properties-common

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8

# extra repos
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:webupd8team/java
RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
# v node v
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get -y update && \
	DEBIAN_FRONTEND=noninteractive apt-get -y upgrade && apt-get install -y --no-install-recommends \
	nginx \
	postgresql postgresql-contrib libpq-dev \
	php php-mcrypt php-gd php-mbstring php-xml \
	nodejs \
	python-pip python-dev python-setuptools \
	oracle-java8-installer gradle maven

# django
RUN pip install --upgrade pip
RUN pip install uwsgi

# node


# java
#RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections
# RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list
#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
#RUN apt-get update && apt-get install -y --no-install-recommends oracle-java8-installer gradle maven

## JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# rails
RUN gpg2 --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable
RUN rvm requirements
RUN rvm install 2.5.1

# go
RUN wget -q -O go.tgz https://dl.google.com/go/go${goversion}.linux-amd64.tar.gz \
	&& tar -C /usr/local/ -xzf go.tgz \
	&& rm go.tgz
ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"

# php
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN mkdir $phpapphome
RUN git clone https://github.com/laravel/laravel.git /tmp/laravel
RUN cp -r /tmp/laravel/* $phpapphome/ && \
	cp /tmp/laravel/.env.example $phpapphome/.env && \
	rm -rf /tmp/laravel
RUN cd $phpapphome && \
	composer install --no-plugins --no-scripts
RUN chown www-data: -R $phpapphome

# swift
RUN wget -q https://swift.org/builds/swift-${swiftversion}-release/ubuntu1604/swift-${swiftversion}-RELEASE/swift-${swiftversion}-RELEASE-ubuntu16.04.tar.gz \
	&& tar xzf swift-${swiftversion}-RELEASE-ubuntu16.04.tar.gz \
	&& rm swift-${swiftversion}-RELEASE-ubuntu16.04.tar.gz
ENV PATH=/swift-${swiftversion}-RELEASE-ubuntu16.04/usr/bin:"${PATH}"
ENV LD_LIBRARY_PATH=/swift-${swiftversion}-RELEASE-ubuntu16.04/usr/lib/swift/linux:"${LD_LIBRARY_PATH}"

# versions
RUN python -V ;\
	php -v ;\
	go version ;\
	swift --version ;\
	java -version ;\
	ruby -v ;\ 
	node -v
