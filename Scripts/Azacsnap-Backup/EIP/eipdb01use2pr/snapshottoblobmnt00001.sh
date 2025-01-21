ScriptLog="/hana/backup/snapshottoblobmnt00001.log"
azcopy sync '/hana/data/EHP/mnt00001/.snapshot' "https://sapstordbbackupuse2pr.blob.core.windows.net/eip/data/mnt00001/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2023-12-06T01:15:36Z&st=2021-12-05T17:15:36Z&spr=https&sig=yLBdMJOCftuK4IRZCv8dfQyFVePDVvpQfb4zqNGb9Ks%3D" --recursive=true > $ScriptLog
echo "Script Executed on below date" >> $ScriptLog
date=$(date)
echo "$date" >> $ScriptLog
