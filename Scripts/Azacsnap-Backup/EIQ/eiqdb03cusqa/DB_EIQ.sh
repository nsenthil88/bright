ScriptLog="/hana/backup/azsync-DB_EIQ.log"
azcopy sync /hana/backup/EHQ/log/DB_EIQ* "https://sapstordbbackupcusqa.blob.core.windows.net/eiq/log/DB_EIQ/?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacupitfx&se=2023-10-29T16:38:23Z&st=2021-10-29T08:38:23Z&spr=https&sig=sLz3hIbagZGGDw8Yn%2FBWT7XnGfbkfv7w36I8BjfLKSc%3D" --recursive=true --put-md5 --cap-mbps 4000 > $ScriptLog
echo "Script Executed on below date" >> $ScriptLog
date=$(date)
echo "$date" >> $ScriptLog
