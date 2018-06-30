baikal-devenv
=============
Provides 2-node HDFS, Zeppelin w/ spark 2.2, Nifi, Kafka, Jupyter notebook, postgres db, and python scripts to consume/produce Kafka. Applications and services largely version-locked to resemble HDP v2.6.0.3 for development and testin.

Instructions
------------

### Startup:

1. git clone https://github.com/ComputationalHealth/baikal-devenv.git
2. cd baikal-devenv/compose
3. docker-compose up -d --build
4. docker exec hadoop-namenode /bin/bash startup.sh

### Shutdown:
1. docker-compose down -v

Notes
-----

- All nodes are at either localhost or the virtual host IP address depending on system config
- NiFi at port 8080
  - Mounted nifi data directory is baikal-dev/nifi/data
  - For connecting to hdfs in nifi use /opt/nifi/conf/hdfs/conf-site.xml
- startup.sh installs some packages for PySpark and gives Storm write access to /data and Nifi write access to /user/nifi paths in hdfs
- Zeppelin is at port 9001
- StormUI is at port 9090
- Jupyter is at port 8888
- Kafka advertise port is 9092

To connect to Kafka using confluent_kafka python API:

```python
from confluent_kafka import Producer
p = Producer({'bootstrap.servers': '10.6.0.155:9092'})
```
