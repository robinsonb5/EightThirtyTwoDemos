APPS = HelloWorld Dhrystone Dhrystone_Dual Malloc PS2Keyboard Filesystem Modplay Conway AppHost UBasic RandTest VGA TrueColour

all:
	for APP in ${APPS}; do \
		make -C $$APP; \
	done;

clean:
	for APP in ${APPS}; do \
		make -C $$APP clean; \
	done;

