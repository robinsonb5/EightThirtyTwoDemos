PROJECTS=HelloWorld Interrupts VGA SDRAM
BOARDS_ALTERA = "de1 de2"

all:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT; \
	done

clean:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT clean; \
	done

