#!/bin/bash
#install requirement software

#build
cd ./coltonsvc
mvn clean package -Dmaven.test.skip=true

#build the aws_web
if [ $# -eq 0 ]; then
    version=1
fi
version=$1
cd ./aws_web
docker build -t aws_web:v1.0.${version} .

#build the aws_gemfire
cd ../aws_gemfire
docker build -t aws_gemfire:v1.0.${version} .

#build the aws_batch

cd ../aws_batch
docker build -t aws_batch:v1.0.${version} . 

#run the container
cd ~
absoulteDir=`pwd`
mkdir -p batch/log && mkdir batch/feed
mkdir -p gemfire/log
mkdir -p web/log && mkdir web/config

echo "accessKey=" > $absoulteDir/web/config/credentials.properties
echo "secretKey=" >> $absoulteDir/web/config/credentials.properties

hostname=`hostname -I | awk '{print $1}'`
url="http://${hostname}:8080/aws/download/"

docker run -d  -v $absoulteDir/gemfire/log:/gemfire/log  --name gemfire_${version} -p 31431:31431 -p 8092:8092  -P -e LOCATORS=localhost[31431] aws_gemfire:v1.0.${version}

docker run -d -v $absoulteDir/batch/log:/batch/log -v $absoulteDir/batch/feed:/batch/feed  --name batch_${version} -p 9092:9092 -e LOCATOR_HOST=gemfire -e LOCATOR_PORT=31431 -e DOWNLOAD_URL=${url}  --link gemfire_${version}:gemfire aws_batch:v1.0.${version}

docker run -d -v $absoulteDir/web/log:/web/log  -v $absoulteDir/web/config:/web/config --name web_${version} -p 8080:8080 aws_web:v1.0.${version}