BOARD=none
PROJECT=none
PROJECTDIR=../..
BOARDDIR=../../../Board/$(BOARD)
MANIFEST=$(PROJECTDIR)/manifest.rtl
SIM=$(PROJECTDIR)/sim_files.rtl
SCRIPTSDIR=../../../Scripts

TARGET=$(PROJECT).gprj

BITFILE=$(PROJECT).fs

ALL: init compile

init: $(TARGET)

compile: $(BITFILE)

clean:
	-rm $(TARGET)
	-rm $(PROJECT)_$(BOARD)_files.tcl
	-rm $(BITIFLE)

$(PROJECT)_files.tcl: $(MANIFEST)
	$(SCRIPTSDIR)/expandtemplate_gowin.sh $(BOARDDIR)/board.files $(BOARDDIR) >>$@
	$(SCRIPTSDIR)/expandtemplate_gowin.sh $+ $(PROJECTDIR) >>$@

$(PROJECT)_sim_files.tcl: $(wildcard $(SIM))
	$(SCRIPTSDIR)/expandtemplate_gowin.sh $+ $(PROJECTDIR) >$@

$(TARGET): $(MANIFEST) $(PROJECT)_files.tcl $(PROJECT)_sim_files.tcl
	echo $(TOOLPATH)
	echo $(SCRIPTSDIR)
	echo $(PROJECT)
	echo $(BOARD)
	@command -v $(TOOLPATH)/gw_sh && $(TOOLPATH)/gw_sh $(SCRIPTSDIR)/mkproject_gowin.tcl $(PROJECT) $(BOARD) || echo "Gowin software not found - skipping project generation."

$(BITFILE): $(TARGET)
	@command -v $(TOOLPATH)/gw_sh && $(TOOLPATH)/gw_sh -source $(SCRIPTSDIR)/compile_gowin.tcl $(PROJECT) $(BOARD) || echo "Compile failed."

