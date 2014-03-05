asterisk-externhost
===================

Bash script to replace externhost functionality.

Why bother:

- it doesn't seem to exist in any of the official documentation.  I always expected it to
silently get removed one day.
- most importantly, there's no equivalent with the new pjsip channel in Asterisk 12. 
This script will be simple to modify to work with pjsip.conf.

How to use:

- make sure the ipupdate.sh file has execute permissions for root
- add something similar to this to root's crontab:

* * * * * /path/to/script/ipupdate.sh

with your own path in there.  That will run once a minute.

What is it for:

externhost is a setting that existed in the Asterisk chan_sip settings file sip.conf.

It takes the value:

externhost=extern.hayesey.co.uk

Every so often (configurable using another removed setting), it would do a DNS lookup for 
that host and use the result as the external IP address for NAT traversal.

It is useful for Asterisk installations behind dynamic IP addresses.  I wrote this for
my own use for my Asterisk systems at home behind my cheap & cheerful residential ADSL.

How does it work:

Designed to be run as cron job, it relies on the "host" command to do a DNS lookup for the
hostname given as the first argument.  This hostname should resolve to your external IP.
You will be using some kind of dynamic-dns service presumably.

Your sip.conf needs to be using externaddr= setting with the external IP in it.  The script
gets this IP and if it differs from the current dynamic-dns result then it is updated.

Lastly, the script forces a sip reload in Asterisk so the new setting takes effect.

It'll only do anything with sip.conf and Asterisk if the IP changes.

Have fun.

Paul Hayes - paul@polog40.co.uk

