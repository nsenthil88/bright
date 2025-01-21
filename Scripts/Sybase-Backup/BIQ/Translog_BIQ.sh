#!/bin/bash
isql -Usa -PBHFazure123# -SBIQ  -X --retserverror << EOF
use master
go
declare @dumpname00 varchar(100)
select @dumpname00 = '/backup/trans_log/BIQlog/BIQ_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump transaction BIQCMS to @dumpname00 with compression = '101'
go
declare @dumpname01 varchar(100)
select @dumpname01 = '/backup/trans_log/BIQAuditlog/BIQAudit_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump transaction BIQAudit to @dumpname01 with compression = '101'
go
EOF
date=$(date)
log=BIQ_TRANSLOG
File=/backup/BIQTranslog.txt
count=$(grep 'DUMP is complete' "$File" | wc -l)
if [ $count = "2" ] ; then
echo "All two $log was successful" on $date >> $File
else
echo "$log was failed on $date. Check the logs and retrigger the backup for failed trans log" >> $File
fi
