
LIRC_DEVICE = /dev/lirc0
LIRC_DUMP   = dump.log
LIRCD_CONF  = /etc/lirc/lircd.conf

PHP_SCRIPT  = /var/www/html/lirc.php

GIT_DAEMON_CMD = git daemon --export-all --enable=receive-pack

.PHONY: update apply record send

update:
	git pull

$(LIRCD_CONF): lircd.conf
	sudo cp -p $< $@

apply: update $(LIRCD_CONF) $(PHP_SCRIPT)
	sudo service lirc restart

record-raw:
	sudo service lirc stop
	mode2 -d $(LIRC_DEVICE) | tee $(LIRC_DUMP)
	sudo service lirc start

record:
	sudo service lirc stop
	irrecord -n -d $(LIRC_DEVICE) dump.conf
	sudo service lirc start

send:
	irsend SEND_ONCE ${ARG}

# start temporary git server
server:
	pgrep -q -f "git daemon" || $(GIT_DAEMON_CMD) $(PWD) >/dev/null &

$(PHP_SCRIPT) : lirc.php
	sudo cp -p $< $@
