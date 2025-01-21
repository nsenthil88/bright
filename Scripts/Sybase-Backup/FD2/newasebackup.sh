#!/bin/bash

# Make positional parameters to variables
SID=$1
TYPE=$2

# Define variables
BACKUP_DIR="/backup/${SID}"
RC=0
LOGFILE="${BACKUP_DIR}/backup.log"
TIMESTAMP="$(date +\%F\_%H\%M)"
BACKUP_PREFIX_="${SID}_${TYPE}_BACKUP"
BACKUP_PREFIX="$BACKUP_PREFIX_"_"$TIMESTAMP"
USERNAME=sapsa
PW=BHFazure123#
TYPE_LL=${TYPE,,}
RETENTION=""
#SAS_KEY="?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2023-07-21T14:15:54Z&st=2021-07-21T06:15:54Z&spr=https&sig=6yO1UqN4ndchZs%2FdI%2FztH1BeqU8p4oTvaPaMBDidctU%3D"
SAS_KEY="?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2025-11-09T16:27:27Z&st=2021-11-09T08:27:27Z&spr=https&sig=ZnTZfwcm9uUA0FmVPpAtCttz%2B6J%2Bn8YeLGrJePBZLh8%3D"
if [ "${TYPE}" = "DATA" ]
then
RETENTION="+10080"
echo -e "[Info  ] Backup type is \"DATA\"" >> "${LOGFILE}"
echo -e "[Info   ] Starting ${SID} ${TYPE} at: `date`" >> "${LOGFILE}"
isql -Usapsa -P${PW} -S${SID}  -X --retserverror << EOF
use master
go
dump database ${SID} to "/backup/${SID}/${TYPE}/${BACKUP_PREFIX}.dmp" with compression = 101
go
EOF
RC=$?
echo "Status if the copy is ${RC}" >> "${LOGFILE}"
elif [ "${TYPE}" = "LOG" ]
then
RETENTION="+1440"
echo -e "[Info  ] Backup type is \"LOG\"" >> "${LOGFILE}"
isql -Usapsa -P${PW} -S${SID}  -X --retserverror << EOF
use master
go
dump transaction ${SID} to "/backup/${SID}/${TYPE}/${BACKUP_PREFIX}.dmp"
go
EOF
RC=$?
echo "Status if the copy is ${RC}" >> "${LOGFILE}"
else
 echo -e "`date` [Error  ]  Incorrect backup type specified. Should be \"DATA\" or \"LOG\"" >> "${LOGFILE}"
 echo "erro with type parameter, Either it should be DATA or LOG"
 end=1
 exit ${end} 
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
azcopy cp "/backup/${SID}/${TYPE}/${BACKUP_PREFIX}.dmp" "https://sapstordbbackupsuse2dv.blob.core.windows.net/fd2/${TYPE}/${SAS_KEY}"
#rm /backup/${SID}/${TYPE}/${BACKUP_PREFIX}.dmp
          cd /backup &&    find /backup/${SID}/${TYPE}/ -maxdepth 1 -name "FD2_${TYPE}_BACKUP*.dmp"  -mmin ${RETENTION} -type f -exec rm -rf -v {} \; 
		#find /backup/FD2/LOG/ -maxdepth 1 -name "FD2_LOG_BACKUP*.dmp" -mmin +60 -delete
else
echo -e "[Error  ] Backup failed  ${SID}  ${TYPE} at: `date`" >> ${LOGFILE}
exit
fi

