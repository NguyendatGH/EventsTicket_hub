#!/bin/bash
clear

echo Building the project with Maven...

mvn clean package

echo Building the project with Maven...

cp target/*.war ~/Documents/apache-tomcat-10.1.41/webapps/

echo cp file war from target* to /tomcat/webapps/