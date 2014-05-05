#!/bin/bash
dir=`dirname $0`
cd $dir
DATESTAMP=`date +%Y%m%d`
TIMESTAMP=`date +%H%M`
LOGFILE="/var/log/ec2_backup_ebs_backup.log"
 
VOLUMES=( vol-xxxxxx )

echo "EBS BACKUP $DATESTAMP $TIMESTAMP" 2>&1 | tee -a $LOGFILE
echo " " 2>&1 | tee -a $LOGFILE
 
# Create a snapshot of each volume.
for volume in ${VOLUMES[@]}
do
  php ec2-create-snapshot.php -v $volume 2>&1 | tee -a $LOGFILE
done
 
# Remove older snapshots we don't need to keep any more.
for volume in ${VOLUMES[@]}
do
  php ec2-manage-snapshots.php -v $volume 2>&1 | tee -a $LOGFILE
done

