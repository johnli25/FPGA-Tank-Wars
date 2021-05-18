//-------------------------------------------------------------------------
//    bullet.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------
module  bullet (input Reset, frame_clk, 
					input logic [9:0] ballX, ballY,
					input [31:0] keycode,
					input [2:0] disappear [12:0],
					input [2:0] tank_bullet [12:0],
					input game_over_display, game_over_display2,//start over
               output [9:0]  bulletX, bulletY, bulletSx, bulletSy,
					output [1:0] bulletOn,
					output logic shot_hit1);
   
	 //In order to make a bullet we need the ball x and y, reset, keycode, we will output the the position of the bullet
	 	 
 logic [9:0] bullet_X_Pos, bullet_X_Motion, bullet_Y_Pos, bullet_Y_Motion, bulletx_Size, bullety_Size;
 logic [1:0] bullet_on; 
 logic flag;
 logic one_at_a_time;
 logic shothit1;
 
logic [1:0] bullet_direction;
logic bullet_direction0;
logic bullet_direction1;
logic bullet_direction2;
logic bullet_direction3;

//	 logic [10:0] 
	 
    parameter [9:0] bullet_X_Center=320;  // Center position on the X axis
    parameter [9:0] bullet_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] bullet_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] bullet_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] bullet_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] bullet_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] bullet_X_Step=1;      // Step size on the X axis
    parameter [9:0] bullet_Y_Step=1;      // Step size on the Y axis

    assign bulletx_Size = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign bullety_Size = 8;

    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_bullet
        if (Reset)  // Asynchronous Reset
        begin 
            bullet_Y_Motion <= 10'd0; //bullet_Y_Step;
				bullet_X_Motion <= 10'd0; //bullet_X_Step;
				bullet_Y_Pos <= ballX;
				bullet_X_Pos <= ballY;
				flag <= 1'b0;
				one_at_a_time <= 1'b0;
				shothit1 <= 1'b0;
        end
		  else if (game_over_display) begin
            bullet_Y_Motion <= 10'd0; //bullet_Y_Step;
				bullet_X_Motion <= 10'd0; //bullet_X_Step;
				bullet_Y_Pos <= ballX;
				bullet_X_Pos <= ballY;
				flag <= 1'b0;
				one_at_a_time <= 1'b0;
				shothit1 <= 1'b0;
		  end
		  else if (game_over_display2) begin
            bullet_Y_Motion <= 10'd0; //bullet_Y_Step;
				bullet_X_Motion <= 10'd0; //bullet_X_Step;
				bullet_Y_Pos <= ballX;
				bullet_X_Pos <= ballY;
				flag <= 1'b0;
				one_at_a_time <= 1'b0;
				shothit1 <= 1'b0;
		  end		  
        
        else 
		  
        begin		  				 
						bullet_Y_Pos <= (bullet_Y_Pos + bullet_Y_Motion);
						bullet_X_Pos <= (bullet_X_Pos + bullet_X_Motion);
						shothit1 <= 1'b0;
					
				 case (keycode)
				 
				 8'h2c : begin //spacebar
