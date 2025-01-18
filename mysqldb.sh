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
          echo "$2... $R failure $N"
          exit 1
     else
        echo "$2... $G success $N"

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

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing Mysql Server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enabling Mysql Server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting Mysql Server"

mysql_secure_installation --set-root-pass ExpenseApp@1
VALIDATE $? "Setting Root Password"


