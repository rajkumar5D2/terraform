#!/bin/bash
USERID=$(id -u)
DATE=$(date +%F)
LOGPATH=./logs/$DATE-$0.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"


validate(){
  if [ $1 -ne 0 ]
    then 
      echo -e " $R failure.. $N $2"
      # exit 1
    else
      echo -e " $G success.. $N $2"
  fi
}

if [ $USERID -ne 0 ]
  then 
    echo "need root access"
    exit 1
fi

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOGPATH
validate $? "setting up node environment"

yum install nodejs -y &>>LOGPATH
validate $? "installing nodejs"

useradd roboshop &>>LOGPATH
validate $? "user added"

mkdir /app &>>LOGPATH
validate $? "directory created app"

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>LOGPATH
validate $? "zip downloaded"

cd /app &>>LOGPATH
validate $? "moved into app dir"

unzip /tmp/catalogue.zip &>>LOGPATH
validate $? "unziped"

npm install &>>LOGPATH
validate $? "installed npm"

cp /home/centos/Devops/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service &>>LOGPATH
validate $? "copied catalogue.service"

systemctl daemon-reload &>>LOGPATH
validate $? "daemon- reloaded"

systemctl enable catalogue &>>LOGPATH
validate $? "enabled"

systemctl start catalogue &>>LOGPATH
validate $? "started"

cp /home/centos/Devops/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGPATH
validate $? "copied mongod to mongo.repo"

yum install mongodb-org-shell -y &>>LOGPATH
validate $? "installed mongod client"

mongo --host 18.212.244.44 </app/schema/catalogue.js &>>LOGPATH
validate $? "connected to mongod server"