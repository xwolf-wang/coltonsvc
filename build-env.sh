#!/bin/bash
#install requirement software
isInstall(){
  type $1
  if [ `echo $?` != 0 ]; then
    case $1 in
    git)
      sudo  yum install git-all.noarch -y
      ;;
    docker)
      sudo yum install docker.x86_64 -y
       ;;
     mvn)
      sudo yum install maven.noarch -y
      ;;
    esac

  fi
}


sudo yum install git-all.noarch -y
sudo yum install docker.x86_64 -y
sudo yum install maven.noarch -y
sudo systemctl enable docker
if [ `echo $?` != 0 ]; then
 sudo yum install docker.x86_64 -y
 sudo systemctl enable docker
fi
if [ `echo $?` != 0 ]; then
   sudo groupadd docker
fi
sudo gpasswd -a ${USER} docker
sudo systemctl restart docker

git clone https://github.com/chengxinjing/coltonsvc.git
