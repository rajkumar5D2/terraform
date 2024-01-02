#!/bin/bash
USERID=$(id -u)
DATE=$(date +%F)
LOGPATH=./logs/$DATE-$0.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

# checking(){
#   if [ $1 -ne 0 ]
#     then 
#       yum install $2 -y &>>$LOGPATH
#       validate $? "$2"
#   else
#     echo -e "\e[33m$2 already installed"
#     # exit 1
#   fi
# }


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

cp mongo.repo /etc/yum.repos.d/mongo.repo
validate $? "copied" &>> $LOGPATH

yum install mongodb-org -y &>> $LOGPATH
validate $? "mongodb installation"

systemctl enable mongod
validate $? "enabled"

systemctl start mongod
validate $? "started"

sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
validate $? "edited ip"

systemctl restart mongod
validate $? "restarted"


