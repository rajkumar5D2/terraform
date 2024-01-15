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


curl -L -o /tmp/cart.zip https://roboshop-builds.s3.amazonaws.com/cart.zip &>>LOGPATH
validate $? "downloading cart.zip"

cd /app 
validate $? "moving into app dir"

unzip /tmp/cart.zip &>>LOGPATH
validate $? "unzipping cart"

npm install &>>LOGPATH
validate $? "installing npm"

cp /home/centos/terraform/roboshop-shell-tf/cart.service /etc/systemd/system/cart.service &>>LOGPATH
validate $? "copying .service file"

systemctl daemon-reload &>>LOGPATH
validate $? "daemon-reload"

systemctl enable cart &>>LOGPATH
validate $? "enable cart"

systemctl start cart &>>LOGPATH
validate $? "start cart"
