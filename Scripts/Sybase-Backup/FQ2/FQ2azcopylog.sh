#!/bin/bash
azcopy sync /backup/trans_log "https://sapstordbbackupcusqa.blob.core.windows.net/fq2/backup-newlog?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2029-08-11T18:14:08Z&st=2021-08-11T10:14:08Z&spr=https&sig=dOVQHL7d%2BfNE8GNg%2BAbkV3kec2cbTtGylOaO1LW8Jt0%3D" --recursive=true --cap-mbps 700


#Local backup retention will be for 10080 mins. (7days).
RETENTION="+10080"
cd /backup/trans_log/ && find /backup/trans_log/  -name "*"  -mmin ${RETENTION} -type f -exec rm -rf -v {} \;
