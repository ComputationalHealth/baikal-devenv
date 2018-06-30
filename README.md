baikal-devenv
=============
Provides 2-node HDFS, Zeppelin w/ spark 2.2, Nifi, Kafka, Jupyter notebook, postgres db, and python scripts to consume/produce Kafka.

Instructions
------------

Startup:
- cd C:/
- git clone https://github.com/ComputationalHealth/baikal-devenv.git
- cd baikal-devenv/compose
- docker-compose up -d --build
- (winpty) docker exec -it hadoop-namenode bash
- ./startup.sh (long process (~5 min))

Shutdown:
 - docker-compose down -v

Notes
-----

- Volume paths in docker-compose assume baikal-dev is in C:/ 
- Nifi at localhost:8080/nifi
- Mounted nifi data directory is baikal-dev/nifi/data
- For connecting to hdfs in nifi use /opt/nifi/conf/hdfs/conf-site.xml
- startup.sh gives Nifi write access to /user/nifi path in hdfs
- Zeppelin is at localhost:9001

To connect to Kafka using confluent_kafka python API:

    from confluent_kafka import Producer

    p = Producer({'bootstrap.servers': '10.6.0.155:29092'})
