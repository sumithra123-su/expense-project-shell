#!/bin/bash
LOGS_FLODER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d-%H-%S)
LOG_FILE="$LOGS_FLODER/$SCRIPT_NAME-$TIMESTAMP.log"
mkdir -p $LOGS_FLODER

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT() {
    if [ $USERID -ne 0]
    then
    echo -e "$R please run this script with root priveleges $N" | tee -a $LOG_FILE
    exit 1
    fi
}

VALIDATE() {
    if [$1 -ne 0]
    then
    echon-e "$2 is ...$R FAILED $N" | tee -a $LOG_FILE
    exit 1
    echo -e "$2 is...$G SUCCESS $N" | tee -a $LOG_FILE
    fi
}
echo "script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf module disable nodejs -y 
VALIDATE $? "Disable default nodejs"

dnf module enable nodejs:20 -y
VALIDATE $? "Enable nodejs:20"

dnf install nodejs -y
VALIDATE $? "Install nodejs"

id expense
if [ $? -ne 0 ]
then
echo -e "expense user not exists...$G creating $N"
useradd expense
VALIDATE $? "Creating expense user"
else
echo -e "expense user already exists... $Y SKIPPING $N"
fi

