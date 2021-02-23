SCRIPTSDIR=../../../Scripts

SOF=$(PROJECT)_$(BOARD).sof
QSF=$(PROJECT)_$(BOARD).qsf

all: init compile

init: $(QSF)

compile: $(SOF)

$(PROJECT)_$(BOARD)_files.tcl: ../../manifest.rtl
	@bash $(SCRIPTSDIR)/expandtemplate_quartus.sh $+ >$@

%.qsf: $(PROJECT)_$(BOARD)_files.tcl
	@echo -n "Making project file for $(PROJECT) on $(BOARD)... "
	@$(TOOLPATH)/quartus_sh >init.log -t ../../../tcl/mkproject.tcl -project $(PROJECT) -board $(BOARD) && echo "Success" || echo "FAILED"

%.sof: %.qsf
	@echo -n "Compiling $(PROJECT) for $(BOARD)... "
	@$(TOOLPATH)/quartus_sh >compile.log -t ../../../tcl/compile.tcl -project $(PROJECT) -board $(BOARD) && echo "Success" || echo "FAILED"

clean:
	-rm $(SOF)
	-rm $(QSF)


