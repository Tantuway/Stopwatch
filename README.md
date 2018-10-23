# STOPWATCH CONTROLLER 

The objective of this project is  to design digital logic for general purpose stopwatch and implement it on FPGA .

OVERVIEW
---

	 
  A 4 digit 7segment display is used for the output ,  16 slide switches are used to load the data , and 2 push button switches are used to give the following command :
  
   1) load   ( push button switch 1 )
   
   2) Start  ( push button switch 2 )
   
   3) Stop  ( push button switch 2 )
   
   4) Reset  ( push button switch 1 )
		
LOAD :- 
		load command is given to load the data from the slide switches .
	    
   Slide Switches :-  
			 16 Slide switches are used to load the 4 vectors AB:CD .
START :- 
		If the load is 00:00 then it will work as a Stopwatch and start counting else it will work as a Timer and start down counting .

STOP :-     
		while pressing the corresponding push button switch it will stop the counting and   and the output on the 4Digit 7 segment display freezes .

RESET :-   
	        It will reset the counter to the load at that instant . 



DEBOUNCING :-  
---
	
  The Debouncing is done in such a way that if input from the push button is stable for more then  30ms then the debouncing module output a positive edge to the top level module .
	For Debouncing a 10bit counter with a leastcount of 10ms is used . If the user presses the push button switch more then 1024*2*10ms (20.48sec) ( which is relatively long and not used generally   )then the module will take it as an another input .   It can be improved by using a 2flipflop state machine for getting a single output from a long press .
  
4 DIGIT 7 SEGMENT DISPLAY :-
---
  	
    
  The concept of persistence of vision is used here .A refresh period of 40ms and a digit period of 10ms is used , that is each 7 segment is on for 10ms and off for next 30ms in a cyclic manner  . so each 7 segment blink 25 time in 1 second and this speed of blinking cannot be detected by human eye .
	A binary to 7 segment decoder is also used in the module . Also note that LED enables are active low .  
	
