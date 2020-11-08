# checkAccessLogAndSettingDrop
Check the HTTP Access Log and add the original IP that accessed the resource that does not exist a certain number of times to the Drop zone of the firewall.


# usage
perl checkAccessLogAndSettingDrop.pl accessLogFilePath count isPermanent(null or 0 or else)


# require

Whois
Firewalld


# args

## accessLogFilePath

Full Path of Http(Apache) Access Log File
If not specified, it is considered that the following is specified.
"/var/log/httpd/access_log"


## count

This script counts the number of times the HTTP return code for a connection from the same IP address is "40?".
If the number of times is "count" or more, the IP address is added to the drop zone.
If not specified, it is considered that 15 is specified.


## isPermanent

If it is neither null nor zero, it is specified as permanent.
If not specified, it is considered that "0" is specified.


# Points to note
If you run it without specifying a permanent and then run it again with a permanent, the previous settings will be deleted.
