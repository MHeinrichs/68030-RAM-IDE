SET PATH=%PATH%;c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64

cpldfit -intstyle ise -p xc95288xl-10-TQ144 -ofmt vhdl -optimize speed -htmlrpt -loc on -slew fast -init low -inputs 54 -pterms 25 -unused float -power std -terminate keeper -exhaust SDRAM_IDE.ngd >log.txt
tsim -intstyle ise RAMCtrl RAMCtrl.nga
hprep6 -s IEEE1149 -n RAMCtrl -i RAMCtrl