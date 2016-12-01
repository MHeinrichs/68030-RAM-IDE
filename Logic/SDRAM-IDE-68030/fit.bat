@SET PATH=c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64;C:\Xilinx\14.6\ISE_DS\ISE\lib\nt64
@SET XILINX=c:\Xilinx\14.6\ISE_DS\ISE
cpldfit -intstyle ise -p xc95288xl-10-TQ144 -ofmt vhdl -optimize speed -htmlrpt -loc on -slew fast -init low -inputs %1 -pterms %2 -unused float -power std -terminate float SDRAM_IDE.ngd >log.txt
@IF %ERRORLEVEL% NEQ 0 GOTO NO_SUCCESS
tsim -intstyle ise SDRAM_IDE SDRAM_IDE.nga >>log.txt
hprep6 -s IEEE1149 -n SDRAM_IDE -i SDRAM_IDE
GOTO END
:NO_SUCCESS
@echo !!!!
@echo error fitting the jed!
@echo !!!!
:END