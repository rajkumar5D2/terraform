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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGPATH
validate $? "searching for redis"

yum module enable redis:remi-6.2 -y &>>$LOGPATH

yum install redis -y &>>$LOGPATH
validate $? "installing redis"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf &>>$LOGPATH
validate $? "allowing all traffic"

systemctl enable redis &>>$LOGPATH
validate $? "enabled redis"

systemctl start redis &>>$LOGPATH
validate $? "started redis"