PRJ=JPEGTest
PRJ_OBJ = main.o junixio.o jpeg-6b/libjpeg.a
COPT = -unsigned-char -O=-1 -speed -Ijpeg-6b

include ../app.mk

jpeg-6b/libjpeg.a:
	make -C jpeg-6b libjpeg.a

