TARGETS=1-viznut 2-tejeez 4-visy 5-tejeez 6-visy 7-tejeez \
	8-visy 9-viznut a-pyryp b-red- c-miiro \
	d-viznut-xpansive-varjohukka e-skurk-raer \
	f-xpansive-lost-in-space 4channel

all:
	for x in $(TARGETS); do \
		make -f sub.mk PRJ=$$x ; \
	done

clean:
	-rm *.o
	-rm *.srec
	-rm *.map
	-rm *.bin
	-rm *.asm

