#!/bin/bash
azcopy sync /backup/data/ "https://sapstordbbackupcusqa.blob.core.windows.net/biq/backup-new?sv=2020-08-04&ss=bfqt&srt=sco&sp=rwdlacuptfx&se=2029-08-11T18:14:08Z&st=2021-08-11T10:14:08Z&spr=https&sig=dOVQHL7d%2BfNE8GNg%2BAbkV3kec2cbTtGylOaO1LW8Jt0%3D" --recursive=true --cap-mbps 700


#Local backup retention will be for 10080 mins. (7days).
RETENTION="+10080"
cd /backup/data/ && find /backup/data/  -name "*"  -mmin ${RETENTION} -type f -exec rm -rf -v {} \;
