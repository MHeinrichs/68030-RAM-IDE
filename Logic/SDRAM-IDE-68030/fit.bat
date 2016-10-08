@SET PATH=c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64;C:\Xilinx\14.6\ISE_DS\ISE\lib\nt64
@SET XILINX=c:\Xilinx\14.6\ISE_DS\ISE
rem xst -intstyle ise -ifn "C:/Users/Matze/Amiga/Hardwarehacks/68030-RAM-IDE/Logic/SDRAM-IDE-68030/SDRAM_IDE.xst" -ofn "C:/Users/Matze/Amiga/Hardwarehacks/68030-RAM-IDE/Logic/SDRAM-IDE-68030/SDRAM_IDE.syr" >log.txt
rem ngdbuild -intstyle ise -dd _ngo -uc pinlist.ucf -p xc95288xl-TQ144-10 SDRAM_IDE.ngc SDRAM_IDE.ngd >>log.txt
rem C:\Xilinx\14.6\ISE_DS\ISE\bin\nt64\unwrapped\ngdbuild.exe -intstyle ise -dd _ngo -uc pinlist.ucf -p xc95288xl-TQ144-10 SDRAM_IDE.ngc SDRAM_IDE.ngd >>log.txt
cpldfit -intstyle ise -p xc95288xl-10-TQ144 -ofmt vhdl -optimize speed -htmlrpt -loc on -slew fast -init low -inputs 54 -pterms 20 -unused float -power std -terminate float SDRAM_IDE.ngd >>log.txt
tsim -intstyle ise SDRAM_IDE SDRAM_IDE.nga >>log.txt
hprep6 -s IEEE1149 -n SDRAM_IDE -i SDRAM_IDE