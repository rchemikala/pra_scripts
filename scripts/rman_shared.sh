#!/bin/sh
# Purpose: Shared RMAN libs called by rman_bkup_*.sh scripts
#          This script will not run properly if executed alone.
# NOTE: Don't modify this file. Its being pushed/deployed from
#       a central source repository. Please contact Noel if you want
#       a permanent change on this file.
# Author: Noel Doronila
# CopyRight 2001-2008 XEROX CORPORATION. All rights reserved.
# Xerox Confidential Information

# function
backupReports () {
# backup reports
echo " "
echo "INFO: generating backup reports  - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: generating backup reports - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

#
myRmanScript_1=`${MKTEMP}`_30
echo "configure default device type to disk;" >> ${myRmanScript_1}
echo "configure backup optimization on;" >> ${myRmanScript_1}
echo "configure retention policy to ${RETENTION_POLICY};" >> ${myRmanScript_1}

if [ ${ENTEPRISE_IND} = 1 ]; then
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${myRmanScript_1}
fi

echo "list backup summary;" >> ${myRmanScript_1}
echo "list backup by file;" >> ${myRmanScript_1}
echo "list backup of database;" >> ${myRmanScript_1}
echo "list backup of controlfile;" >> ${myRmanScript_1}
echo "list backup of archivelog all;" >> ${myRmanScript_1}
echo "list backup recoverable;" >> ${myRmanScript_1}
echo "list expired copy;" >> ${myRmanScript_1}
echo "report obsolete;" >> ${myRmanScript_1}
echo "report schema;" >> ${myRmanScript_1}
echo "configure backup optimization clear;" >> ${myRmanScript_1}

echo "configure channel device type disk clear;" >> ${myRmanScript_1}
echo "configure device type disk clear;" >> ${myRmanScript_1}

#
repLogFile=`${MKTEMP}`_14

echo "INFO! processing RMAN script below..."
echo ""
${CAT} ${myRmanScript_1}
echo ""
echo "INFO! processing RMAN script below..." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
${CAT} ${myRmanScript_1} >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

rman log=${repLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
@${myRmanScript_1}
EOF

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

rman nocatalog log=${repLogFile} << EOF
connect target /
@${myRmanScript_1}
EOF

fi

if [ -f ${myRmanScript_1} ]; then
  ${RM} ${myRmanScript_1}
fi

${CAT} ${repLogFile} >> ${JOB_RUN_LOG_FULL_PATH}

if test `${GREP} "ERROR" ${repLogFile} | wc -l` -ne 0
then
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "################################" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error when generating RMAN backup reports RMAN for ${DB} - `date`" >> ${DB_ERROR_LOG_FULL_PATH}
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${repLogFile} >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${DB_ERROR_LOG_FULL_PATH} >> ${JOB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error when generating RMAN backup reports RMAN for ${DB} - `date`"
else
  echo "PASSED - generated backup reports RMAN for ${DB}"
  echo "PASSED - generated backup reports RMAN for ${DB}" >> ${JOB_RUN_LOG_FULL_PATH}
fi

if [ -f ${repLogFile} ]; then
        ${RM} ${repLogFile}
fi

}

# function
validateDatabase () {
# validate backups
echo " "
echo "INFO: validating database whether files can be backed up - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: validating database whether files can be backed up - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

#
myRmanScript_5=`${MKTEMP}`_30
echo "configure default device type to disk;" >> ${myRmanScript_5}
echo "configure backup optimization on;" >> ${myRmanScript_5}
echo "configure retention policy to ${RETENTION_POLICY};" >> ${myRmanScript_5}

if [ ${ENTEPRISE_IND} = 1 ]; then
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${myRmanScript_5}
fi

echo "run {" >> ${myRmanScript_5}
echo "sql 'alter system archive log current';" >> ${myRmanScript_5}
echo "crosscheck archivelog all;" >> ${myRmanScript_5}
echo "backup validate database archivelog all;" >> ${myRmanScript_5}
echo "}" >> ${myRmanScript_5}

echo "configure channel device type disk clear;" >> ${myRmanScript_5}
echo "configure device type disk clear;" >> ${myRmanScript_5}

#
valLogFile=`${MKTEMP}`_14

echo "INFO! processing RMAN script below..."
echo ""
${CAT} ${myRmanScript_5}
echo ""
echo "INFO! processing RMAN script below..." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
${CAT} ${myRmanScript_5} >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

rman log=${valLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
@${myRmanScript_5}
EOF

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

rman nocatalog log=${valLogFile} << EOF
connect target /
@${myRmanScript_5}
EOF

fi

if [ -f ${myRmanScript_5} ]; then
  ${RM} ${myRmanScript_5}
fi

${CAT} ${valLogFile} >> ${JOB_RUN_LOG_FULL_PATH}

if test `${GREP} "ERROR" ${valLogFile} | wc -l` -ne 0
then
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "################################" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "WARNING! RMAN backup sets failed validation in ${DB} - `date`" >> ${DB_ERROR_LOG_FULL_PATH}
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${valLogFile} >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${DB_ERROR_LOG_FULL_PATH} >> ${JOB_ERROR_LOG_FULL_PATH}
  echo "WARNING! RMAN backup sets failed validation in ${DB} - `date`"
else
  echo "PASSED - ${DB} RMAN backup sets validation passed"
  echo "PASSED - ${DB} RMAN backup sets validation passed" >> ${JOB_RUN_LOG_FULL_PATH}
fi

if [ -f ${valLogFile} ]; then
        ${RM} ${valLogFile}
fi
}

# function
checkArchivedLogFiles () {
# crosscheck archivelog files
echo " "
echo "INFO: crosscheck archivelog files - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: crosscheck archivelog files - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

#
myRmanScript_4=`${MKTEMP}`_30
echo "configure default device type to disk;" >> ${myRmanScript_4}
echo "configure backup optimization on;" >> ${myRmanScript_4}
echo "configure retention policy to ${RETENTION_POLICY};" >> ${myRmanScript_4}

if [ ${ENTEPRISE_IND} = 1 ]; then
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${myRmanScript_4}
fi

echo "run {" >> ${myRmanScript_4}
echo "crosscheck archivelog all;" >> ${myRmanScript_4}
echo "}" >> ${myRmanScript_4}

echo "configure channel device type disk clear;" >> ${myRmanScript_4}
echo "configure device type disk clear;" >> ${myRmanScript_4}

#
arcLogFile=`${MKTEMP}`_14

echo "INFO! processing RMAN script below..."
echo ""
${CAT} ${myRmanScript_4}
echo ""
echo "INFO! processing RMAN script below..." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
${CAT} ${myRmanScript_4} >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

rman log=${arcLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
@${myRmanScript_4}
EOF

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

rman nocatalog log=${arcLogFile} << EOF
connect target /
@${myRmanScript_4}
EOF

fi

if [ -f ${myRmanScript_4} ]; then
  ${RM} ${myRmanScript_4}
fi

${CAT} ${arcLogFile} >> ${JOB_RUN_LOG_FULL_PATH}

if test `${GREP} "ERROR" ${arcLogFile} | wc -l` -ne 0
then
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "################################" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error during crosscheck of archivelog files in ${DB} - `date`" >> ${DB_ERROR_LOG_FULL_PATH}
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${arcLogFile} >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${DB_ERROR_LOG_FULL_PATH} >> ${JOB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error during crosscheck of archivelog files in ${DB} - `date`"
else
  echo "PASSED - ${DB} archivelog files crosschecked"
  echo "PASSED - ${DB} archivelog files crosschecked" >> ${JOB_RUN_LOG_FULL_PATH}
fi

if [ -f ${arcLogFile} ]; then
        ${RM} ${arcLogFile}
fi
}

# function
runRmanBackup () {

# NOTE: Oracle Non Enterprise cannot have incremental backup and cannot run in multiple channel
#       Use only RmanTargetDir=1 (PRIMARY_RMAN_DEST)

echo " "
echo "INFO: generating RMAN script ${SCRIPTFILE} - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: generating RMAN script ${SCRIPTFILE} - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

scriptFileLog=`${MKTEMP}`_77
${TOUCH} ${scriptFileLog}

targetDirSizeLog=`${MKTEMP}`_66
${TOUCH} ${targetDirSizeLog}

rmanLogFile=`${MKTEMP}`_22

if [ ${ENCRYPT_RMAN} = 1 ]; then
echo "set encryption on identified by ${RMAN_ENCRYPTOR} only;" >> ${SCRIPTFILE}
fi

echo "configure channel device type disk clear;" >> ${SCRIPTFILE}
echo "configure device type disk clear;" >> ${SCRIPTFILE}
echo "configure default device type to disk;" >> ${SCRIPTFILE}
echo "configure backup optimization on;" >> ${SCRIPTFILE}
echo "configure retention policy to ${RETENTION_POLICY};" >> ${SCRIPTFILE}
echo "configure controlfile autobackup on;" >> ${SCRIPTFILE}
echo "configure controlfile autobackup format for device type disk to '${PRIMARY_RMAN_DEST}/%F';" >> ${SCRIPTFILE}

targetDirFile=`${MKTEMP}`_656

targetDirFile=`${MKTEMP}`_6

if [ ${ENTEPRISE_IND} = 0 ]; then
# incremental backup and multiple channels requires Enterprise Edition
LEVEL=0
RMAN_PARALLELISM=1
${GREP} "RmanTargetDir=${RMAN_TARGET_DB}:1:" $HOME/eas-dba/config_${HOST}.ini > ${targetDirFile}
else
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${SCRIPTFILE}
${GREP} "RmanTargetDir=${RMAN_TARGET_DB}:" $HOME/eas-dba/config_${HOST}.ini > ${targetDirFile}
fi

#
${CAT} ${targetDirFile} | while read DIRLINE
do
firstChar=`echo "${DIRLINE}" | ${AWK} '{print substr($1,1,1)}'` # get the 1st char

if [ "$firstChar" != "#" ]
then

  MYTEMP=`echo ${DIRLINE} | ${AWK} -F= '{print $2}'`
  
  CHANNEL=`echo ${MYTEMP} | ${AWK} -F: '{print $2}'`
  RMAN_SERVICE_NAME=`echo ${MYTEMP} | ${AWK} -F: '{print $3}'`  
  TARGETFREEPCT=`echo ${MYTEMP} | ${AWK} -F: '{print $4}'`
  THEDIR=`echo ${MYTEMP} | ${AWK} -F: '{print $5}'`  

  TARGETDIR=${THEDIR}/rman
  
  if [ ! -d ${THEDIR} ]; then
          ${MKDIR} ${THEDIR}
  fi

  #
  if [ "${RMAN_SERVICE_NAME}" = "localhost" ]; then
  RMAN_CONNECT_STRING="connect /"
  else
  #Unfortunately, we have to connect as SYS to connect to remote RMAN instance.
  RMAN_SYS_PASSWD=`${GREP} "DBVar=${DB}:" $HOME/eas-dba/config_${HOST}.ini | ${AWK} -F: '{print $20}' | tr XBJFHCKLPZGWRQ aeiou123456789`    
  RMAN_CONNECT_STRING="connect 'sys/${RMAN_SYS_PASSWD}@${RMAN_SERVICE_NAME}'"
  fi   
  
  if [ ${PRECHECK_DISK_SPACE} = 1 ]; then

  #TARGET_MOUNT=`echo ${TARGETDIR} | ${AWK} -F/ '{print $2}'`
  TARGET_MOUNT="${TARGETDIR}"

  targetMountDFOutput=`${MKTEMP}`_88
  ${DF} /${TARGET_MOUNT} > ${targetMountDFOutput}
  MYTEMP2=`tail -1 ${targetMountDFOutput}`
  TARGET_MOUNT_AVAIL_BYTES=`echo ${MYTEMP2} | ${AWK} '{print $4}'`
  TARGET_MOUNT_PCT=`echo ${MYTEMP2} | ${AWK} '{print $5}'`
  TARGET_MOUNT_SIZE=`echo ${TARGET_MOUNT_PCT} | ${AWK} -F% '{print $1}'`
  if [ -f ${targetMountDFOutput} ]; then
                  ${RM} ${targetMountDFOutput}
  fi

  echo " "
  echo " " >> ${JOB_RUN_LOG_FULL_PATH}
  echo "INFO: Note: The disk for ${TARGETDIR} directory is ${TARGET_MOUNT_PCT} full or has ${TARGET_MOUNT_AVAIL_BYTES} Kbytes free space."
  echo "INFO: Note: The disk for ${TARGETDIR} directory is ${TARGET_MOUNT_PCT} full or has ${TARGET_MOUNT_AVAIL_BYTES} Kbytes free space." >> ${JOB_RUN_LOG_FULL_PATH}

  if [ "${RMAN_MAX_PIECE_SIZE}" != "unlimited" ] && [ ${TARGET_MOUNT_AVAIL_BYTES} -gt ${RMAN_MAX_PIECE_SIZE} ]; then

  if [ ${TARGETFREEPCT} -gt ${TARGET_MOUNT_SIZE} ]; then

  #
  if [ ${IS_ORACLE_CLUSTER} = 1 ]; then

  MY_CLUSTER_LINE=`${GREP} "DBClusterNode=${HOST}:[^()]*:${DB}" $HOME/eas-dba/config_${HOST}.ini | ${AWK} -F= '{print $2}'`
  CLUSTER_NAME=`echo "${MY_CLUSTER_LINE}" | ${AWK} -F: '{print $2}'`

  RMANDIR=${TARGETDIR}/${CLUSTER_NAME}

  else

  RMANDIR=${TARGETDIR}/${DB}

  fi

  #
  if [ ! -d ${RMANDIR} ]; then
          ${MKDIR} ${RMANDIR}
  fi

  if [ "${RMAN_MAX_PIECE_SIZE}" = "unlimited" ]; then
    ATTRIB1=""
  else
    ATTRIB1="maxpiecesize ${RMAN_MAX_PIECE_SIZE}K"
  fi

  if [ ${ORACLE10G} = 1 ]; then  
    echo "configure channel ${CHANNEL} device type disk format '${RMANDIR}/%I-%Y%M%D-%U' ${ATTRIB1} ${RMAN_CONNECT_STRING};" >> ${scriptFileLog}
  else
    echo "configure channel ${CHANNEL} device type disk format '${RMANDIR}/%Y%M%D-%U' ${ATTRIB1} ${RMAN_CONNECT_STRING};" >> ${scriptFileLog}
  fi

  else

    echo " "
    echo " " >> ${JOB_RUN_LOG_FULL_PATH}
    echo "ERROR! The /${TARGET_MOUNT} free space is only ${TARGET_MOUNT_AVAIL_BYTES} Kbytes. RMAN maxpiecesize value is set to ${RMAN_MAX_PIECE_SIZE} Kbytes. ${TARGETDIR} directory will not be used during this RMAN job."
    echo "ERROR! The /${TARGET_MOUNT} free space is only ${TARGET_MOUNT_AVAIL_BYTES} Kbytes. RMAN maxpiecesize value is set to ${RMAN_MAX_PIECE_SIZE} Kbytes. ${TARGETDIR} directory will not be used during this RMAN job." >> ${targetDirSizeLog}
    ${CAT} ${targetDirSizeLog} >> ${JOB_RUN_LOG_FULL_PATH}
    
    echo "configure channel ${CHANNEL} device type disk clear;" >> ${scriptFileLog}

  fi

  else

    echo " "
    echo " " >> ${JOB_RUN_LOG_FULL_PATH}
    echo "ERROR! The /${TARGET_MOUNT} free space is only ${TARGET_MOUNT_AVAIL_BYTES} Kbytes. RMAN maxpiecesize value is set to ${RMAN_MAX_PIECE_SIZE} Kbytes. ${TARGETDIR} directory will not be used during this RMAN job."
    echo "ERROR! The /${TARGET_MOUNT} free space is only ${TARGET_MOUNT_AVAIL_BYTES} Kbytes. RMAN maxpiecesize value is set to ${RMAN_MAX_PIECE_SIZE} Kbytes. ${TARGETDIR} directory will not be used during this RMAN job." >> ${targetDirSizeLog}
    ${CAT} ${targetDirSizeLog} >> ${JOB_RUN_LOG_FULL_PATH}
    
    echo "configure channel ${CHANNEL} device type disk clear;" >> ${scriptFileLog}

  fi
  
  else

    echo " "
    echo " " >> ${JOB_RUN_LOG_FULL_PATH}
    echo "INFO: Skipped checking of ${TARGETDIR} for available disk space."
    echo "INFO: Skipped checking of ${TARGETDIR} for available disk space." >> ${JOB_RUN_LOG_FULL_PATH}

    #
    if [ ${IS_ORACLE_CLUSTER} = 1 ]; then

    MY_CLUSTER_LINE=`${GREP} "DBClusterNode=${HOST}:[^()]*:${DB}" $HOME/eas-dba/config_${HOST}.ini | ${AWK} -F= '{print $2}'`
    CLUSTER_NAME=`echo "${MY_CLUSTER_LINE}" | ${AWK} -F: '{print $2}'`

    RMANDIR=${TARGETDIR}/${CLUSTER_NAME}

    else

    RMANDIR=${TARGETDIR}/${DB}

    fi

    #
    if [ ! -d ${RMANDIR} ]; then
            ${MKDIR} ${RMANDIR}
    fi

    if [ "${RMAN_MAX_PIECE_SIZE}" = "unlimited" ]; then
      ATTRIB1=""
    else
      ATTRIB1="maxpiecesize ${RMAN_MAX_PIECE_SIZE}K"
    fi 

    if [ ${ORACLE10G} = 1 ]; then
      echo "configure channel ${CHANNEL} device type disk format '${RMANDIR}/%I-%Y%M%D-%U' ${ATTRIB1} ${ATTRIB1} ${RMAN_CONNECT_STRING};" >> ${scriptFileLog}
    else
      echo "configure channel ${CHANNEL} device type disk format '${RMANDIR}/%Y%M%D-%U' ${ATTRIB1} ${RMAN_CONNECT_STRING};" >> ${scriptFileLog}
    fi
  
  fi

fi
done

if [ -s ${scriptFileLog} ]; then
        ${CAT} ${scriptFileLog} >> ${SCRIPTFILE}
fi

if [ -f ${targetDirFile} ]; then
        ${RM} ${targetDirFile}
fi

echo "show all;" >> ${SCRIPTFILE}

echo "run {" >> ${SCRIPTFILE}

maxCorruptFileLog=`${MKTEMP}`_077
# Datafiles that RMAN will ignore the error if has block corruption
${GREP} "RmanMaxCorruptValue=${DB}:" $HOME/eas-dba/config_${HOST}.ini > ${maxCorruptFileLog}
${CAT} ${maxCorruptFileLog} | while read MAX_CORRUPT_LINE
do
firstChar=`echo "${MAX_CORRUPT_LINE}" | ${AWK} '{print substr($1,1,1)}'` # get the 1st char
DFILE_NUM=`echo ${MAX_CORRUPT_LINE} | ${AWK} -F: '{print $2}'`
CORRUPT_LEVEL=`echo ${MAX_CORRUPT_LINE} | ${AWK} -F: '{print $3}'`
if [ "$firstChar" != "#" ]
then
echo "set maxcorrupt for datafile ${DFILE_NUM} to ${CORRUPT_LEVEL};" >> ${SCRIPTFILE}
fi
done
#
if [ -f ${maxCorruptFileLog} ]; then
  ${RM} ${maxCorruptFileLog}
fi

ATTRIB2=""
#if [ "${DBMODE}" = "ARCHIVELOG" ];then
#  if [ ${DELETE_ARCH_LOG} = 1 ]; then
#          ATTRIB2="plus archivelog delete all input"
#  else
#          ATTRIB2="plus archivelog"
#  fi
#fi

ATTRIB3=""
if [ ${RMAN_HAS_ORA600_KRBODO_BUG} = 1 ] && [ ${LEVEL} = 0 ];then
ATTRIB3="blocks all"
fi

ATTRIB4=""
#if [ ${LEVEL} != 0 ];then
# TBD: ATTRIB4="for recover of copy"
#fi

if [ ${ORACLE10G} = 1 ]; then
  echo "backup ${ATTRIB3} as compressed backupset incremental level ${LEVEL} ${ATTRIB4} check logical database ${ATTRIB2};" >> ${SCRIPTFILE}
else
  echo "backup ${ATTRIB3} incremental level ${LEVEL} ${ATTRIB4} check logical database ${ATTRIB2};" >> ${SCRIPTFILE}
fi

echo "}" >> ${SCRIPTFILE}

if [ "${DBMODE}" = "ARCHIVELOG" ]
then
echo "sql 'alter system archive log current';" >> ${SCRIPTFILE}
fi

targetDirFile=`${MKTEMP}`_6

if [ ${ENTEPRISE_IND} = 0 ]; then
# incremental backup and multiple channels requires Enterprise Edition
LEVEL=0
RMAN_PARALLELISM=1
${GREP} "RmanTargetDir=${RMAN_TARGET_DB}:1:" $HOME/eas-dba/config_${HOST}.ini > ${targetDirFile}
else
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${SCRIPTFILE}
${GREP} "RmanTargetDir=${RMAN_TARGET_DB}:" $HOME/eas-dba/config_${HOST}.ini > ${targetDirFile}
fi

#
${CAT} ${targetDirFile} | while read DIRLINE
do
firstChar=`echo "${DIRLINE}" | ${AWK} '{print substr($1,1,1)}'` # get the 1st char
if [ "$firstChar" != "#" ]
then
  MYTEMP=`echo ${DIRLINE} | ${AWK} -F= '{print $2}'`  
  CHANNEL=`echo ${MYTEMP} | ${AWK} -F: '{print $2}'`
  RMAN_SERVICE_NAME=`echo ${MYTEMP} | ${AWK} -F: '{print $3}'`  
  echo "configure channel ${CHANNEL} device type disk clear;" >> ${SCRIPTFILE}
fi
done

echo "configure maxsetsize clear;" >> ${SCRIPTFILE}
echo "configure backup optimization clear;" >> ${SCRIPTFILE}
echo "configure controlfile autobackup clear;" >> ${SCRIPTFILE}
echo "configure controlfile autobackup format for device type disk clear;" >> ${SCRIPTFILE}
echo "configure channel device type disk clear;" >> ${SCRIPTFILE}
echo "configure device type disk clear;" >> ${SCRIPTFILE}

if [ -s ${scriptFileLog} ]; then

echo " "
echo "INFO: processing RMAN script ${SCRIPTFILE} - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: processing RMAN script ${SCRIPTFILE} - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

echo "INFO! processing RMAN script below..."
echo ""
${CAT} ${SCRIPTFILE}
echo ""
echo "INFO! processing RMAN script below..." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
${CAT} ${SCRIPTFILE} >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

rman log=${rmanLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
@${SCRIPTFILE}
EOF

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

rman nocatalog log=${rmanLogFile} << EOF
connect target /
@${SCRIPTFILE}
EOF

fi

${CAT} ${rmanLogFile} >> ${JOB_RUN_LOG_FULL_PATH}

else

  echo ""
  echo "ERROR! Target RMAN diretories did not meet the specified free space size criterias - `date`"

  echo "" >> ${targetDirSizeLog}
  echo "################################" >> ${targetDirSizeLog}
  echo "ERROR! Target RMAN diretories did not meet specified free space size criteria - `date`" >> ${targetDirSizeLog}
  ${CAT} ${targetDirSizeLog} >> ${JOB_RUN_LOG_FULL_PATH}

fi

if (test `${GREP} "ERROR" ${rmanLogFile} | wc -l` -ne 0 ) || (test `${GREP} "ERROR" ${targetDirSizeLog} | wc -l` -ne 0)
then
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "################################" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error during processing of RMAN script ${SCRIPTFILE} for ${DB} - `date`" >> ${DB_ERROR_LOG_FULL_PATH}
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${rmanLogFile} >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${targetDirSizeLog} >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${DB_ERROR_LOG_FULL_PATH} >> ${JOB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error during RMAN backup of ${DB} - `date`"
else
  echo "PASSED - successfull processing of RMAN script ${SCRIPTFILE} for ${DB}"
  echo "PASSED - successfull processing of RMAN script ${SCRIPTFILE} for ${DB}" >> ${JOB_RUN_LOG_FULL_PATH}
fi

if [ -f ${targetDirSizeLog} ]; then
        ${RM} ${targetDirSizeLog}
fi

if [ -f ${rmanLogFile} ]; then
        ${RM} ${rmanLogFile}
fi

if [ -f ${scriptFileLog} ]; then
        ${RM} ${scriptFileLog}
fi

if [ -f ${targetDirFile} ]; then
  ${RM} ${targetDirFile}
fi

}

# function
deleteOldBackup () {
# delete obsolete and expired backupsets
echo " "
echo "INFO: deleting obsolete and expired backupsets - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: deleting obsolete and expired backupsets - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

#
myRmanScript_2=`${MKTEMP}`_30
echo "configure default device type to disk;" >> ${myRmanScript_2}
echo "configure backup optimization on;" >> ${myRmanScript_2}
echo "configure retention policy to ${RETENTION_POLICY};" >> ${myRmanScript_2}

if [ ${ENTEPRISE_IND} = 1 ]; then
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${myRmanScript_2}
fi

echo "allocate channel for maintenance device type disk;" >> ${myRmanScript_2}

echo "run {" >> ${myRmanScript_2}
echo "crosscheck copy of controlfile;" >> ${myRmanScript_2}
echo "crosscheck copy of archivelog all;" >> ${myRmanScript_2}
echo "crosscheck backup;" >> ${myRmanScript_2}
echo "crosscheck backup of controlfile;" >> ${myRmanScript_2}
echo "crosscheck backup of archivelog all;" >> ${myRmanScript_2}
echo "delete noprompt expired backup;" >> ${myRmanScript_2}
echo "delete noprompt obsolete;" >> ${myRmanScript_2}
echo "delete noprompt obsolete orphan;" >> ${myRmanScript_2}
echo "delete noprompt expired copy;" >> ${myRmanScript_2}
echo "}" >> ${myRmanScript_2}

echo "configure channel device type disk clear;" >> ${myRmanScript_2}
echo "configure device type disk clear;" >> ${myRmanScript_2}

#
delLogFile=`${MKTEMP}`_14

echo "INFO! processing RMAN script below..."
echo ""
${CAT} ${myRmanScript_2}
echo ""
echo "INFO! processing RMAN script below..." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
${CAT} ${myRmanScript_2} >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

rman log=${delLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
@${myRmanScript_2}
EOF

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

rman nocatalog log=${delLogFile} << EOF
connect target /
@${myRmanScript_2}
EOF

fi

if [ -f ${myRmanScript_2} ]; then
  ${RM} ${myRmanScript_2}
fi

${CAT} ${delLogFile} >> ${JOB_RUN_LOG_FULL_PATH}

if test `${GREP} "ERROR" ${delLogFile} | wc -l` -ne 0
then
  if ( test `${GREP} "ERROR" ${delLogFile} | wc -l` -eq 1 ) && ( test `${GREP} "RMAN-20242: specification does not match any archive log in the recovery catalog" ${delLogFile} | wc -l` -ne 0 )
  then
      echo " "
    echo "PASSED - ${DB} obsolete and expired RMAN backupsets deleted"
    echo "Note: This error log occured and should be ignored: [ RMAN-20242: specification does not match any archive log in the recovery catalog ]"
      echo " "
      echo " " >> ${JOB_RUN_LOG_FULL_PATH}
    echo "PASSED - ${DB} obsolete and expired RMAN backupsets deleted" >> ${JOB_RUN_LOG_FULL_PATH}
    echo "Note: This error log occured and should be ignored: [ RMAN-20242: specification does not match any archive log in the recovery catalog ]" >> ${JOB_RUN_LOG_FULL_PATH}
      echo " " >> ${JOB_RUN_LOG_FULL_PATH}
  else
    echo "" >> ${DB_ERROR_LOG_FULL_PATH}
    echo "################################" >> ${DB_ERROR_LOG_FULL_PATH}
    echo "WARNING! Error when deleting obsolete and expired RMAN backupsets in ${DB} - `date`" >> ${DB_ERROR_LOG_FULL_PATH}
    echo "" >> ${DB_ERROR_LOG_FULL_PATH}
    ${CAT} ${delLogFile} >> ${DB_ERROR_LOG_FULL_PATH}
${CAT} ${DB_ERROR_LOG_FULL_PATH} >> ${JOB_ERROR_LOG_FULL_PATH}
    echo "WARNING! Error when deleting obsolete and expired RMAN backupsets in ${DB} - `date`"
  fi
else
  echo "DONE - deleting obsolete and expired RMAN backupsets completed in ${DB}"  >> ${JOB_RUN_LOG_FULL_PATH} >> ${JOB_RUN_LOG_FULL_PATH}
fi

if [ -f ${delLogFile} ]; then
        ${RM} ${delLogFile}
fi
}

# function
deleteExistingBackup () {
# delete existing backupsets
echo " "
echo "INFO: deleting ALL existing backupsets - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: deleting ALL existing backupsets - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

#
myRmanScript_3=`${MKTEMP}`_30
echo "configure default device type to disk;" >> ${myRmanScript_3}
echo "configure backup optimization on;" >> ${myRmanScript_3}
echo "configure retention policy to ${RETENTION_POLICY};" >> ${myRmanScript_3}
echo "allocate channel for maintenance device type disk;" >> ${myRmanScript_3}

if [ ${ENTEPRISE_IND} = 1 ]; then
echo "configure device type disk parallelism ${RMAN_PARALLELISM};" >> ${myRmanScript_3}
fi

echo "run {" >> ${myRmanScript_3}
echo "delete force noprompt backup of database completed before 'sysdate';" >> ${myRmanScript_3}
echo "delete force noprompt backup of controlfile completed before 'sysdate';" >> ${myRmanScript_3}
echo "delete force noprompt backup of archivelog all completed before 'sysdate';" >> ${myRmanScript_3}
echo "}" >> ${myRmanScript_3}

echo "configure channel device type disk clear;" >> ${myRmanScript_3}
echo "configure device type disk clear;" >> ${myRmanScript_3}

#
delExistingLogFile=`${MKTEMP}`_14

echo "INFO! processing RMAN script below..."
echo ""
${CAT} ${myRmanScript_3}
echo ""
echo "INFO! processing RMAN script below..." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
${CAT} ${myRmanScript_3} >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

rman log=${delExistingLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
@${myRmanScript_3}
EOF

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

rman nocatalog log=${delExistingLogFile} << EOF
connect target /
@${myRmanScript_3}
EOF

fi

if [ -f ${myRmanScript_3} ]; then
  ${RM} ${myRmanScript_3}
fi

${CAT} ${delExistingLogFile}  >> ${JOB_RUN_LOG_FULL_PATH}

echo " "
echo "DONE - deleting ALL existing RMAN backupsets completed in ${DB}"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "DONE - deleting ALL existing RMAN backupsets completed in ${DB}" >> ${JOB_RUN_LOG_FULL_PATH}
echo " " >> ${JOB_RUN_LOG_FULL_PATH}

if [ -f ${delExistingLogFile} ]; then
        ${RM} ${delExistingLogFile}
fi
}

# function
genRecoveryScript () {

echo " "
echo "INFO: generating post-recovery supporting scripts - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: generating post-recovery supporting scripts - `date`" >> ${JOB_RUN_LOG_FULL_PATH}
echo " " >> ${JOB_RUN_LOG_FULL_PATH}

RMAN_RECOVERY_SCRIPT=${PRIMARY_RMAN_DEST}/script_rman_recovery_database_${DB}.log

MYVIEW="v\$database"
sqlLogFile=`${MKTEMP}`_17
sqlplus -s "/ as sysdba" > ${sqlLogFile} << EOF
start $HOME/eas-dba/hbsetting.sql
select dbid from ${MYVIEW};
exit;
EOF
DBID="`tail -1 ${sqlLogFile}`"

if [ -f ${sqlLogFile} ]; then
        ${RM} ${sqlLogFile}
fi

#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo ""
echo "INFO! This RMAN session was connected to recovery catalog database ${RMAN_CATALOG_DSN}."
echo ""

echo "rman" > ${RMAN_RECOVERY_SCRIPT}
echo "connect target /" >> ${RMAN_RECOVERY_SCRIPT}
echo "connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}" >> ${RMAN_RECOVERY_SCRIPT}

else

echo ""
echo "INFO! This RMAN session was using target database control file instead of recovery catalog."
echo ""

echo "rman nocatalog" > ${RMAN_RECOVERY_SCRIPT}
echo "connect target /" >> ${RMAN_RECOVERY_SCRIPT}

fi


echo "set dbid ${DBID};" >> ${RMAN_RECOVERY_SCRIPT}

echo "startup force nomount;" >> ${RMAN_RECOVERY_SCRIPT}

echo "set controlfile autobackup format for device type disk to '${PRIMARY_RMAN_DEST}/%F';" >> ${RMAN_RECOVERY_SCRIPT}

echo "run {" >> ${RMAN_RECOVERY_SCRIPT}
echo "set until time \"TO_DATE('${START_DATE}','MM/DD/YYYY HH24:MI')\";" >> ${RMAN_RECOVERY_SCRIPT}
echo "restore controlfile from autobackup;" >> ${RMAN_RECOVERY_SCRIPT}
echo "alter database mount;" >> ${RMAN_RECOVERY_SCRIPT}
echo "restore database;" >> ${RMAN_RECOVERY_SCRIPT}
echo "recover database noredo;" >> ${RMAN_RECOVERY_SCRIPT}
echo "alter database open resetlogs;" >> ${RMAN_RECOVERY_SCRIPT}
echo "}" >> ${RMAN_RECOVERY_SCRIPT}

tempLogFile=`${MKTEMP}`_12
sqlplus -s "/ as sysdba" > ${tempLogFile} << EOF
 start $HOME/eas-dba/hbsetting.sql
 select TABLESPACE_NAME||':'||FILE_NAME||':'||substr(FILE_NAME,INSTR(FILE_NAME ,'/','-1',1)+1)||':'||FILE_ID||':'||floor(BYTES/1000000)
 from sys.dba_temp_files
 order by 1;
 exit
EOF
cat ${tempLogFile} | while read TFLINE
do
if [ ! "${TFLINE}" = 'Connected.' ]; then
TS=`echo ${TFLINE} | ${AWK} -F: '{print $1}'`
DFILE=`echo ${TFLINE} | ${AWK} -F: '{print $2}'`
FILE=`echo ${TFLINE} | ${AWK} -F: '{print $3}'`
FID=`echo ${TFLINE} | ${AWK} -F: '{print $4}'`
SIZEMB=`echo ${TFLINE} | ${AWK} -F: '{print $5}'`

echo "sql 'alter tablespace ${TS} add tempfile '${DFILE}' size ${SIZEMB} m reuse';" >> ${RMAN_RECOVERY_SCRIPT}

fi
done
if [ -f ${tempLogFile} ]; then
        ${RM} ${tempLogFile}
fi

chmod 770 ${RMAN_RECOVERY_SCRIPT}

echo " "
echo "DONE - generating post-recovery supporting scripts completed"
echo " "

echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "DONE - generating post-recovery supporting scripts completed" >> ${JOB_RUN_LOG_FULL_PATH}
echo " " >> ${JOB_RUN_LOG_FULL_PATH}

}

# function
checkDbIfArchivelogMode () {
echo " "
echo "INFO: check if database is in archivelog mode - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: check if database is in archivelog mode - `date`" >> ${JOB_RUN_LOG_FULL_PATH}
MYVIEW="v\$database"
sqlLogFile=`${MKTEMP}`_15
sqlplus -s "/ as sysdba" > ${sqlLogFile} << EOF
start $HOME/eas-dba/hbsetting.sql
select upper(LOG_MODE) from ${MYVIEW};
exit;
EOF
DBMODE="`tail -1 ${sqlLogFile}`"

echo "INFO: ${DB} is operating in ${DBMODE} mode"
echo "INFO: ${DB} is operating in ${DBMODE} mode" >> ${JOB_RUN_LOG_FULL_PATH}

if [ -f ${sqlLogFile} ]; then
        ${RM} ${sqlLogFile}
fi

}

# function
checkDbEditionRelease () {
echo " "
echo "INFO: check the database edition and release - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: check the database edition and release - `date`" >> ${JOB_RUN_LOG_FULL_PATH}
result=`sqlplus dbaoper/${DBOPERPWD} << EOF
exit;
EOF`
Dummy=`echo ${result} | grep -v grep | grep -c "Enterprise Edition"`
if [ $? -eq 0 ]
then
ENTEPRISE_IND=1
echo "INFO: ${DB} database is an enterprise edition"
echo "INFO: ${DB} database is an enterprise edition" >> ${JOB_RUN_LOG_FULL_PATH}
else
ENTEPRISE_IND=0
echo "INFO: ${DB} database is not an enterprise edition"
echo "INFO: ${DB} database is not an enterprise edition" >> ${JOB_RUN_LOG_FULL_PATH}
fi
if [ ! ${ORACLE9I_ABOVE} = 1 ]; then
Dummy=`echo ${result} | grep -v grep | grep -c "Release 8.1"`
if [ $? -eq 0 ]
then
REL8_IND=1
echo "INFO: ${DB} database is release 8.1.+"
echo "INFO: ${DB} database is release 8.1.+" >> ${JOB_RUN_LOG_FULL_PATH}
else
REL8_IND=0
echo "INFO: ${DB} database is not release 8.1.+"
#echo "INFO: ${DB} database is not release 8.1.+" >> ${JOB_RUN_LOG_FULL_PATH}
fi
fi

relLogFile=`${MKTEMP}`_15
echo ${result} > ${relLogFile}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
grep "Oracle Database 10g" ${relLogFile} | grep -v grep >> ${JOB_RUN_LOG_FULL_PATH}
grep "Oracle9i" ${relLogFile} | grep -v grep >> ${JOB_RUN_LOG_FULL_PATH}
grep "Oracle8i" ${relLogFile} | grep -v grep >> ${JOB_RUN_LOG_FULL_PATH}

if [ -f ${relLogFile} ]; then
        ${RM} ${relLogFile}
fi
}

# function
resyncCatalog () {
echo " "
echo "INFO: resyncing the catalog - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: resyncing the RMAN catalog - `date`" >> ${JOB_RUN_LOG_FULL_PATH}

if [ ${ORACLE9I_ABOVE} = 1 ]; then

rman << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
register database;
EOF

resyncLogFile=`${MKTEMP}`_14
rman log=${resyncLogFile} << EOF
connect target /
connect catalog ${RMANUSER}/${RMANPWD}@${RMAN_CATALOG_DSN}
resync catalog;
EOF
${CAT} ${resyncLogFile} >> ${JOB_RUN_LOG_FULL_PATH}

if test `${GREP} "ERROR" ${resyncLogFile} | wc -l` -ne 0
then
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "################################" >> ${DB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error during resyncing the RMAN catalog for ${DB} - `date`" >> ${DB_ERROR_LOG_FULL_PATH}
        echo "" >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${resyncLogFile} >> ${DB_ERROR_LOG_FULL_PATH}
  ${CAT} ${DB_ERROR_LOG_FULL_PATH} >> ${JOB_ERROR_LOG_FULL_PATH}
  echo "WARNING! Error resyncing the RMAN catalog for ${DB} - `date`"
else
  echo "PASSED - ${DB} RMAN catalog for ${DB} resynced."
  echo "PASSED - ${DB} RMAN catalog for ${DB} resynced." >> ${JOB_RUN_LOG_FULL_PATH}
fi

if [ -f ${resyncLogFile} ]; then
        ${RM} ${resyncLogFile}
fi

fi
}

# function
processRMAN () {
#

TAG="rman"
RUN_LOG_TYPE="Backup"
. $HOME/eas-dba/subProgSetupLogFiles.sh

#
. $HOME/eas-dba/subProgSetOracleEnvironment.sh

#
. $HOME/eas-dba/subProgCheckRmanCatalogConnection.sh

# Do only if oracle is up
CheckOracleIfUP=`sqlplus dbaoper/${DBOPERPWD} << EOF
exit;
EOF`

Dummy=`echo ${CheckOracleIfUP} | grep -v grep | grep -c "SQL>"`
if [ $? -eq 0 ]
then

RUN_LOG_FILENAME="${JOB_RUN_LOG_NAME}"
. $HOME/eas-dba/subProgInsertRunLog.sh

. $HOME/eas-dba/subProgInsertBackupJob.sh

#
. $HOME/eas-dba/subProgSizeAllMountPoints.sh

#
RMAN_BKUPDIR=${BACKUPBASEDIR}/rman
if [ ! -d ${RMAN_BKUPDIR} ]; then
        ${MKDIR} ${RMAN_BKUPDIR}
fi

#
if [ ${IS_ORACLE_CLUSTER} = 1 ]; then

  MY_CLUSTER_LINE=`${GREP} "DBClusterNode=${HOST}:[^()]*:${DB}" $HOME/eas-dba/config_${HOST}.ini | ${AWK} -F= '{print $2}'`
  CLUSTER_NAME=`echo "${MY_CLUSTER_LINE}" | ${AWK} -F: '{print $2}'`

  BKUPDIR=${RMAN_BKUPDIR}/${CLUSTER_NAME}

  PRIMARY_RMAN_DEST="`${GREP} "RmanTargetDir=${CLUSTER_NAME}:1:" $HOME/eas-dba/config_${HOST}.ini | ${AWK} -F: '{print $5}'`/rman/${CLUSTER_NAME}"

  RMAN_TARGET_DB=${CLUSTER_NAME}  

else

  BKUPDIR=${RMAN_BKUPDIR}/${DB}

  PRIMARY_RMAN_DEST="`${GREP} "RmanTargetDir=local:1:" $HOME/eas-dba/config_${HOST}.ini | ${AWK} -F: '{print $5}'`/rman/${DB}"
  
  RMAN_TARGET_DB="local"

fi

#
if [ ! -d ${BKUPDIR} ]; then
  ${MKDIR} ${BKUPDIR}
fi

echo "${ORACLE_DBID}" > ${PRIMARY_RMAN_DEST}/${DB}_dbid

echo " "
echo "#################################################"
echo "#  RMAN DATABASE BACKUP"
echo "#  Server: ${SERVER}              "
echo "#  Database: ${DB}                "
echo "#  Primary Backup Destination:  ${PRIMARY_RMAN_DEST}  "
echo "#  Date: `date`                         "
echo "#################################################"

echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "#################################################" >> ${JOB_RUN_LOG_FULL_PATH}
echo "#  RMAN DATABASE BACKUP " >> ${JOB_RUN_LOG_FULL_PATH}
echo "#  Server: ${SERVER}              " >> ${JOB_RUN_LOG_FULL_PATH}
echo "#  Database: ${DB}                " >> ${JOB_RUN_LOG_FULL_PATH}
echo "#  Primary Backup Destination:  ${PRIMARY_RMAN_DEST}  " >> ${JOB_RUN_LOG_FULL_PATH}
echo "#  Date: `date`                         " >> ${JOB_RUN_LOG_FULL_PATH}
echo "#################################################" >> ${JOB_RUN_LOG_FULL_PATH}

START_DATE=`date '+%m/%d/%Y %H:%M'`

RBKFILE=rman_${DB}_${DATE}

SCRIPTFILE=$HOME/logs/script_${RBKFILE}.log

${TOUCH} ${SCRIPTFILE}

if [ ${ORACLE9I_ABOVE} = 1 ]; then

#
checkDbEditionRelease

#
checkDbIfArchivelogMode

#
if ( [ "${LEVEL}" = "0" ] && [ "${DBMODE}" = "NOARCHIVELOG" ] ) || ( [ "${LEVEL}" = "0" ] && [ ${ONLINE_BACKUP} = 0 ] )
then
sqlplus -s "/ as sysdba" << EOF
shutdown immediate;
startup force restrict;
shutdown immediate;
startup mount;
exit
EOF
fi

#
if [ ${DELETE_RMAN_BACKUP} = 1 ] && [ "${LEVEL}" = "0" ]
then
deleteExistingBackup
fi

#
if [ "${DBMODE}" = "ARCHIVELOG" ]
then
checkArchivedLogFiles
fi

#
if [ ${VALIDATE_DATABASE} = 1 ] && [ "${LEVEL}" = "0" ]
then
validateDatabase
else
echo " "
echo "INFO: skipped validating database whether files can be backed up - `date`"
echo " "
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "INFO: skipped validating database whether files can be backed up - `date`" >> ${JOB_RUN_LOG_FULL_PATH}
fi

# run rull/incremental backup only if db is in archivelog mode
# OR full backup only if in noarchivelog

if ( [ "${DBMODE}" = "ARCHIVELOG" ] ) || ( [ "${LEVEL}" = "0" ] && [ "${DBMODE}" = "NOARCHIVELOG" ] ) || ( [ "${LEVEL}" = "0" ] && [ ${ONLINE_BACKUP} = 0 ] )
then

#
runRmanBackup

#


#
if [ ${RMAN_CATALOG_CONNECT_OK} = 1 ]; then

echo " "
echo "INFO: skipped resyncing the control file to recovery catalog database ${RMAN_CATALOG_DSN} since this RMAN session does not use the control file during processing."
echo " "

else

resyncCatalog

fi

#
if ( [ "${LEVEL}" = "0" ] && [ "${DBMODE}" = "NOARCHIVELOG" ] ) || ( [ "${LEVEL}" = "0" ] && [ ${ONLINE_BACKUP} = 0 ] )
then

sqlplus -s "/ as sysdba" >> ${JOB_RUN_LOG_FULL_PATH} << EOF
alter database open;
exit
EOF

if [ "${MY_VAR_VALUE}" != "" ]; then
echo "Starting database with Oracle Wallet key loaded..."
echo "Starting database with Oracle Wallet key loaded..." >> ${JOB_RUN_LOG_FULL_PATH}
sqlplus -s "/ as sysdba" >> ${JOB_RUN_LOG_FULL_PATH} << EOF
 alter system set wallet open identified by "${MY_VAR_VALUE}";
 exit
EOF
fi

fi

#
genRecoveryScript
deleteOldBackup
backupReports

else

#
echo " "
echo "Skipped!"
echo "Incremental RMAN is not applicable to NOARCHIVELOG mode database."
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo "Skipped!" >> ${JOB_RUN_LOG_FULL_PATH}
echo "Incremental RMAN is not applicable to NOARCHIVELOG mode database." >> ${JOB_RUN_LOG_FULL_PATH}

fi

#
. $HOME/eas-dba/subProgSizeAllMountPoints.sh

#
echo " " >> ${JOB_RUN_LOG_FULL_PATH}
echo " "
echo "${DB} Backup Process Completed: `date`"
echo "${DB} Backup Process Completed: `date`" >> ${JOB_RUN_LOG_FULL_PATH}
echo "#######################################################" >> ${JOB_RUN_LOG_FULL_PATH}

#
if [ -s ${JOB_ERROR_LOG_FULL_PATH} ]; then
  BACKUP_SUCCESS_IND=0
  DB_BACKUP_NOTES="See processing ${DB_ERROR_LOG_NAME} for more details."
  RUN_LOG_FILENAME="${JOB_ERROR_LOG_NAME}"
  RUN_LOG_ERROR_DETAILS=`${CAT} ${JOB_ERROR_LOG_FULL_PATH} | tr '\012' ' '`
  . $HOME/eas-dba/subProgInsertRunLog.sh
  
  SERVER_ERROR_TYPE="Oracle RMAN Backup Log"
  SERVER_ERROR_DETAILS=${RUN_LOG_ERROR_DETAILS}
  DATABASE_NAME=${DB}
  LISTENER_NAME=""
  . $HOME/eas-dba/subProgInsertErrorLog.sh
  
else
  BACKUP_SUCCESS_IND=1
fi

else

  echo ""
  echo "Aborting!"
  echo "Possible Reasons:"
  echo " - [${DB}] is not a valid database instance on this server."
  echo " - This script is for Oracle9i and above above only."
  echo ""
  echo "Aborting!" >> ${JOB_RUN_LOG_FULL_PATH}
  echo "Possible Reasons:" >> ${JOB_RUN_LOG_FULL_PATH}
  echo " - [${DB}] is not a valid database instance on this server." >> ${JOB_RUN_LOG_FULL_PATH}
  echo " - This script is for Oracle9i and above above only." >> ${JOB_RUN_LOG_FULL_PATH}

fi

#
. $HOME/eas-dba/subProgUpdateBackupJob.sh

. $HOME/eas-dba/subProgUploadLogFile.sh

#
if [ ${EMAIL_LOG_BACKUP_RMAN} = 1 ];then
. $HOME/eas-dba/subProgEmailLogBackupJob.sh
fi

#
if [ -s ${JOB_ERROR_LOG_FULL_PATH} ]; then
        ${CAT} /dev/null > ${JOB_ERROR_LOG_FULL_PATH}
fi

else

echo ""
echo "NOTHING DONE! The target database instance ${ORACLE_SID} is unknown or not currently running normally (i.e. not open in read/write mode)."
echo ""
echo "" >> ${JOB_RUN_LOG_FULL_PATH}
echo "NOTHING DONE! The target database instance ${ORACLE_SID} is unknown or not currently running normally (i.e. not open in read/write mode)." >> ${JOB_RUN_LOG_FULL_PATH}
echo "" >> ${JOB_RUN_LOG_FULL_PATH}

fi

}

###################
# Main Program
###################

#
if [ "$1" != "" ] && [ "$1" != "force" ] 
then
DB=$1
processRMAN
elif [ "$1" != "" ] && [ "$1" = "force" ] && [ "$2" != "" ] 
then
DB=$2
processRMAN
else
#
dbLogFile=`${MKTEMP}`_23
${GREP} DBRmanBackup  $HOME/eas-dba/config_${HOST}.ini > ${dbLogFile}
${CAT} ${dbLogFile} | while read DBLine
do
firstChar=`echo "${DBLine}" | ${AWK} '{print substr($1,1,1)}'` # get the 1st char
if [ "$firstChar" != "#" ]
then
DB=`echo "${DBLine}" | ${AWK} -F= '{print $2}'`
processRMAN
#
fi
done

if [ -f ${dbLogFile} ]; then
        ${RM} ${dbLogFile}
fi
fi

# end script
#