//							  bullet_on <= 1'b1;
							  if (bullet_on == 1'b0) begin
									bullet_Y_Pos <= (ballY+4);  // Update bullet position, have it move up everytime
									bullet_X_Pos <= (ballX+4);
							  end
							  bullet_on <= 1'b1;
							  flag <= 1'b0;
							  shothit1 <= 1'b0;					
	  
//							  if (bullet_direction == 2'b00 && bullet_X_Motion != -8) begin //A-left
							  if (bullet_direction0 == 1'b1 && one_at_a_time == 1'b0) begin	
									bullet_Y_Motion <= 0;
									bullet_X_Motion <= -10;
									one_at_a_time <= 1'b1;
							  end
//							  else if (bullet_direction == 2'b01) begin //D-right
							  else if (bullet_direction1 == 1'b1 && one_at_a_time == 1'b0) begin										
									bullet_Y_Motion <= 0;
									bullet_X_Motion <= 10;
									one_at_a_time <= 1'b1;
							  end							 
//							  else if (bullet_direction == 2'b10) begin //S-down
							  else if (bullet_direction2 == 1'b1 && one_at_a_time == 1'b0) begin										
									bullet_Y_Motion <= 10;
									bullet_X_Motion <= 0;
									one_at_a_time <= 1'b1;
							  end									
//							  else if (bullet_direction == 2'b11) begin //W-up
							  else if (bullet_direction3 == 1'b1 && one_at_a_time == 1'b0) begin										
									bullet_Y_Motion <= -10;
									bullet_X_Motion <= 0;
									one_at_a_time <= 1'b1;
							  end		
							  
						   end						
						
					8'h04 : begin //A-left
								bullet_direction <= 2'b00;
								bullet_direction0 <= 1'b1;
								bullet_direction1 <= 1'b0;
								bullet_direction2 <= 1'b0;
								bullet_direction3 <= 1'b0;
								
							  end		        
					8'h07 : begin//D-right
								bullet_direction <= 2'b01;
								bullet_direction0 <= 1'b0;
								bullet_direction1 <= 1'b1;
								bullet_direction2 <= 1'b0;
								bullet_direction3 <= 1'b0;
																
							  end
					8'h16 : begin//S-down
								bullet_direction <= 2'b10;
								bullet_direction0 <= 1'b0;
								bullet_direction1 <= 1'b0;
								bullet_direction2 <= 1'b1;
								bullet_direction3 <= 1'b0;
																
							 end							  
					8'h1A : begin//W-up
								bullet_direction <= 2'b11;
								bullet_direction0 <= 1'b0;
								bullet_direction1 <= 1'b0;
								bullet_direction2 <= 1'b0;
								bullet_direction3 <= 1'b1;
																
							 end 		
				
			    default: ;
				 
				 endcase
				  
//				 begin 
				 
				 for (int i = 0; i < 13; i++) begin				 	
					if ((bullet_Y_Pos - bullety_Size) <= bullet_Y_Min + 5'd19)  // bullet is at the top edge, BOUNCE!
					  begin
						bullet_Y_Pos <= (ballY-1);  // Update bullet position, have it move up everytime
						bullet_X_Pos <= (ballX+6);
						bullet_Y_Motion <= 0;
						bullet_X_Motion <= 0;
						bullet_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit1 <= 1'b0;
						
					  end
					else if ((bullet_Y_Pos + bullety_Size) >= bullet_Y_Max - 5'd19)  // bullet is at the top edge, BOUNCE!
					  begin
						bullet_Y_Pos <= (ballY+11);  // Update bullet position, have it move up everytime
						bullet_X_Pos <= (ballX+6);
						bullet_Y_Motion <= 0;
						bullet_X_Motion <= 0;
						bullet_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit1 <= 1'b0;
						
					  end
					else if ((bullet_X_Pos - bulletx_Size) <= bullet_X_Min + 5'd19)  // bullet is at the top edge, BOUNCE!
					  begin
						bullet_Y_Pos <= (ballY+6);  // Update bullet position, have it move up everytime
						bullet_X_Pos <= (ballX-1);
						bullet_Y_Motion <= 0;
						bullet_X_Motion <= 0;
						bullet_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit1 <= 1'b0;
						
					  end
					else if ((bullet_X_Pos + bulletx_Size) >= bullet_X_Max - 5'd19)  // bullet is at the top edge, BOUNCE!
					  begin
						bullet_Y_Pos <= (ballY+6);  // Update bullet position, have it move up everytime
						bullet_X_Pos <= (ballX+11);
						bullet_Y_Motion <= 0;
						bullet_X_Motion <= 0;
						bullet_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit1 <= 1'b0;
					  end		
					else if (disappear[i] != 3'b100) begin //block-bullet interaction
						bullet_Y_Pos <= (ballY+5);  // Update bullet position, have it move up everytime
						bullet_X_Pos <= (ballX+5);
						bullet_Y_Motion <= 0;
						bullet_X_Motion <= 0;
						bullet_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit1 <= 1'b0;
					end
					else if (tank_bullet[i] != 3'b100) begin //tank-bullet interaction
						bullet_Y_Pos <= (ballY+5);  // Update bullet position, have it move up everytime
						bullet_X_Pos <= (ballX+5);
						bullet_Y_Motion <= 0;
						bullet_X_Motion <= 0;
						bullet_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit1 <= 1'b1;					
					end						
					else
					  begin
					  
//					   if (flag == 1'b1) //"hiding" condition
//							begin
//							bullet_on <= 1'b0;
//							bullet_Y_Pos <= (ballY);  
//							bullet_Y_Motion <= 0;
//							bullet_X_Motion <= 0;
//							one_at_a_time <= 1'b0;

//							end
						
//						else 
//							begin
//							bullet_Y_Pos <= (bullet_Y_Pos + bullet_Y_Motion);
//							bullet_X_Pos <= (bullet_X_Pos + bullet_X_Motion);
//							bullet_on = 1'b1;
//							one_at_a_time <= 1'b0;
//							end
					 end
				 end //for loop-end
							  
		end  
    end
       
    assign bulletX = bullet_X_Pos;
   
    assign bulletY = bullet_Y_Pos;
   
    assign bulletSx = bulletx_Size;
	 
	 assign bulletSy = bullety_Size;
	 
	 assign bulletOn = bullet_on;
	 
	 assign shot_hit1 = shothit1;
	 
endmodule