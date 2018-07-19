#!/bin/bash
apt-get -y update
apt-get -y install sudo
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs namenode -format"
service hadoop start
service hadoop stop
service hadoop start

useradd -g hadoop storm
useradd -g hadoop nifi
useradd -g hadoop hive
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /user; /usr/local/hadoop/bin/hdfs dfs -mkdir /user/nifi; /usr/local/hadoop/bin/hdfs dfs -chown nifi:hdfs /user/nifi; /usr/local/hadoop/bin/hdfs dfs -chmod -R 777 /user/nifi"
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /data; /usr/local/hadoop/bin/hdfs dfs -chown storm:hadoop /data"
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -mkdir /user/hive; /usr/local/hadoop/bin/hdfs dfs -mkdir /user/hive/warehouse; /usr/local/hadoop/bin/hdfs dfs -chown hive:hadoop /user/hive; /usr/local/hadoop/bin/hdfs dfs -chmod -R 777 /user/hive"

echo "export HADOOP_HOME=${HADOOP_HOME}" > /usr/local/hive/conf/hive-env.sh
sudo -u hadoop -H sh -c "$HIVE_HOME/bin/schematool -initSchema -dbType postgres"
sudo -u hadoop -H sh -c cd; zeppelin-daemon.sh start
