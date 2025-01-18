#!/bin/bash

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"


LOGS_FOLDER="/var/log/expense-logs" 
LOG_FILE=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +"%d-%m-%y-%H-%S-%M")
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){

    if [ $1 -ne 0 ]
     then
          echo -e "$2... $R Failure $N"
          exit 1
     else
        echo  -e "$2... $G Success $N"

    fi  

}

CHECK_ROOT(){

if [ $USERID -ne 0 ]
then
    echo "ERROR:: you must have sudo access to execute this script"
    exit 1 #other than 0
fi

}
echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

CHECK_ROOT

dnf install nginx -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing Ngnix Server"

systemctl enable nginx &>>$LOG_FILE_NAME
VALIDATE $? "Enabling Ngnix Server"

systemctl start nginx &>>$LOG_FILE_NAME
VALIDATE $? "Started Ngnix Server"

rm -rf /usr/share/nginx/html/* &>>$LOG_FILE_NAME
VALIDATE $? "Removing existing version of code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "Downloading  Latest code"

cd /usr/share/nginx/html &>>$LOG_FILE_NAME
VALIDATE $? "Moving to Html directory"

unzip /tmp/frontend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unzipping the frontend code"

systemctl restart nginx &>>$LOG_FILE_NAME
VALIDATE $? "Restarting ngnix"





