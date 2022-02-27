BOARD=none
PROJECT=none
PROJECTDIR=../../
BOARDDIR=../../../Board/$(BOARD)
MANIFEST=../../manifest.rtl
SCRIPTSDIR=../../../Scripts

SOF=$(PROJECT)_$(BOARD).sof
QSF=$(PROJECT)_$(BOARD).qsf

all: init compile

init: $(QSF)

compile: $(SOF)

$(PROJECT)_$(BOARD)_files.tcl: $(PROJECTDIR)/manifest.rtl
	@bash $(SCRIPTSDIR)/expandtemplate_quartus.sh $+ >$@

%.qsf: $(PROJECT)_$(BOARD)_files.tcl
	@echo -n "Making project file for $(PROJECT) on $(BOARD)... "
	$(TOOLPATH)/quartus_sh >init.log -t $(SCRIPTSDIR)/mkproject.tcl -project $(PROJECT) -board $(BOARD) && echo "\033[32mSuccess\033[0m" || grep Error init.log

%.sof: %.qsf
	@echo -n "Compiling $(PROJECT) for $(BOARD)... "
	$(TOOLPATH)/quartus_sh >compile.log -t $(SCRIPTSDIR)/compile.tcl -project $(PROJECT) -board $(BOARD) && echo "\033[32mSuccess\033[0m" || grep Error compile.log

clean:
	-rm $(SOF)
	-rm $(QSF)


