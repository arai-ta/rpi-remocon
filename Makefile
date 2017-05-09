
LIRC_DEVICE = /dev/lirc0
LIRC_DUMP   = dump.log
LIRCD_CONF  = /etc/lirc/lircd.conf

.PHONY: update apply record send

update:
	git pull

$(LIRCD_CONF): lircd.conf
	sudo cp -p $< $@

apply: update $(LIRCD_CONF)
	sudo service lirc restart

record:
	sudo service lirc stop
	mode2 -d $(LIRC_DEVICE) | tee $(LIRC_DUMP)
	sudo service lirc start

send:
	irsend SEND_ONCE ${ARG}

# start temporary git server
serve:
	pgrep -q -f "git daemon" || git daemon --export-all $(PWD) >/dev/null &
