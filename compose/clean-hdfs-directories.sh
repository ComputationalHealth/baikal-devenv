#!/bin/bash

#
# This utility cleans all data from the HDFS directories.
# Useful when want to rebuild a cluster so we can clean out the old content.
#

rm -rf ../hadoop/data-master/hdfs
rm -rf ../hadoop/data-master/logs
rm -rf ../hadoop/data-slave1/hdfs
rm -rf ../hadoop/data-slave1/logs
