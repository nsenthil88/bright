ScriptLog4="/hana/backup/scripts/DB_EIP_log.log"
azcopy sync '/hana/backup/EHP/log/DB_EIP/' "https://sapstordbbackupcusqa.blob.core.windows.net/dr-eip/eip/log/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2035-01-24T15:33:10Z&st=2022-01-24T07:33:10Z&spr=https,http&sig=4gwtlmXyOOMT8hu3vSl0I9ll29%2B6HJkilWJxszjMCI4%3D" --recursive=true > $ScriptLog4
echo "Script Executed on below date" >> $ScriptLog4
date=$(date)
echo "$date" >> $ScriptLog4
