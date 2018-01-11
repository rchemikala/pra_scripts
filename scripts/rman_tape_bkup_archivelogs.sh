######################################
### Script name
SCRIPT=rman_tape_bkup_archivelog.sh

## Setting Environment Variables ###

ORACLE_SID=xorac21

echo "Setting Oracle SID :: ${ORACLE_SID}"

### Setting RMAN backup Variables

## GEPC NetBackup Serrver
NB_ORA_SERV=usaroc9050lx200.gepc.xerox.com
## RMAN Net Backup Policy
NB_ARCH_POLICY=bc_usaroc9050ux024-rman-xorac21-arc
NB_INCR_POLICY=bc_usaroc9050ux024-rman-xorac21-incr
NB_FULL_POLICY=bc_usaroc9050ux024-rman-xorac21-full

## Mail
MAILALERT=usa.eas.dba@xerox.com,DCS.EH.Support@xerox.com
LOGDIR=$HOME/logs
export ORACLE_SID DATE LOGDIR COMPRESSION RMAN_BACKUP_DEST NB_ORA_SERV NB_INCR_POLICY NB_FULL_POLICY MAILALERT


###################################################################
#                                                                 #
########  Do not Modify Anything beyoind this line      ###########
#                                                                 #
###################################################################
# Checking OS
if [ `uname` = "Linux" ]; then
#
## Exporting Varibales
AWK=/bin/awk; export AWK
HOST=`hostname |$AWK -F. '{print $1}'`; export HOST
#
else
#
## Exporting Varibales
AWK=/bin/nawk; export AWK
HOST=`hostname |$AWK -F. '{print $1}'`; export HOST
fi
#
#####   Setting Variables
# Reading Date
DATE=`date '+%y%m%d%H%M'`; export DATE
# Checking OS
if [ `uname` = "Linux" ]; then
#
## Exporting Varibales
ORATABDIR=/etc; export ORATABDIR
AWK=/bin/awk; export AWK
SUDO=/usr/bin/sudo; export SUDO
INI=$HOME/eas-dba; export INI
HOST=`hostname |$AWK -F. '{print $1}'`; export HOST
#
else
#
## Exporting Varibales
ORATABDIR=/var/opt/oracle; export ORATABDIR
AWK=/bin/nawk; export AWK
SUDO=/usr/local/bin/sudo; export SUDO
INI=$HOME/eas-dba; export INI
HOST=`hostname |$AWK -F. '{print $1}'`; export HOST
fi
#
# Taking DBAOPER Password
DBOPERPWD=`grep DBOperPwd $HOME/eas-dba/.easdba | $AWK -F= '{print $2}' | tr XBJFHCKLPZGWRQ aeiou123456789`; export DBOPERPWD

# Updating oracle home variables
ORACLE_HOME=`cat $ORATABDIR/oratab | grep -v "^#" | grep -w $ORACLE_SID | $AWK -F: '{print $2}'`; export ORACLE_HOME
PATH=$ORACLE_HOME/bin:$PATH; export PATH
LD_LIBRARY_PATH=$ORACLE_HOME/lib; export LD_LIBRARY_PATH
TNS_ADMIN=$ORACLE_HOME/network/admin; export TNS_ADMIN


BACKUPLOG=$LOGDIR/rman_backup_error_${DATE}.log
####  Checking Maintenance Mode of Host
#
MAINTENANCE_MODE=`grep MaintenanceMode $HOME/eas-dba/config_$HOST.ini | awk -F= '{print $2}'`
if [ ${MAINTENANCE_MODE} -eq 0 ] ; then

if [ -f $HOME/logs/.lock_${SCRIPT} ]; then

        echo "Please remove the lock $HOME/logs/.lock_${SCRIPT} , Kill existing job and rereun the job !!! exiting now .."  > $BACKUPLOG
mailx -r "USA.EAS.DBA@xerox.com" -s "ERROR : XORAC2 ArchiveLog backup failed" $MAILALERT < $BACKUPLOG
exit 1


else
echo " Backup Begins "

touch $HOME/logs/.lock_${SCRIPT}

echo "RMAN Backup begins"
####################################################################
## Remove one month old log files
#
find $LOGDIR -name "rman_archivelog_backup_*.log" -mtime +60 -exec rm -f {} \;
#
# RMAN script

$ORACLE_HOME/bin/rman target / <<EOF
spool log to $LOGDIR/rman_archivelog_backup_${ORACLE_SID}_$DATE.log
allocate channel for maintenance type 'SBT_TAPE';
crosscheck archivelog all;
release channel;

run {
##########################################
# Back up the archive logs
# The FILESPERSET parameter setting depends on the number of archive logs you have.
ALLOCATE CHANNEL ch01 TYPE  'SBT_TAPE'  PARMS "ENV=(NB_ORA_SERV=${NB_ORA_SERV})";
ALLOCATE CHANNEL ch02 TYPE  'SBT_TAPE'  PARMS "ENV=(NB_ORA_SERV=${NB_ORA_SERV})";
# Set NetBackup backup policy name
SEND 'NB_ORA_POLICY=${NB_FULL_POLICY}';
SEND 'NB_ORA_SERV=${NB_ORA_SERV}';
BACKUP
  FILESPERSET 20
  FORMAT 'arch_%d_%s_%p_%T-%I'
  ARCHIVELOG ALL NOT BACKED UP ARCHIVELOG UNTIL TIME 'SYSDATE - 1/12' DELETE INPUT;

RELEASE CHANNEL ch01;
RELEASE CHANNEL ch02;
##########################################
# Backup control file
ALLOCATE CHANNEL ch00 TYPE  'SBT_TAPE'  PARMS "ENV=(NB_ORA_SERV=${NB_ORA_SERV})";
# Set NetBackup backup policy name
SEND 'NB_ORA_POLICY=${NB_FULL_POLICY}';
SEND 'NB_ORA_SERV=${NB_ORA_SERV}';

BACKUP FORMAT 'cntl_%d_%s_%p_%T-%I' CURRENT CONTROLFILE;
BACKUP FORMAT 'sbcl_%d_%s_%p_%T-%I' CURRENT CONTROLFILE FOR STANDBY;
RELEASE CHANNEL ch00;
}

allocate channel for maintenance type 'SBT_TAPE';
list backup of controlfile;
list backup of archivelog all;
release channel;

spool log off
EOF

###########################################################################
/bin/rm -f $HOME/logs/.lock_${SCRIPT}

ERROR=`cat $LOGDIR/rman_archivelog_backup_${ORACLE_SID}_$DATE.log | egrep 'ORA-|RMAN-' |wc -l` >> $BACKUPLOG
if [ $ERROR -ge 1 ]; then
mailx -r "USA.EAS.DBA@xerox.com" -s "XORAC2 RMAN ArchiveLog backup have some warnings !!!" $MAILALERT < $BACKUPLOG
fi

## Sync with RMAN catalog
$ORACLE_HOME/bin/rman << EOF
connect catalog rman_11203/ximeasrm4n4dm1n#@easdbarep.corp.xerox.com:1552/CATALOG;
connect target /;
resync catalog;
exit;
EOF

fi

else
        echo "Script will not run when the MaintenanceMode is 1 !!! exiting now .." >> $BACKUPLOG
mailx -r "USA.EAS.DBA@xerox.com" -s "XORAC2 RMAN ArchiveLog backup failed !!!" $MAILALERT < $BACKUPLOG
exit 1
fi
