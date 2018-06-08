#!/bin/bash
############# CONFIG ##############
MDARR=/dev/md0
MAIL_TO="admin@example.com"
####################################

HOSTNAME=`hostname`
MAIL_FROM="raid@${HOSTNAME}.admin"
HOSTNAME_UPCASE=`hostname|awk '{print toupper($0)}'`
MAIL_SUBJ="${HOSTNAME_UPCASE}: RAID DEGRADED!"
MAIL_MSG="<html><head><title>RAID MONITORING</title></head><body><p style=\"color:red; font-size: 2em\">There is a problem with RAID array ${MDARR}</p></body></html>"
STATE=`mdadm -D $MDARR | grep "State :"|awk '{$1=$1};1'`

if [[ "$STATE" == *"degraded"* ]]; then
    echo "RAID array $MDARR is degraded!";

    (
    echo "From: ${MAIL_FROM}";
    echo "To: ${MAIL_TO}";
    echo "Subject: ${MAIL_SUBJ}";
    echo "Content-Type: text/html";
    echo "MIME-Version: 1.0";
    echo "";
    echo "${MAIL_MSG}";
    ) | sendmail -t
else
    echo "RAID array $MDARR is OK";
fi

exit 0

