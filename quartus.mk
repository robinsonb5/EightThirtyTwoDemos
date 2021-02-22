SCRIPTSDIR=../../../Scripts

SOF=$(PROJECT)_$(BOARD).sof
QSF=$(PROJECT)_$(BOARD).qsf

all: init compile

init: $(QSF)

compile: $(SOF)

$(PROJECT)_$(BOARD)_files.tcl: ../../manifest.rtl
	bash $(SCRIPTSDIR)/expandtemplate_quartus.sh $+ >$@

%.qsf: $(PROJECT)_$(BOARD)_files.tcl
	$(TOOLPATH)/quartus_sh -t ../../../tcl/mkproject.tcl -project $(PROJECT) -board $(BOARD)

%.sof: %.qsf
	$(TOOLPATH)/quartus_sh -t ../../../tcl/compile.tcl -project $(PROJECT) -board $(BOARD)

clean:
	-rm $(SOF)
	-rm $(QSF)


