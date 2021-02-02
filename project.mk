PROJECT = none

Q13 = $(HOME)/altera/13.0sp1/quartus/bin/
Q18 = $(HOME)/intelFPGA_lite/18.1/quartus/bin/

QUARTUS_CYCLONEIII = $(Q13)
QUARTUS_CYCLONEV = $(Q18)
QUARTUS_CYCLONE10LP = $(Q18)
QUARTUS_MAX10 = $(Q18)

BOARDS_CYCLONEIII = chameleon64 mist
BOARDS_CYCLONE10LP = chameleon64v2
BOARDS_CYCLONEV = 
BOARDS_MAX10 = de10lite deca

all: firmware boards

EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd:
	git submodule init
	git submodule update

EightThirtyTwo/vbcc/bin/vbcc832: EightThirtyTwo/RTL/eightthirtytwo_cpu.vhd
	make -C EightThirtyTwo

firmware: EightThirtyTwo/vbcc/bin/vbcc832
	make -C $(PROJECT)/Firmware/

boards:
	for BOARD in ${BOARDS_MAX10}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_MAX10); \
	done
	for BOARD in ${BOARDS_CYCLONE10LP}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONE10LP); \
	done
	for BOARD in ${BOARDS_CYCLONEIII}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEIII); \
	done
	for BOARD in ${BOARDS_CYCLONEV}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEV); \
	done

clean:
	for BOARD in ${BOARDS_MAX10}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_MAX10) clean; \
	done
	for BOARD in ${BOARDS_CYCLONE10LP}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONE10LP) clean; \
	done
	for BOARD in ${BOARDS_CYCLONEIII}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEIII) clean; \
	done
	for BOARD in ${BOARDS_CYCLONEV}; do \
		make -f project_board.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEV) clean; \
	done

