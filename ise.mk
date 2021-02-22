BOARD=none
PROJECT=none
BOARDDIR=../../../Board/$(BOARD)
MANIFEST=../../manifest.rtl
SCRIPTSDIR=../../../Scripts
TCLDIR=../../../tcl/

TARGET=$(PROJECT)_$(BOARD)

ALL: init compile

init: $(TARGET).xise

compile: Working/$(TARGET).bit

clean:
	-rm $(TARGET).xise
	-rm $(PROJECT)_$(BOARD)_files.tcl
	-rm Working/$(TARGET).bit

$(PROJECT)_$(BOARD)_files.tcl: $(MANIFEST)
	$(SCRIPTSDIR)/expandtemplate_ise.sh $+ ../.. >$@

$(TARGET).xise: $(MANIFEST) $(PROJECT)_$(BOARD)_files.tcl $(BOARDDIR)/template.xise
	mkdir -p Working
	cp $(BOARDDIR)/template.xise $(TARGET).xise
	command -v $(TOOLPATH)/xtclsh && $(TOOLPATH)/xtclsh $(TCLDIR)/mkproject_ise.tcl -project $(PROJECT) -board $(BOARD) || echo "xtclsh not found - skipping Xilinx project generation."

Working/$(TARGET).bit: $(TARGET).xise

