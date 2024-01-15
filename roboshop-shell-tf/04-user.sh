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
validate $? "setting up node envi"

yum install nodejs -y &>>LOGPATH
validate $? "installing nodejs"

useradd roboshop &>>LOGPATH


mkdir /app &>>LOGPATH


curl -L -o /tmp/user.zip https://roboshop-builds.s3.amazonaws.com/user.zip &>>LOGPATH
validate $? "downloading user.zip"

cd /app 
validate $? "moving into app dir"

unzip /tmp/user.zip &>>LOGPATH
validate $? "unzipping user"

npm install &>>LOGPATH
validate $? "installing npm"

cp /home/centos/terraform/roboshop-shell-tf/user.service /etc/systemd/system/user.service &>>LOGPATH
validate $? "copying .service file"

systemctl daemon-reload &>>LOGPATH
validate $? "daemon-reload"

systemctl enable user &>>LOGPATH
validate $? "enable user"

systemctl start user &>>LOGPATH
validate $? "start user"

cp /home/centos/terraform/roboshop-shell-tf/mongo.repo /etc/yum.repos.d/mongo.repo &>>LOGPATH
validate $? "mysql cli install"

yum install mongodb-org-shell -y &>>LOGPATH
validate $? "mysql install"

mongo --host mongodb.mydomainproject.tech </app/schema/user.js &>>LOGPATH

validate $? "done!!"