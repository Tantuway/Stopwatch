`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// Engineer: Mayank Tantuway 
// 
// Create Date: 08/28/2018 11:19:15 PM
// Module Name: StapWatch
// 
//////////////////////////////////////////////////////////////////////////////////


module StopWatch(
    input [3:0]loadA,
    input [3:0]loadB,
    input [3:0]loadC,
    input [3:0]loadD,
    input clk,   ///  100M HZ 
    input  ISW1, /// ISW1 for load and resume // btnR
    input  ISW2, /// ISW2 for start and stop the stopwatch or timer ///btnL
    output reg [6:0]segment7 ,
    output reg [3:0]an
     );

    /// display is of the form AB:CD in 4-Digit  seven segment LED

	reg [3:0]ledA = 4'b0000;
        reg [3:0]ledB = 4'b0000;
        reg [3:0]ledC = 4'b0000;
        reg [3:0]ledD = 4'b0000;
	reg [19:0]count_clk = 20'b0 ; 
	reg clk_10ms =1'b0 ;
    

	wire SW1 ;
	wire SW2 ;

/// always block to get a clock of 10ms from input 100MHZ clk
	always @ (posedge clk ) 
		begin 
		if (count_clk < 19'b1111010000100011111)   //  49,9999
			begin 
				count_clk = count_clk +1 ;
			end 
		else 
			begin 
				clk_10ms = ~clk_10ms ;
				count_clk = 20'b0;
			end 
		end 



	debounce FIRST ( clk_10ms , ISW1  , SW1);
	debounce SECOND ( clk_10ms , ISW2  , SW2);
    
    
    reg count = 1'b0; /// count is used to change state from START  to PAUSE  and then to START in cyclic faction 
    
   
       always@( posedge SW2 )
                begin 
                     count <= ~count ;
                end 
       always@(posedge clk_10ms)
                begin 
                        if (count)     // if count is TRUE start the stopwatch or timer  else  pause
                        begin 
                              if (!loadA & !loadB & !loadC & !loadD)     //  work as a stopwatch if LOAD is 00:00 
                              begin
                                ledD <= (ledD +1 )%10 ;
                               
                                if (ledD +1 == 4'b0000)
                                 begin
                                        ledC <= (ledC +1 )%10 ;
                                         
                                        if (ledC +1 == 4'b0000)
                                        begin
                                                ledB <= (ledB +1 )%10 ;
                                                                                 
                                                if (ledB +1  == 4'b0000)
                                                begin
                                                        ledA <= (ledA +1 )%10 ;
                                                                                     
                                                end 
                                                                              
                                        end 
                                      
                                 end 
                              end
                              else 
                              begin    // work as a timer ie. decrease counting from the loaded value 
                              		if (ledD==0)
					begin
						ledD=4'b1001;
						if(ledC==4'b0000)	
						begin
							ledC=4'b1001;
							if(ledB==4'b0000) 			
							begin
								ledB=4'b1001;
								if(ledA==4'b0000)
								begin 
									ledA=4'b1001;
								end 
								else
								begin 
									ledA <=ledA-1 ;
								end  
							end 
							else
							begin
								ledB <=ledB-1 ;
							end  
							
						end 
						else 
						begin 
							ledC <=ledC-1;
						end
					end
					else 
					begin 
						ledD <=ledD-1;
					end         
                              end     // end of a timer 
                        end
                     else      ////else not needed because it will automatically pause the Stopwatch or timer ...
                     begin 
                        if ( SW1 )
                        begin 
                                ledA<=loadA;
                                ledB<=loadB;
                                ledC<=loadC;
                                ledD<=loadD;
                        end                      
                     end 
                               
                                  
                        
                end  ///

///////////////////////////////////////////////4DIGIT 7SEGMENT DISPLAY ////////////////////// 


		reg [1:0]which = 2'b10;
		reg [3:0]Indumy ;
                reg [1:0]new_count ;
		

                //  BCD to 7 segment for comman anode ;

		always @ *
		begin 
			case (Indumy) 
					
                                        //      gfedcba;
			4'b0000 : segment7 = 7'b1000000;
			4'b0001 : segment7 = 7'b1111001;
			4'b0010 : segment7 = 7'b0100100;
			4'b0011 : segment7 = 7'b0110000;
			4'b0100 : segment7 = 7'b0011001;
			4'b0101 : segment7 = 7'b0010010;
			4'b0110 : segment7 = 7'b0000010;
			4'b0111 : segment7 = 7'b1111000;
			4'b1000 : segment7 = 7'b0000000;
			4'b1001 : segment7 = 7'b0010000;
			default : segment7 = 7'b1000000; 
			endcase 
		end 


		always @ (posedge clk_10ms )
		begin 
			which = which+1 ;
		end 


		//always @ (ledA or ledB or ledC or ledD or which )
		always @ *
		begin 

			case (which)
			2'b00      :   begin 
					Indumy = ledD            ;
					an = 4'b1110             ;
				    end 
			2'b01      :   begin 
					Indumy = ledC            ;
					an = 4'b1101             ;
				    end 
			2'b10      :   begin 
					Indumy = ledB            ;
					an = 4'b1011             ;
				    end 
			2'b11      :  begin 
					 Indumy = ledA           ;
			       		 an = 4'b0111            ;
				   end 
			default :   begin 
					Indumy = ledD            ; 
					an = 4'b1101             ; 
				    end  
			endcase 
		end







//////////////////////////////////////////////////////////////////////////////////////////////
    
endmodule

module debounce (input clk ,
		 input   PBI ,                // Push Butoon Input   
		 output  reg PBO  );          // Push Butoon Output

	reg  [9:0]count ; 

	//

	always @ (posedge clk or negedge PBI )
	begin 
		if (PBI==0) 
		begin 
			count <= 10'b0 ;
		end 
		else 
		begin 
			count = count +1 ;
		end 
	end 



	
	always @ * 
	begin 
		if ( count >  10'b0000000011 )    ////  30ms check 
		begin 	 PBO <= 1'b1 ; end 
		else 
		begin  PBO <= 1'b0 ;end 
	end
       


endmodule

