PROJECTS=HelloWorld Interrupts LZ4 VGA SoC
BOARDS_ALTERA = "de1 de2"
BOARDS_XILINX = "minimig"

all:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT BOARDS_ALTERA=$(BOARDS_ALTERA) BOARDS_XILINX=$(BOARDS_XILINX); \
	done

clean:
	for PROJECT in ${PROJECTS}; do \
		make -C $$PROJECT -f ../Scripts/standard.mak PROJECT=$$PROJECT clean; \
	done

