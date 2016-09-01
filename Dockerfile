FROM library/rails:4.2.2
MAINTAINER Eugen Mayer <eugen.mayer@kontextwork.de>

ENV RAILS_ENV=production
ENV COMPOSE=1
ENV CATALOG_CRON="5.minutes"

WORKDIR /

# Install phantomjs, this is required for testing and development purposes
# There are no official deb packages for it, hence we built it inside of the
# open build service.
RUN echo "deb http://download.opensuse.org/repositories/home:/flavio_castelli:/phantomjs/Debian_8.0/ ./" >> /etc/apt/sources.list \
  && wget http://download.opensuse.org/repositories/home:/flavio_castelli:/phantomjs/Debian_8.0/Release.key && \
  apt-key add Release.key \
  && rm Release.key \
  && apt-get update \
  && apt-get install -y --no-install-recommends phantomjs \
  &&  rm -rf /var/lib/apt/lists/* \
  && apt-get update && apt-get install -y vim telnet ldap-utils curl

RUN git clone https://github.com/SUSE/Portus.git portus

WORKDIR /portus

# based on https://github.com/sshipway/Portus/blob/master/Dockerfile
RUN bundle install --retry=3

COPY image_assets/registry.rake ./lib/tasks/registry.rake
COPY image_assets/startup.sh /usr/local/bin/startup
RUN chmod +x /usr/local/bin/startup && rm -fr .git && mkdir /portus/log

# Run this command to start it up
ENTRYPOINT ["/bin/bash","/usr/local/bin/startup"]
# Default arguments to pass to puma
CMD ["-b","tcp://0.0.0.0:3000","-w","3"]