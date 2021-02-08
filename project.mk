PROJECT = none

include site.mk

all: firmware boards

firmware: EightThirtyTwo/vbcc/bin/vbcc832
	make -C $(PROJECT)/Firmware/

boards:
	for BOARD in ${BOARDS_SPARTAN6}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../ise.mk BOARD=$$BOARD PROJECT=$(PROJECT) ISE=$(ISE_SPARTAN6); \
	done
#	for BOARD in ${BOARDS_ARTIX7}; do \
#		mkdir -p $$PROJECT/fpga/$$BOARD; \
#		make -C $$PROJECT/fpga/$$BOARD -f ../../../vivado.mk BOARD=$$BOARD PROJECT=$(PROJECT) VIVADO=$(VIVADO_ARTIX7); \
#	done
	for BOARD in ${BOARDS_CYCLONEII}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEII); \
	done
	for BOARD in ${BOARDS_CYCLONEIII}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEIII); \
	done
	for BOARD in ${BOARDS_CYCLONE10LP}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONE10LP); \
	done
	for BOARD in ${BOARDS_MAX10}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_MAX10); \
	done
	for BOARD in ${BOARDS_CYCLONEIV}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEIV); \
	done
	for BOARD in ${BOARDS_CYCLONEV}; do \
		mkdir -p $$PROJECT/fpga/$$BOARD; \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEV); \
	done

clean:
	for BOARD in ${BOARDS_CYCLONEII}; do \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEII) clean; \
	done
	for BOARD in ${BOARDS_CYCLONEIII}; do \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEIII) clean; \
	done
	for BOARD in ${BOARDS_CYCLONE10LP}; do \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONE10LP) clean; \
	done
	for BOARD in ${BOARDS_MAX10}; do \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_MAX10) clean; \
	done
	for BOARD in ${BOARDS_CYCLONEV}; do \
		make -C $$PROJECT/fpga/$$BOARD -f ../../../quartus.mkk BOARD=$$BOARD PROJECT=$(PROJECT) QUARTUS=$(QUARTUS_CYCLONEV) clean; \
	done

