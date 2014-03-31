clean: mrproper clean-project-files

clean-project-files:
	-rm -f tetris.gise tetris.xise Makefile

load: local
	djtgcfg -d Basys2 prog -i 0 -f tetris_top.bit

just-load:
	djtgcfg -d Basys2 prog -i 0 -f tetris_top.bit
