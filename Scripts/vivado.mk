BOARD=none
PROJECT=none
PROJECTDIR=../..
BOARDDIR=../../../Board/$(BOARD)
MANIFEST=$(PROJECTDIR)/manifest.rtl
SIM=$(PROJECTDIR)/sim_files.rtl
SCRIPTSDIR=../../../Scripts

TARGET=$(PROJECT).xpr

BITFILE=$(PROJECT).bit

ALL: init compile

init: $(TARGET)

compile: $(BITFILE)

clean:
	-rm $(TARGET)
	-rm $(PROJECT)_$(BOARD)_files.tcl
	-rm $(BITIFLE)

$(PROJECT)_files.tcl: $(MANIFEST)
	echo "set files [list \\" >$@
	$(SCRIPTSDIR)/expandtemplate_vivado.sh $(BOARDDIR)/board.files $(BOARDDIR) >>$@
	$(SCRIPTSDIR)/expandtemplate_vivado.sh $+ $(PROJECTDIR) >>$@
	echo "]" >>$@

$(PROJECT)_sim_files.tcl: $(wildcard $(SIM))
	echo "set files [list \\" >$@
	$(SCRIPTSDIR)/expandtemplate_vivado.sh $+ $(PROJECTDIR) >$@
	echo "]" >>$@

$(TARGET): $(MANIFEST) $(PROJECT)_files.tcl $(PROJECT)_sim_files.tcl
	touch user.xdc
	@command -v $(TOOLPATH)/vivado && $(TOOLPATH)/vivado -mode batch -source $(SCRIPTSDIR)/mkproject_vivado.tcl -tclargs -project $(PROJECT) -board $(BOARD) || echo "vivado not found - skipping Xilinx project generation."

$(BITFILE): $(TARGET)
	@command -v $(TOOLPATH)/vivado && $(TOOLPATH)/vivado -mode batch -source $(SCRIPTSDIR)/compile_vivado.tcl -tclargs -project $(PROJECT) -board $(BOARD) || echo "Compile failed."

