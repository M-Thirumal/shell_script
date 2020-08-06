#!/bin/bash

################
# Replace the database
###Get the input from user
if [ "$(whoami)" != "root" ]; then
        echo "ERROR : Run script as Root (sudo !!) please"
        exit 1
fi
sudo -u postgres
echo "Enter the copy database name: "
read copyDatabase
currentDateTime=`date +"%Y-%m-%dT%T"`
copyDatabaseFile="$copyDatabase_$currentDateTime.sql"
echo "Database will be copied to " $copyDatabaseFile

echo "Enter the database name to delete"
read databaseToDelete;

echo "Enter the new database name"
read databaseToCreate;
## Copy the database to file
pg_dump $copyDatabase > $copyDatabaseFile
echo "Database is dumped to " $copyDatabaseFile
## Delete the database
dropdb $databaseToDelete;
echo $databaseToDelete " is deleted"
## Create new dabase
createdb $databaseToCreate;
echo $databaseToCreate " is created"
## Restore it to #$databaseToCreate
psql -U postgres $databaseToCreate < $copyDatabaseFile
##
echo "Restore successfull@" `date +"%Y-%m-%dT%T"`
