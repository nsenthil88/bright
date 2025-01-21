#!/bin/bash
isql -Usa -PBHFazure123# -SBIQ  -X --retserverror << EOF
use master
go
declare @dumpname01 varchar(100)
select @dumpname01 = '/backup/data/BIQ/BIQ_1_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
declare @dumpname02 varchar(100)
select @dumpname02 = '/backup/data/BIQ/BIQ_2_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
declare @dumpname03 varchar(100)
select @dumpname03 = '/backup/data/BIQ/BIQ_3_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database BIQCMS to @dumpname01 stripe on @dumpname02 stripe on @dumpname03 with compression = '101'
go
declare @dumpname04 varchar(100)
select @dumpname04 = '/backup/data/BIQAudit/BIQAudit_1_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
declare @dumpname05 varchar(100)
select @dumpname05 = '/backup/data/BIQAudit/BIQAudit_2_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
declare @dumpname06 varchar(100)
select @dumpname06 = '/backup/data/BIQAudit/BIQAudit_3_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database BIQAudit to @dumpname04 stripe on @dumpname05 stripe on @dumpname06 with compression = '101'
go
declare @dumpname07 varchar(100)
select @dumpname07 = '/backup/data/master_bckup/master_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database master to @dumpname07
go
declare @dumpname08 varchar(100)
select @dumpname08 = '/backup/data/saptools_backup/saptools_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database saptools to @dumpname08
go
declare @dumpname09 varchar(100)
select @dumpname09 = '/backup/data/sybsystemprocs_bckup/sybsystemprocs_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybsystemprocs to @dumpname09
go
declare @dumpname10 varchar(100)
select @dumpname10 = '/backup/data/sybmgmtdb_bckup/sybmgmtdb_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybmgmtdb to @dumpname10
go
declare @dumpname11 varchar(100)
select @dumpname11 = '/backup/data/model_bckup/model_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database model to @dumpname11
go
declare @dumpname12 varchar(100)
select @dumpname12 = '/backup/data/sybsecurity_bckup/sybsecurity_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybsecurity to @dumpname12
go
declare @dumpname13 varchar(100)
select @dumpname13 = '/backup/data/sybsystemdb_bckup/sybsystemdb_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybsystemdb to @dumpname13
go
EOF
date=$(date)
log=BIQ_DATABASE
File=/backup/BIQdatabaselog.txt
count=$(grep 'DUMP is complete' "$File" | wc -l)
if [ $count = "9" ] ; then
echo "All Nine  $log was successful" on $date>> $File
else
echo "$log was failed on $date. Check the logs and retrigger the backup for failed  datbases" >> $File
fi
