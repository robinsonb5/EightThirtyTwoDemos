APPS_TEXT = HelloWorld Dhrystone Dhrystone_Dual Malloc PS2Keyboard Filesystem AppHost UBasic Interrupts
APPS_GRAPHICS = Conway RandTest VGA Terminal BlitFunc Terminal
APPS_SOUND = Modplayer WAVPlayer
APPS_32BIT = RandTest32 TrueColour SpriteTest IndexedTest

APPS = $(APPS_TEXT) $(APPS_GRAPHICS) $(APPS_SOUND) $(APPS_32BIT)

all:
	for APP in ${APPS}; do \
		make -C $$APP; \
	done;

clean:
	for APP in ${APPS}; do \
		make -C $$APP clean; \
	done;

