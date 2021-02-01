FREQ=100

all: $(PROJECT)_$(BOARD).qsf $(PROJECT)_$(BOARD).sof

%.qsf: ../../project_files.tcl
	$(QUARTUS)/quartus_sh -t ../../../tcl/mkproject.tcl -project $(PROJECT) -board $(BOARD) -frequency $(FREQ)

%.sof: %.qsf
	$(QUARTUS)/quartus_sh -t ../../../tcl/compile.tcl -project $(PROJECT) -board $(BOARD)

