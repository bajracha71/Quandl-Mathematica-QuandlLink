# Instructions to install QuandlLink package in Mathematica. 
1. Download QuandlLink zipped folder.
2. Follow the instruction in following wolfram support article to install QuandlLink package using QuandlLink zipped folder:
    
     http://support.wolfram.com/kb/5648

3. Or simply unzip the folder and put the contents (i.e QuandlLink folder)  in Applications folder of either $UserBaseDirectory or $BaseDirectory of Mathematica. These location can be opened by evaluating following in Mathematica notebook:

SystemOpen[FileNameJoin[{$BaseDirectory, "Applications"}]]
SystemOpen[FileNameJoin[{$UserBaseDirectory, "Applications"}]]
