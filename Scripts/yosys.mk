BOARD=none
PROJECT=none
PROJECTDIR=../..
BOARDDIR=../../../Board/$(BOARD)
MANIFEST=$(PROJECTDIR)/manifest.rtl
SIM=$(PROJECTDIR)/sim_files.rtl
SCRIPTSDIR=../../../Scripts

include $(BOARDDIR)/board.mk

TARGET=$(PROJECT).json
SVFFILE=$(PROJECT).svf
BITFILE=$(PROJECT).bit
CFGFILE=$(PROJECT).config

ALL: init compile

init: $(TARGET)

compile: $(BITFILE)

config: $(SVFFILE)
	openocd -f $(BOARDDIR)/target.cfg -c \
	"init; scan_chain; \
	    svf -tap target.tap -quiet -progress ${SVFFILE}; \
	    exit;"

clean:
	-rm $(TARGET)
	-rm $(PROJECT)_$(BOARD)_files.tcl
	-rm $(BITIFLE)

$(PROJECT)_$(BOARD)_files.tcl: $(MANIFEST)
	$(SCRIPTSDIR)/expandtemplate_yosys.sh $+ $(PROJECTDIR) >$@
	$(SCRIPTSDIR)/expandtemplate_yosys.sh $(BOARDDIR)/board.files $(BOARDDIR) >>$@

$(TARGET): $(MANIFEST) $(PROJECT)_$(BOARD)_files.tcl

$(CFGFILE): $(TARGET) $(PROJECT)_$(BOARD)_files.tcl $(BOARDDIR)/$(BOARD).lpf
	$(TOOLPATH)yosys -mghdl -p 'tcl $(SCRIPTSDIR)/mkproject_yosys.tcl $(PROJECT) $(BOARD)' || echo "yosys not found - skipping compilation."
	$(TOOLPATH)nextpnr-ecp5 $(DEVICE) --package $(DEVICE_PACKAGE) --speed $(DEVICE_SPEED) --json $< --textcfg $@ --lpf $(BOARDDIR)/$(BOARD).lpf --timing-allow-fail

$(BITFILE): $(CFGFILE)
	$(TOOLPATH)ecppack $(ECPPACKOPTS) --svf $(SVFFILE) --input $< --bit $@ 

$(SVFFILE): $(BITFILE)

