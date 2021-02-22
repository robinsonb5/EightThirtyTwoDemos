SOF=$(PROJECT)_$(BOARD).sof
QSF=$(PROJECT)_$(BOARD).qsf

init: $(QSF)

compile: $(SOF)

$(PROJECT)_$(BOARD)_files.tcl: ../../manifest.rtl
	../../../Scripts/expandtemplate_quartus.sh $+ >$@

%.qsf: $(PROJECT)_$(BOARD)_files.tcl
	$(TOOLPATH)/quartus_sh -t ../../../tcl/mkproject.tcl -project $(PROJECT) -board $(BOARD)

%.sof: %.qsf
	$(TOOLPATH)/quartus_sh -t ../../../tcl/compile.tcl -project $(PROJECT) -board $(BOARD)

clean:
	-rm $(SOF)
	-rm $(QSF)


