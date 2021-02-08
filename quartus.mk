
SOF=$(PROJECT)_$(BOARD).sof
QSF=$(PROJECT)_$(BOARD).qsf

all: $(QSF) $(SOF)

$(PROJECT)_$(BOARD)_files.tcl: ../../manifest.rtl
	../../../Scripts/expandtemplate_quartus.sh $+ >$@

%.qsf: $(PROJECT)_$(BOARD)_files.tcl
	$(QUARTUS)/quartus_sh -t ../../../tcl/mkproject.tcl -project $(PROJECT) -board $(BOARD)

%.sof: %.qsf
	$(QUARTUS)/quartus_sh -t ../../../tcl/compile.tcl -project $(PROJECT) -board $(BOARD)

