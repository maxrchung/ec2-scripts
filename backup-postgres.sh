#!/bin/bash

# https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
while getopts u:p:d: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        d) database=${OPTARG};;
    esac
done

# https://www.pedroalonso.net/blog/hosting-postgresql-on-a-t4g-graviton2-arm-instance-on-aws-ec2/

file_name=`date +%Y%m%d_%H%M%S`.dump
PGPASSWORD=$password pg_dump -U $username -d $database -f $file_name
bzip2 $file_name

# Glacier requires a minimum storage duration of 90+ days, so next cheapest option is one zone infrequent access
aws s3 cp $file_name.bz2 s3://maxrchung-database-backup/$database/$file_name.bz2 --storage-class ONEZONE_IA

rm $file_name.bz2
