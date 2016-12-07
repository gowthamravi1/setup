#!/bin/sh

export DISPLAY_LOCAL_STORE="/opt/prana/display/public"

gem install  $OO_HOME/dist/prana/dist/prana-admin-1.0.0.gem --no-ri --no-rdoc

echo "inductor create shared"
cd $INDUCTOR_HOME
inductor create
cd inductor
mkdir -p lib
cp $OO_HOME/client.ts lib/client.ts
# add inductor using shared queue
inductor add --mqhost activemq \
--dns on \
--debug on \
--daq_enabled true \
--collector_domain prana_default \
--tunnel_metrics on \
--perf_collector_cert /etc/pki/tls/logstash/certs/logstash-forwarder.crt \
--ip_attribute public_ip \
--queue shared \
--mgmt_url http://localhost:3000 \
--logstash_cert_location /etc/pki/tls/logstash/certs/logstash-forwarder.crt \
--logstash_hosts logstash:5000 \
--max_consumers 10 \
--local_max_consumers 10 \
--authkey superuser:amqpass \
--amq_truststore_location /opt/prana/inductor/lib/client.ts \
--additional_java_args "" \
--env_vars ""
echo "inductor create log directory for shared"
mkdir -p $INDUCTOR_HOME/inductor/clouds-enabled/shared/log

echo "circuit init"
cd $INDUCTOR_HOME
circuit create
cd circuit
circuit init

echo "circuit-prana-1 circuit install"
cd $INDUCTOR_HOME/inductor

if [ -d "circuit-prana-1" ]; then
  echo "git pull circuit-prana-1"
  cd circuit-prana-1
  git pull
else
  echo "git clone circuit-prana-1"
  git clone "$GITHUB_URL/circuit-prana-1.git"
	cd circuit-prana-1
fi
sleep 2

circuit install

cd $INDUCTOR_HOME/inductor

inductor start
inductor tail
