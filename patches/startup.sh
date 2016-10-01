#!/bin/bash
# Derived work from https://github.com/sshipway/Portus
#  - removed nginx configuration
#  - minor fixes

if [ ! "$PORTUS_DEBUG" = "" ]; then
	echo "PORTUS_MACHINE_FQDN $PORTUS_MACHINE_FQDN"
	echo "PORTUS_KEY_PATH $PORTUS_KEY_PATH"
	echo "PORTUS_CRT_PATH $PORTUS_CRT_PATH"
fi

# Start portus
if [ "$PORTUS_PORT" = "" ]; then
    PORTUS_PORT=443
fi
if [ "$PORTUS_MACHINE_FQDN" = "" ]; then
    PORTUS_MACHINE_FQDN=`hostname`
fi

cd /portus

if [ "$PORTUS_MACHINE_FQDN" != "" -a "$PORTUS_CREATE_CERT" != "" ];then
    # create self-signed certificates
    echo Creating Certificate
    export ALTNAME=`hostname`
    export IPADDR=`ip addr list eth0 |grep "inet " |cut -d' ' -f6|cut -d/ -f1|tail -1`
    openssl req -x509 -newkey rsa:2048 -keyout "$PORTUS_KEY_PATH" -out "$PORTUS_CRT_PATH" -days 3650 -nodes -subj "/CN=$PORTUS_MACHINE_FQDN" -extensions SAN -config <(cat /etc/ssl/openssl.cnf <(printf "[SAN]\nsubjectAltName=DNS:registry,DNS:$PORTUS_MACHINE_FQDN,DNS:$ALTNAME,IP:$IPADDR,DNS:portus"))

fi

if [ "$PORTUS_MACHINE_FQDN" != "" ];then
    echo "config FQDN into rails"
    sed -i"" -e "s/portus.test.lan/$PORTUS_MACHINE_FQDN/" config/config.yml
fi

RET=1
echo "Waiting for database."
while [[ RET -ne 0 ]]; do
    sleep 1;
    printf '.'
    mysql -h db -u root -p$PORTUS_PASSWORD -e "select 1" > /dev/null 2>&1; RET=$?
done

echo "Creating / Migrating Database"
rake db:create && rake db:migrate && rake db:seed

# create the registry first, before creating any users


if [ "$REGISTRY_HOSTNAME" != "" -a "$REGISTRY_PORT" != "" -a "$REGISTRY_SSL_ENABLED" != "" ]; then
	echo 'Waiting for registry to be available.'
	until $(curl --insecure --output /dev/null --silent --head --fail https://$REGISTRY_HOSTNAME:$REGISTRY_PORT); do
		printf '.'
		sleep 1
	done

	echo "Checking registry definition for $REGISTRY_HOSTNAME:$REGISTRY_PORT"
	rake registry:register"[Registry,$REGISTRY_HOSTNAME:$REGISTRY_PORT,$REGISTRY_SSL_ENABLED]"
fi

# TODO: somehow not needed anymore or at least fails with 'dublicate user'
# create an API account
#echo "Creating API account if required"
#rake portus:create_api_account

# create a portus admin user if asked to do so
if [ "$PORTUS_ADMIN_PASSWORD" != "" ]; then
	echo "Creating admin user"
	rake "portus:create_user[admin,admin@local.de,$PORTUS_ADMIN_PASSWORD,true]"
fi


echo "Starting chrono"
bundle exec crono &

echo "Starting Portus"
/usr/bin/env /usr/local/bin/ruby /usr/local/bundle/bin/puma $*