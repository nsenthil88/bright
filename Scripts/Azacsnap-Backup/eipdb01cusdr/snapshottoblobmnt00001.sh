ScriptLog="/hana/backup/snapshottoblobmnt00001.log"
azcopy sync '/hana/data/EHP/mnt00001/.snapshot' "https://sapstordbbackupcusqa.blob.core.windows.net/dr-eip/eip/data/mnt00001/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2035-01-24T15:33:10Z&st=2022-01-24T07:33:10Z&spr=https,http&sig=4gwtlmXyOOMT8hu3vSl0I9ll29%2B6HJkilWJxszjMCI4%3D" --recursive=true > $ScriptLog
echo "Script Executed on below date" >> $ScriptLog
date=$(date)
echo "$date" >> $ScriptLog

ScriptLog2="/hana/backup/snapshottoblobmnt00002.log"
azcopy sync '/hana/data/EHP/mnt00002/.snapshot' "https://sapstordbbackupcusqa.blob.core.windows.net/dr-eip/eip/data/mnt00002/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2035-01-24T15:33:10Z&st=2022-01-24T07:33:10Z&spr=https,http&sig=4gwtlmXyOOMT8hu3vSl0I9ll29%2B6HJkilWJxszjMCI4%3D" --recursive=true > $ScriptLog2
echo "Script Executed on below date" >> $ScriptLog2
date=$(date)
echo "$date" >> $ScriptLog2

ScriptLog3="/hana/backup/snapshottoblobmnt00003.log"
azcopy sync '/hana/data/EHP/mnt00003/.snapshot' "https://sapstordbbackupcusqa.blob.core.windows.net/dr-eip/eip/data/mnt00003/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2035-01-24T15:33:10Z&st=2022-01-24T07:33:10Z&spr=https,http&sig=4gwtlmXyOOMT8hu3vSl0I9ll29%2B6HJkilWJxszjMCI4%3D" --recursive=true > $ScriptLog
echo "Script Executed on below date" >> $ScriptLog3
date=$(date)
echo "$date" >> $ScriptLog3
