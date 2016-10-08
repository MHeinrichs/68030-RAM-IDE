@SET PATH=c:\Xilinx\14.6\ISE_DS\ISE\bin\nt64;C:\Xilinx\14.6\ISE_DS\ISE\lib\nt64
@SET XILINX=c:\Xilinx\14.6\ISE_DS\ISE
xst -intstyle ise -ifn "C:/Users/Matze/Amiga/Hardwarehacks/68030-RAM-IDE/Logic/SDRAM-IDE-68030/SDRAM_IDE.xst" -ofn "C:/Users/Matze/Amiga/Hardwarehacks/68030-RAM-IDE/Logic/SDRAM-IDE-68030/SDRAM_IDE.syr" >log.txt
ngdbuild -intstyle ise -dd _ngo -uc pinlist.ucf -p xc95288xl-TQ144-10 SDRAM_IDE.ngc SDRAM_IDE.ngd >>log.txt
C:\Xilinx\14.6\ISE_DS\ISE\bin\nt64\unwrapped\ngdbuild.exe -intstyle ise -dd _ngo -uc pinlist.ucf -p xc95288xl-TQ144-10 SDRAM_IDE.ngc SDRAM_IDE.ngd >>log.txt
@call fit.bat