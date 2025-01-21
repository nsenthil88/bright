#!/bin/bash

# Make positional parameters to variables
SID=BID
Databasename1=$1
TYPE=$2

# Define variables
BACKUP_DIR="/backup/${SID}"
RC=0
LOGFILE="${BACKUP_DIR}/backup.log"
TIMESTAMP="$(date +\%F\_%H\%M)"
BACKUP_PREFIX_="BID_${TYPE}_BACKUP"
BACKUP_PREFIX="$BACKUP_PREFIX_"_"$TIMESTAMP"
USERNAME=sa
PW=BHFazure123#
TYPE_LL=${TYPE,,}
RETENTION=""
#SAS_KEY="?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2029-08-22T18:58:50Z&st=2021-08-22T10:58:50Z&spr=https&sig=DQBvmvMvByqkWqirOc9j0ASfWPKkOnwJErwfiOIDxeo%3D"

SAS_KEY="?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2025-11-09T16:27:27Z&st=2021-11-09T08:27:27Z&spr=https&sig=ZnTZfwcm9uUA0FmVPpAtCttz%2B6J%2Bn8YeLGrJePBZLh8%3D"
if [ "${Databasename1}" = "AUDIT" ] 
 then
     echo "running for AUDIT" >> "${LOGFILE}"
      
if [ "${TYPE}" = "DATA" ] 
 then
     echo "running for DATA" >> "${LOGFILE}"
       RETENTION="+10080"
     echo -e "[Info  ] Backup type is \"DATA\"" >> "${LOGFILE}"
     echo -e "[Info   ] Starting ${SID} ${TYPE} at: `date`" >> "${LOGFILE}"
isql -Usa -P${PW} -S${SID}  -X --retserverror << EOF
use master
go
dump database BIDAudit to "/backup/BID/DATA/BIDAUDIT/${BACKUP_PREFIX}.dmp" with compression=101
go
EOF
     RC=$?
     echo "Status if the copy is ${RC}" >> "${LOGFILE}"
 
elif [ "${TYPE}" = "LOG" ] 
 then
     echo "running for LOG" >> "${LOGFILE}"
       RETENTION="+1440"
     echo -e "[Info  ] Backup type is \"LOG\"" >> "${LOGFILE}"
isql -Usa -P${PW} -S${SID}  -X --retserverror << EOF
use master
go
dump transaction BIDAudit to "/backup/BID/LOG/BIDAUDIT/${BACKUP_PREFIX}.dmp" with compression=101
go
EOF
     RC=$?
     echo "Status if the copy is ${RC}" >> "${LOGFILE}"
else
     echo -e "`date` [Error  ]  Incorrect backup type specified. Should be \"DATA\" or \"LOG\"" >> "${LOGFILE}"
     echo "error with type parameter, Either it should be DATA or LOG"
     end=1
     exit ${end}
fi

else 
echo "DATABASENAME not mentioned  ${Databasename1}" >> "${LOGFILE}"
fi
###############################
if [ "${Databasename1}" = "CMS" ] ;then 
     echo "running for CMS" >> "${LOGFILE}"


if [ "${TYPE}" = "DATA" ] ; then 
     echo "running for DATA" >> "${LOGFILE}"
RETENTION="+10080"
echo -e "[Info  ] Backup type is \"DATA\"" >> "${LOGFILE}"
echo -e "[Info   ] Starting ${SID} ${TYPE} at: `date`" >> "${LOGFILE}"
isql -Usa -P${PW} -S${SID}  -X --retserverror << EOF
use master
go
dump database BIDCMS to "/backup/BID/DATA/BIDCMS/${BACKUP_PREFIX}.dmp" with compression=101
go
EOF
RC=$?
echo "Status if the copy is ${RC}" >> "${LOGFILE}"
elif [ "${TYPE}" = "LOG" ] ;then
     echo "running for LOG" >> "${LOGFILE}"
RETENTION="+1440"
echo -e "[Info  ] Backup type is \"LOG\"" >> "${LOGFILE}"
isql -Usa -P${PW} -S${SID}  -X --retserverror << EOF
use master
go
dump transaction BIDCMS to "/backup/BID/LOG/BIDCMS/${BACKUP_PREFIX}.dmp" with compression=101
go
EOF
RC=$?
echo "Status if the copy is ${RC}" >> "${LOGFILE}"
else
 echo -e "`date` [Error  ]  Incorrect backup type specified. Should be \"DATA\" or \"LOG\"" >> "${LOGFILE}"
 echo "error with type parameter, Either it should be DATA or LOG"
 end=1
 exit ${end}
fi
else
echo "DATABASENAME not mentioned  ${Databasename1}" >> "${LOGFILE}"
fi
# Flush start log
echo -e "\n\n[Info   ] Starting ${SID}  ${TYPE} at: `date`" >> "${LOGFILE}"
[ $? -gt 0 ] && echo -e "[Warning] Unable to write to logfile ${LOGFILE}" >> "${LOGFILE}"

# Validate whether parameters has been located
if [ $# -ne 2 ]
then
echo -e "[Error  ] Missing or too much parameters are located"
exit
fi

if [ $RC -eq 0 ]
then
echo -e "[Info   ] Backup has been completed successfully ${SID}  ${TYPE} at: `date`" >> ${LOGFILE}
azcopy cp "/backup/BID/${TYPE}/BID${Databasename1}/${BACKUP_PREFIX}.dmp" "https://sapstordbbackupsuse2dv.blob.core.windows.net/bid/${TYPE}/${Databasename1}/${SAS_KEY}"
#rm /backup/${SID}/${TYPE}/${BACKUP_PREFIX}.dmp
     cd /backup && find /backup/BID/${TYPE}/BID${Databasename1}/ -maxdepth 1 -name "BID_${TYPE}_BACKUP*.dmp"  -mmin ${RETENTION} -type f -exec rm -rf -v {} \;
     #find /backup/BID/LOG/ -maxdepth 1 -name "FD2_LOG_BACKUP*.dmp" -mmin +60 -delete
else
echo -e "[Error  ] Backup failed  ${SID}  ${TYPE} at: `date`" >> ${LOGFILE}
exit
fi
