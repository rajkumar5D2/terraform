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

yum install nginx -y &>>LOGPATH
validate $? "installing nginx"

systemctl enable nginx &>>LOGPATH
validate $? "enabling nginx"

systemctl start nginx &>>LOGPATH
validate $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>LOGPATH
validate $? "removing default html code"

curl -o /tmp/web.zip https://roboshop-builds.s3.amazonaws.com/web.zip &>>LOGPATH
validate $? "downloading html code"

cd /usr/share/nginx/html &>>LOGPATH
validate $? "moving to html dir"

unzip /tmp/web.zip &>>LOGPATH
validate $? "unzipping web.zip"

cp /home/centos/Devops/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf  &>>LOGPATH
validate $? "copying roboshop.conf"

systemctl restart nginx &>>LOGPATH
validate $? "restarted nginx"