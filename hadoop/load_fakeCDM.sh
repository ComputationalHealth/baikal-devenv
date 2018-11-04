#!/bin/bash

## We grab the fake CDM v3 data available from these folks:
## https://github.com/LHSNet/PCORNet-CDM/tree/master/PCORNet-CDM-v3/fake-data
mkdir CDM;cd CDM
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/diagnosis.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/enrollment.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/lab_result_cm.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/procedures.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/demographic.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/encounter.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/harvest_c12umi.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/prescribing.csv
wget https://github.com/LHSNet/PCORNet-CDM/raw/master/PCORNet-CDM-v3/fake-data/vital.csv
cd ..;mkdir CDM_large;cd CDM_large
(head -n1 ../CDM/diagnosis.csv; for i in $(seq 1 $SCALE_PCORNET); do tail -n+2 ../CDM/diagnosis.csv; done) > diagnosis.csv
(head -n1 ../CDM/vital.csv; for i in $(seq 1 $_SCALE_PCORNET); do tail -n+2 ../CDM/vital.csv; done) > vital.csv
# change ownership to user "hadoop" and move to /home/hadoop
cd ..;chown hadoop.hadoop CDM;chown hadoop.hadoop CDM_large
mv CDM /home/hadoop
mv CDM_large /home/hadoop

# user "hadoop" copy to hdfs /data
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /home/hadoop/CDM /data"
sudo -u hadoop -H sh -c "/usr/local/hadoop/bin/hdfs dfs -copyFromLocal /home/hadoop/CDM_large /data"

# Clean up
sudo -u hadoop -H sh -c "rm -fr /home/hadoop/CDM"
sudo -u hadoop -H sh -c "rm -fr /home/hadoop/CDM_large"
