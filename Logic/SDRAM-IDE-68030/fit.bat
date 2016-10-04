SET PATH=%PATH%;c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64

cpldfit -intstyle ise -p xc95288xl-10-TQ144 -ofmt vhdl -optimize density -htmlrpt -loc on -slew fast -init low -inputs 54 -pterms 35 -unused float -power std -terminate keeper -exhaust SDRAM_IDE.ngd >log.txt
tsim -intstyle ise SDRAM_IDE SDRAM_IDE.nga
hprep6 -s IEEE1149 -n SDRAM_IDE -i SDRAM_IDE