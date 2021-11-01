#!/usr/bin/awk -f
## this is an old awk command I wrote to dynamically add printers from flags
## I will use this to work from the other script.
BEGIN {
	   for (i = 1; i < ARGC; i++){
      
		  if (ARGV[i] "\-^[aAtTmMhHsS]"){
        #Regular expression to better filter options
			  printer = ""
			  printerqueue = ""
			  driver = "5945_PS.ppd"
			}	   		
	   	if (ARGV[i] == "-"){
			  printer = ""
			  printerqueue = ""
			  driver = "5945_PS.ppd"
	   	}
	   	if (ARGV[i] == "-"){
			  printer = ""
			  printerqueue = ""
			  driver = "5945_PS.ppd"
	   	}
	   	if (ARGV[i] == "-"){
			  printer = ""
			  printerqueue = ""
			  driver = "5945_PS.ppd"
	   	}
	   	if (ARGV[i] == "-"){
			  printer = ""
			  printerqueue = ""
			  driver = "5945_PS.ppd"
	   	}
	   		{
				  system("lpadmin -p "printer" -v lpd:///"printerqueue" -E -P "driver")	
				}
	   	}
	}
	
	

