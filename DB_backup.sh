#!/bin/ksh
#LD_LIBRARY_PATH=/scratch/gbuora/app/gbuora/product/12.1.0.2/dbhome_1/lib
ORACLE_BASE=/scratch/gbuora/app/gbuora
ORACLE_HOME=/scratch/gbuora/app/gbuora/product/12.1.0.2/dbhome_1
#TNS_ADMIN=/spl/intbase/DB/oracletns
PATH=$ORACLE_HOME/bin:$LD_LIBRARY_PATH:$PATH

export ORACLE_HOME
export PATH
export LD_LIBRARY_PATH
export ORACLE_BASE
#export TNS_ADMIN

set -x
InitFile=/scratch/scripts/backup_scripts/ccb_inventory.csv
Host=`hostname`
DAILY_BACKUP=/backup
Date=`date +%Y%m%d`


while read i
do
DBName=`echo $i|cut -d ":" -f5`;
#SchemaName=`echo $i|cut -d ":" -f2`;
StoreBackup=`echo $i|cut -d ":" -f7`;
EnvName=`echo $i|cut -d ":" -f8`;
DBHost=`echo $i|cut -d ":" -f3`;
Version=`echo $i|cut -d ":" -f6`;

Flag_Backup='Failed '
Flag_Storage='Failed '

if [ $Host == $DBHost ]; then

expdp system/manager@$DBName dumpfile=expdp_${Host}_${DBName}_Full_${Date}.dmp logfile=expdp_${Host}_${DBName}_Full_${Date}.log Full=y directory=DAILY_BACKUP

ls $DAILY_BACKUP/expdp_${Host}_${DBName}_Full_${Date}.log

if [ $? -eq 0 ]; then

ErrorCount=`egrep -c "ORA-" $DAILY_BACKUP/expdp_${Host}_${DBName}_Full_${Date}.log`;

if [ $ErrorCount -gt 0 ]; then

    echo "$DBName database backup log has errors!!! Proceeding with other database Backup"
    Flag_Backup='Failed '

else

    echo "$DBName database backup completed successfully with No Errors"
    Flag_Backup='Success'

    if [ $StoreBackup == 'Y' ]; then
          gzip $DAILY_BACKUP/expdp_${Host}_${DBName}_Full_${Date}.dmp
          cp $DAILY_BACKUP/expdp_${Host}_${DBName}_Full_${Date}.dmp.gz /net/slcnas527/export/tudbdata/backup_dumps_devops_VMs

         if [ $? -eq 0 ]; then
             echo "$DBName database backup stored in the storage successfully"
             Flag_Storage='Success'
         else
             echo "$DBName database backup FAILED to transfer to storage"
             Flag_Storage='Failed '
         fi
         find $DAILY_BACKUP -name "expdp_${Host}_${DBName}_Full_*.*" -type f -mtime +2 -exec rm {} \;

    else

        echo "$DBName is marked for N in the backup parameter file. Hence the backup will not transfer to storage"
        gzip $DAILY_BACKUP/expdp_${Host}_${DBName}_Full_${Date}.dmp
        find $DAILY_BACKUP -name "expdp_${Host}_${DBName}_Full_*.*" -type f -mtime +2 -exec rm {} \;
        Flag_Storage='Not Required'

    fi
fi

else

echo "$DBName database backup log not Found"
Flag_Backup='Failed '

fi

#echo "# $DBName       |$Flag_Backup              |$Flag_Storage                #" >>Report.log

#echo "# $EnvName                               |$DBName                |$Flag_Backup           |$Flag_Storage                  #" >>Report.log


sqlplus /nolog << EOF
CONNECT bkpadmin/bkpadmin@MX210XLP
insert into backup_repo values('$EnvName','$DBName','$DBHost','$Version',to_date('$Date','YYYYMMDD'),'$Flag_Backup','$Flag_Storage','expdp_${Host}_${DBName}_Full_${Date}.dmp');
commit;
EXIT;
EOF



else

        echo "$DBName not residing in the host $Host"

fi

done <$InitFile

#echo "######################################################################################################################">>Report.log
#mailx -s "Database Backup Report " arun.t.kumar@oracle.com <Report.log
