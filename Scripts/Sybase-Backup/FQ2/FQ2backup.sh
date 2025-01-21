#/usr/ksh!
date
#su - sybfq2 -c
isql_r64 -Usapsa -SFQ2 -PBHFazure123# -X << 'EOF'
declare @dumpname01 varchar(100)
select @dumpname01 = '/backup/data/FQ2/FQ2_1_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
declare @dumpname02 varchar(100)
select @dumpname02 = '/backup/data/FQ2/FQ2_2_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
declare @dumpname03 varchar(100)
select @dumpname03 = '/backup/data/FQ2/FQ2_3_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database FQ2 to @dumpname01 stripe on @dumpname02 stripe on @dumpname03 with compression = '101'
go
declare @dumpname04 varchar(100)
select @dumpname04 = '/backup/data/master_bckup/master_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database master to @dumpname04
go
declare @dumpname05 varchar(100)
select @dumpname05 = '/backup/data/saptools_backup/saptools_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database saptools to @dumpname05
go
declare @dumpname06 varchar(100)
select @dumpname06 = '/backup/data/sybsystemprocs_bckup/sybsystemprocs_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybsystemprocs to @dumpname06
go
declare @dumpname07 varchar(100)
select @dumpname07 = '/backup/data/sybmgmtdb_bckup/sybmgmtdb_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybmgmtdb to @dumpname07
go
declare @dumpname08 varchar(100)
select @dumpname08 = '/backup/data/model_bckup/model_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database model to @dumpname08
go
declare @dumpname09 varchar(100)
select @dumpname09 = '/backup/data/sybsecurity_bckup/sybsecurity_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybsecurity to @dumpname09
go
declare @dumpname10 varchar(100)
select @dumpname10 = '/backup/data/sybsystemdb_bckup/sybsystemdb_bckup_' || str_replace(convert(varchar, getdate(), 112) || '_' || convert(varchar, getdate(), 108), ':', null) || '.dmp'
dump database sybsystemdb to @dumpname10
go
EOF
DATE=$(date)
log=FQ2_DATABASE
File=/backup/FQ2databaselog.txt
count=$(grep 'DUMP is complete' "$File" | wc -l)
if [ $count = "8" ] ; then
echo "All four $log was successful" >> $File
else
echo "$log was failed. Check the logs and retrigger the backup for failed  datbases" >> $File
fi


