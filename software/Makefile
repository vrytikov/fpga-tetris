# File: Makefile
# Author: Aaron Odell
# Company: Digilent Inc.
# Date: 8/16/2010
# Description: makefile for Adept SDK DeppDemo

CC = g++
INC = <PUT_YOUR_INC_DIR_HERE>
LIBDIR = <PUT_YOUR_LIB_DIR_HERE>
TARGETS = DeppDemo
CFLAGS = -I $(INC) -L $(LIBDIR) -ldepp -ldmgr

all: $(TARGETS)

DeppDemo: DeppDemo.cpp
	$(CC) -o DeppDemo DeppDemo.cpp $(CFLAGS)


.PHONY: vclean

vclean:
	rm -f $(TARGETS)
