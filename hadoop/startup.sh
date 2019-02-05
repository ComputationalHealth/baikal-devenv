#!/bin/bash
apt-get -y update
apt-get -y install sudo net-tools
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs namenode -format"
service hadoop start
service hadoop stop
service hadoop start

useradd -g hadoop storm
useradd -g hadoop nifi
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /user; /usr/local/hadoop/bin/hdfs dfs -mkdir /user/nifi; /usr/local/hadoop/bin/hdfs dfs -chown nifi:hadoop /user/nifi"
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /data; /usr/local/hadoop/bin/hdfs dfs -chown storm:hadoop /data"

sudo -u hadoop -H sh -c "$ZEPPELIN_HOME/bin/zeppelin-daemon.sh start"
