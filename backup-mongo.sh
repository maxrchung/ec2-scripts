
#!/bin/bash

while getopts u:p:d: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        d) database=${OPTARG};;
    esac
done

file_name=`date +%Y%m%d_%H%M%S`.dump
mongodump --username=$username --password=$password --db=$database --archive=$file_name --authenticationDatabase=admin
bzip2 $file_name

aws s3 cp $file_name.bz2 s3://maxrchung-database-backup/$database/$file_name.bz2 --storage-class ONEZONE_IA

rm $file_name.bz2
