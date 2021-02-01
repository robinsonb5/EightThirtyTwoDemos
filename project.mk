BOARD=none
PROJECT=none
QUARTUS=none

TARGETDIR=$(PROJECT)/fpga/$(BOARD)
SOF=$(PROJECT)_$(BOARD).sof

all: $(TARGETDIR) $(TARGETDIR)/$(SOF)

$(TARGETDIR)/$(SOF): force
	make -C $(TARGETDIR) -f ../../../quartus.mk BOARD=$(BOARD) PROJECT=$(PROJECT) QUARTUS=$(QUARTUS)

$(TARGETDIR):
	mkdir -p $(TARGETDIR)

force:

