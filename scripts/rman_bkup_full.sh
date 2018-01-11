#!/bin/sh
#
RUN_ANYTIME=Y
SCRIPT=rman_bkup_full.sh
# Purpose: Perform RMAN full backup of Oracle databases.
# NOTE: Don't modify this file. Its being pushed/deployed from
#       a central source repository. Please contact Noel if you want
#       a permanent change on this file.
# Author: Noel Doronila
# CopyRight 2001-2008 XEROX CORPORATION. All rights reserved.
# Xerox Confidential Information

CMD="$1"

# function
print_usage() {
  echo " "
  echo "Usage: ${SCRIPT}"
  echo "Usage: ${SCRIPT} force"
  echo "Usage: ${SCRIPT} {database}"
  echo "Usage: ${SCRIPT} {database} force"
  echo "Usage: ${SCRIPT} -help"
  echo "Usage: ${SCRIPT} -h"
  echo "Note: If no database argument, ALL databases in config*.ini will be processed."
  echo "Note: Parameter -force- means ignore config MaintenanceMode setting."
  echo " "
}

if [ "${CMD}" = "-help" ] || [ "${CMD}" = "-h" ] ; then
  print_usage
  /bin/rm -rf $HOME/logs/.lock-${SCRIPT}
  exit 1
else
  if [ $# -gt 3 ]; then
    echo "ERROR! Incorrect syntax. Too many input parameters."
    print_usage      
    /bin/rm -rf $HOME/logs/.lock-${SCRIPT}
    exit 1
  fi
fi

echo " "
echo "${SCRIPT} script processing started. Please wait."
echo "`date`"
echo " "

. $HOME/eas-dba/subProgSetupEnv.sh

DB_BACKUP_TYPE="RMAN Full Database"

dateLogFile=`${MKTEMP}`_1
echo `date` > $dateLogFile
MYDAY=`${CAT} $dateLogFile | ${AWK} '{print $1}'`

if [ -f ${dateLogFile} ]; then
  ${RM} ${dateLogFile}
fi

#
LEVEL="0"               # incremental level 0; equivalent to full backup
ONLINE_BACKUP="1"               # indicates if backup is performed while database is open/online

# Begin Main
#######################

. $HOME/eas-dba/rman_shared.sh

#
echo " "
echo "Done! ${SCRIPT} script processing completed."
echo "`date`"
echo " "
/bin/rm -rf $HOME/logs/.lock-${SCRIPT}


