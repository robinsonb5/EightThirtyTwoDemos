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
DEPFILE=$(PROJECT)_$(BOARD)_deps.mk

ALL: $(DEPFILE) init compile

init: $(DEPFILE) $(TARGET)

compile: $(DEPFILE) $(BITFILE)

config: $(SVFFILE)
	openocd -f $(BOARDDIR)/target.cfg -c \
	"init; scan_chain; \
	    svf -tap target.tap -quiet -progress ${SVFFILE}; \
	    exit;"

$(DEPFILE): $(MANIFEST)
	echo >$@ -n "DEPS="
	$(SCRIPTSDIR)/expandtemplate_dep.sh $+ $(PROJECTDIR) >>$@
	$(SCRIPTSDIR)/expandtemplate_dep.sh $(BOARDDIR)/board.files $(BOARDDIR) >>$@

clean:
	-rm $(TARGET)
	-rm $(PROJECT)_$(BOARD)_files.tcl
	-rm work-obj*.cf
	-rm $(BITIFLE)

include $(PROJECT)_$(BOARD)_deps.mk

$(PROJECT)_$(BOARD)_files.tcl: $(MANIFEST)
	$(SCRIPTSDIR)/expandtemplate_yosys.sh $(BOARDDIR)/board.files $(BOARDDIR) >$@
	$(SCRIPTSDIR)/expandtemplate_yosys.sh $+ $(PROJECTDIR) >>$@

$(TARGET): $(MANIFEST) $(PROJECT)_$(BOARD)_files.tcl $(BOARDDIR)/$(BOARD).lpf $(DEPS)
	-rm $@
	$(TOOLPATH)yosys -mghdl -p 'tcl $(SCRIPTSDIR)/mkproject_yosys.tcl $(PROJECT) $(BOARD)' || echo "yosys not found - skipping compilation."

$(CFGFILE): $(TARGET) $(PROJECT)_$(BOARD)_files.tcl
	-rm $@
	$(TOOLPATH)nextpnr-ecp5 $(DEVICE) --pre-pack $(BOARDDIR)/constraints.py --package $(DEVICE_PACKAGE) --speed $(DEVICE_SPEED) --json $< --textcfg $@ --lpf $(BOARDDIR)/$(BOARD).lpf --timing-allow-fail

$(BITFILE): $(CFGFILE)
	$(TOOLPATH)ecppack $(ECPPACKOPTS) --svf $(SVFFILE) --input $< --bit $@ 

$(SVFFILE): $(BITFILE)

