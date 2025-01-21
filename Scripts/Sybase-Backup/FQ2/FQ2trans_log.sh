#/usr/ksh!
passwd=BHFazure123#
#su - sybfq2 -c 
isql_r64 -Usapsa -PBHFazure123# -SFQ2 -X << EOF
declare @dumpname00 varchar(100)
select @dumpname00 = '/backup/trans_log/FQ2_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump transaction FQ2 to @dumpname00 with compression = '101'
go
declare @dumpname01 varchar(100)
select @dumpname01 = '/backup/trans_log/FQ2_saptools_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump transaction saptools to @dumpname01 with compression = '101'
go
declare @dumpname02 varchar(100)
select @dumpname02 = '/backup/trans_log/FQ2_sybmgmtdb_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump transaction sybmgmtdb to @dumpname02 with compression = '101'
go
declare @dumpname03 varchar(100)
select @dumpname03 = '/backup/trans_log/FQ2_sybsecurity_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump transaction sybsecurity to @dumpname03 with compression = '101'
go
EOF
DATE=$(date)
log=FQ2_LOG
File=/backup/FQ2translog.txt
count=$(grep 'DUMP is complete' "$File" | wc -l)
if [ $count = "4" ]; then
echo "All four $log was successful on $DATE" >> $File
else
echo "$log was failed. Check the logs and retrigger the backup for failed  logs" >> $File
fi
