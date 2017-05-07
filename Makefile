
LIRCD_CONF = /etc/lirc/lircd.conf

.PHONY: update

update:
	git pull

$(LIRCD_CONF): lircd.conf
	sudo $< $@

apply: update $(LIRCD_CONF)
	sudo service lirc restart

