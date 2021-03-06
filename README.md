baikal-devenv
=============
This repository contains the Docker components necessary to deploy a local data science development environment. The current configuration includes 2-node HDFS, Zeppelin w/ spark 2.2, Nifi, Kafka, Jupyter notebook, postgres db, and example Python scripts to consume/produce Kafka. Applications and services are largely version-locked to match HDP v2.6.0.3 for development and testing.

* Jacob McPadden, Thomas JS Durant, Dustin R Bunch, Andreas Coppi, Nathan Price, Kris Rodgerson, Charles J Torre Jr, William Byron, H Patrick Young, Allen L Hsiao, Harlan M Krumholz, Wade L Schulz. “A Scalable Data Science Platform for Healthcare and Precision Medicine Research”, 2018; [arXiv:1808.04849](http://arxiv.org/abs/1808.04849).

Instructions
------------

### Prerequisite for Docker on Windows
Due to an update in Hyper-V, some ports are now reserved and cannot be bound within a container. The following will need to be run, which will require system restarts.

At an elevated command prompt (see commands in code block below):

1. Disable Hyper-V, restart
```
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
```

2. Reserve ports, enable Hyper-V, restart (note, may take a few minutes for services to fully disable and allow ports to be excluded).
 - To view excluded ports: ```netsh int ipv4 show excludedportrange protocol=tcp```
```
dism.exe /Online /Disable-Feature:Microsoft-Hyper-V
netsh int ipv4 add excludedportrange protocol=tcp startport=50070 numberofports=1
netsh int ipv4 add excludedportrange protocol=tcp startport=50090 numberofports=1
dism.exe /Online /Enable-Feature:Microsoft-Hyper-V /All
```

### Startup:

1. git clone https://github.com/ComputationalHealth/baikal-devenv.git
2. cd baikal-devenv/compose
3. docker-compose up -d --build
4. docker exec hadoop-namenode /bin/bash startup.sh
5. docker exec hadoop-namenode /bin/bash hive_install.sh

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

Related Repositories
----
Example applications built on this platform include:

1. [Nucleus - A Platform for Creating Laboratory Business Intelligence Dashboards and Performing Advanced Analytics on Laboratory Data](https://github.com/ComputationalHealth/nucleus)
2. [Electron - Application to Acquire Real-Time Physiologic Monitoring Data](https://github.com/ComputationalHealth/electron)
