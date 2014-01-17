#!/bin/bash
# notify users when a new mobile device is registered on their account

LOCKFILE=$(mktemp).lock
[ -f ${LOCKFILE} ] && logger "mobile-check already running..." && echo "Already running..." && exit 1
touch "${LOCKFILE}"

IF=/opt/zimbra/log/sync.log
TF=$(mktemp)
BASEDIR=$(dirname $0)
DBDIR=${BASEDIR}/db
LOG=${BASEDIR}/log
FROM="admin@zimbra.gr"
BCC="-b takis@zimbra.gr,sakis@zimbra.gr"

rm -f ${TF}
mkdir -p ${DBDIR}

/usr/sbin/logtail ${IF} | egrep -o "on account.*from device.*" | awk '{print $3,$6}' | sort -u > ${TF}
while read -r line ; do
	USERNAME=$(echo ${line} | awk '{print $1}')
	DEVICEID=$(echo ${line} | awk '{print $2}')
	if [ -s ${DBDIR}/${USERNAME} ]; then
		grep -q ${DEVICEID} ${DBDIR}/${USERNAME}
		RES=$?
		if [ "${RES}x" != "0x" ]; then
			echo "$(date) First login from ${DEVICEID}, adding to device database for ${USERNAME}" >> ${LOG}
			echo "You registered a new mobile device in Zimbra (${DEVICEID})." | mail -r ${FROM} ${BCC} -s "New mobile device registered in Zimbra for ${USERNAME}" ${USERNAME}
			echo ${DEVICEID} >> ${DBDIR}/${USERNAME}
		fi
	else
		echo "$(date) First login from ${DEVICEID}, creating new device database for ${USERNAME}" >> ${LOG}
		echo "You registered a new mobile device in Zimbra (${DEVICEID})." | mail -r ${FROM} ${BCC} -s "New mobile device registered in Zimbra for ${USERNAME}" ${USERNAME}
		echo ${DEVICEID} >> ${DBDIR}/${USERNAME}
	fi
done < ${TF}

rm -f ${TF} ${LOCKFILE}
exit 0
