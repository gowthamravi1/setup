#!/bin/bash

export CMS_DES_PEM=/home/prana/certs/oo.key
export IS_SEARCH_ENABLED=true
export KLOOPZ_NOTIFY_PASS=notifypass
export KLOOPZ_AMQ_PASS=amqpass
export CMS_DB_HOST=kloopzcmsdb
export CMS_DB_USER=kloopzcm
export CMS_DB_PASS=kloopzcm
export ACTIVITI_DB_HOST=activitidb
export ACTIVITI_DB_USER=activiti
export ACTIVITI_DB_PASS=activiti
export CMS_API_HOST=localhost
export CONTROLLER_WO_LIMIT=500
export AMQ_USER=superuser
export ECV_USER=prana-ecv
export ECV_SECRET=ecvsecret
export API_USER=prana-api
export API_SECRET=apisecret
export API_ACESS_CONTROL=permitAll
export NOTIFICATION_SYSTEM_USER=admin
export JAVA_OPTS="-Dprana.url=http://localhost:3000 -Dcom.prana.controller.use-shared-queue=true"
export CATALINA_PID=/var/run/tomcat7.pid

now=$(date +"%T")

echo "Deploying tomcat web apps: $now "

mkdir -p /home/prana/certs

if [ ! -e /home/prana/certs/oo.key ]; then
cd /home/prana/certs
dd if=/dev/urandom count=24 bs=1 | xxd -ps > oo.key
truncate -s -1 oo.key
chmod 400 oo.key
chown tomcat7:root oo.key
fi

cd /usr/local/tomcat7/webapps/

rm -rf *

cp $OO_HOME/dist/prana/dist/*.war /usr/local/tomcat7/webapps

mkdir -p /opt/prana/controller/antenna/retry
mkdir -p /opt/prana/opamp/antenna/retry
mkdir -p /opt/prana/cms-publisher/antenna/retry

/usr/local/tomcat7/bin/catalina.sh run

now=$(date +"%T")
echo "Done with Tomcat: $now "
