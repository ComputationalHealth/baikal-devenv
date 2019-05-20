#!/bin/bash

# get and unpack Hive 1.2.2 binary distribution
cd /tmp
wget -q https://www-us.apache.org/dist/hive/hive-1.2.2/apache-hive-1.2.2-bin.tar.gz
tar -zxf apache-hive-1.2.2-bin.tar.gz
chown -R hadoop.hadoop apache-hive-1.2.2-bin
mv apache-hive-1.2.2-bin /usr/local/hive
rm apache-hive-1.2.2-bin.tar.gz
cd /usr/local/hive
mkdir iotmp
chown hadoop.hadoop iotmp
chmod 777 iotmp
mkdir data
chown hadoop.hadoop data
chmod 777 data

# Create hive-env.sh and place the mounted custom hive-site.xml
cd /usr/local/hive/conf
cp hive-env.sh.template hive-env.sh
chown hadoop.hadoop hive-env.sh
echo >> hive-env.sh
echo "#Customization" >> hive-env.sh
echo "export HADOOP_HOME=/usr/local/hadoop" >> hive-env.sh
echo "export HIVE_CONF_DIR=/usr/local/hive/conf" >> hive-env.sh
echo "export HIVE_AUX_JARS_PATH=\$HIVE_AUX_JARS_PATH" >> hive-env.sh
echo >> hive-env.sh

cp /root/hive-site.xml /usr/local/hive/conf
chown hadoop.hadoop /usr/local/hive/conf/hive-site.xml

# set up environment sufficiently for user hadoop
chsh -s /bin/bash hadoop
echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/scala/bin:/usr/local/spark/bin:/usr/local/zeppelin/bin:/usr/lib/jvm/java-8-oracle/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin:/usr/local/scala/bin:/usr/local/spark/bin" > /home/hadoop/.bash_profile
echo >> /home/hadoop/.bash_profile
echo >> /home/hadoop/.bash_profile
echo >> /home/hadoop/.bash_profile
echo >> /home/hadoop/.bash_profile
echo "# Custom additions (attempt to HIVE)" >> /home/hadoop/.bash_profile
echo "export HIVE_HOME=/usr/local/hive" >> /home/hadoop/.bash_profile
echo "export HIVE_CONF_DIR=/usr/local/hive/conf" >> /home/hadoop/.bash_profile
echo "export PATH=\$HIVE_HOME/bin:\$PATH" >> /home/hadoop/.bash_profile
echo "export CLASSPATH=\$CLASSPATH:/usr/local/hadoop/lib/*:." >> /home/hadoop/.bash_profile
echo "export CLASSPATH=\$CLASSPATH:/usr/local/hive/lib/*:." >> /home/hadoop/.bash_profile
echo "export HADOOP_HOME=/usr/local/hadoop" >> /home/hadoop/.bash_profile
echo >> /home/hadoop/.bash_profile
chown hadoop.hadoop /home/hadoop/.bash_profile
echo >> /home/hadoop/.bashrc
tail -n 9 /home/hadoop/.bash_profile >> /home/hadoop/.bashrc

# Download and place postgresql driver .jar
cd /usr/local/hive/lib
wget -q https://jdbc.postgresql.org/download/postgresql-42.2.5.jar
chown hadoop.hadoop postgresql-42.2.5.jar

# Download and place Maven spark-hive .jar's
cd /usr/local/spark/jars
wget -q http://central.maven.org/maven2/org/apache/spark/spark-hive_2.11/2.3.2/spark-hive_2.11-2.3.2.jar
wget -q http://central.maven.org/maven2/org/apache/spark/spark-hive-thriftserver_2.11/2.3.2/spark-hive-thriftserver_2.11-2.3.2.jar
##(for OCD/stoopidity, we mimic the non-existent ownership of the other jars)
chown 500.500 spark-hive*

# Modify Spark conf files
perl -i -ne '/(.*?)$/;print "$1:/usr/local/hive/lib/*\n"' /usr/local/spark/conf/spark-env.sh
ln -s /usr/local/hive/conf/hive-site.xml /usr/local/spark/conf/hive-site.xml
cd /usr/local/spark/conf
cp spark-defaults.conf.template spark-defaults.conf
echo >> spark-defaults.conf
echo -e "spark.sql.warehouse.dir\t\t/user/hive/warehouse" >> spark-defaults.conf

# Create hdfs directories needed for hive (assuming /user already exists)
sudo -u hadoop -i /bin/bash -c 'hadoop fs -mkdir /user/hive'
sudo -u hadoop -i /bin/bash -c 'hadoop fs -mkdir /user/hive/warehouse'
sudo -u hadoop -i /bin/bash -c 'hadoop fs -chmod g+w /tmp'
sudo -u hadoop -i /bin/bash -c 'hadoop fs -chmod g+w /user/hive/warehouse'

# Initialize hive metastore db
sudo -u hadoop -i /bin/bash -c 'schematool -dbType postgres -initSchema'

# Start both hive services (metastore & hiveserver2)
sudo -u hadoop -i /bin/bash -c 'nohup hive --service metastore >/dev/null 2>&1 &'
sudo -u hadoop -i /bin/bash -c 'nohup hiveserver2 >/dev/null 2>&1 &'

# Install/configure additional  zeppelin interpreters (leave default "spark" one as is)
sudo -u hadoop -i /bin/bash -c 'unset CLASSPATH;zeppelin-daemon.sh stop'
sudo -u hadoop -i /bin/bash -c 'unset CLASSPATH;install-interpreter.sh --name md,jdbc'
head -n 2 /usr/local/zeppelin/conf/interpreter.json > /tmp/interpreter.json
cat /root/hive_interpreter.json >> /tmp/interpreter.json
tail -n +3 /usr/local/zeppelin/conf/interpreter.json >> /tmp/interpreter.json
mv /tmp/interpreter.json /usr/local/zeppelin/conf
chown hadoop.hadoop /usr/local/zeppelin/conf/interpreter.json

# Restart zeppelin service (we'll leave as a "restart" for now)
sudo -u hadoop -i /bin/bash -c 'unset CLASSPATH;zeppelin-daemon.sh restart'
