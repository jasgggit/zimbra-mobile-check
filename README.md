zimbra-mobile-check
===================

notify zimbra users when a new mobile device is registered on their account
http://forums.zextras.com/zxmobile/827-notify-users-when-new-mobile-device-registered.html

Intro
=====

Somebody suggested that we should notify our Zimbra users when a new mobile
device is registered on their account, as a security warning.

We use ZeXtras for mobile sync, that produces a log under /opt/zimbra/log/sync.log.

This script parses the logfile and sends email notifications to users.
It also records on a local logfile.

Usage
=====

Copy the script on all your Zimbra mailbox server(s) and execute via crontab
every minute (or any interval you like).

    * * * * * /path/to/mobile-check.sh

Check the results in /path/to/log

    [zimbra@zm-mbox-01 mobile-check]$ cat log 
    Fri Jan 17 14:00:15 EET 2014 First login from iPad/ApplDLXFKTB0DFJ3, creating new device database for takis@zimbra.gr
    Fri Jan 17 14:00:38 EET 2014 First login from iPhone/ApplDNPLR1DGFFGD, adding to device database for takis@zimbra.gr
    Fri Jan 17 21:03:01 EET 2014 First login from Android/androidc897091636, creating new device database for sakis@zimbra.gr
    Fri Jan 17 21:05:01 EET 2014 First login from Android/361ecccca7c339ad9a644b4852be3804, adding to device database for sakis@zimbra.gr

If you want to "reset" some particular user
    rm -f /path/to/db/user@domain.com

If you want to "reset" the entire database and start from the beginning
    rm -rf /path/to/db/

Prerequisites
=============

* Zimbra with ZeXtras Mobile Sync (http://www.zextras.com/)
* logtail (RedHat: yum install logcheck | debian: apt-get install logtail)
