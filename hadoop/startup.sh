#!/bin/bash

useradd -g hadoop storm

apt-get -y update
apt-get -y install sudo python-pip python-dev build-essential git
pip install hdfs confluent-kafka pandas scipy cython
pip install https://github.com/scikit-learn/scikit-learn/zipball/master
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs namenode -format"
service hadoop start
service hadoop stop
service hadoop start
sudo -u hadoop -H sh -c cd; zeppelin-daemon.sh start
useradd nifi
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /user; /usr/local/hadoop/bin/hdfs dfs -mkdir /user/nifi; /usr/local/hadoop/bin/hdfs dfs -chown nifi:hdfs /user/nifi; /usr/local/hadoop/bin/hdfs dfs -chmod -R 777 /user/nifi"
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /data; /usr/local/hadoop/bin/hdfs dfs -chown storm:hadoop /data"
