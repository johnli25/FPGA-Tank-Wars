module  bullet2 ( input Reset, frame_clk, 
					input logic [9:0] ballX, ballY,
					input [31:0] keycode,
					input [7:0] keycodeShoot2,
					input [9:0] ball2xmotion, ball2ymotion,
					input [2:0] disappear [12:0],
					input [2:0] tank_bullet2 [12:0],
					input game_over_display, game_over_display2,
               output [9:0]  bullet2X, bullet2Y, bullet2Sx, bullet2Sy,
					output [1:0] bullet2On,
					output logic shot_hit2);
	 
	 //In order to make a bullet22 we need the ball x and y, reset, keycode, we will output the the position of the bullet22
	 
	 logic [9:0] bullet2_X_Pos, bullet2_X_Motion, bullet2_Y_Pos, bullet2_Y_Motion, bullet2x_Size, bullet2y_Size;
	 logic [1:0] bullet2_on; 
	 logic flag;
	  
	 logic shothit2;
	 logic one_at_a_time;
 
logic [1:0] bullet2_direction;
logic bullet2_direction0;
logic bullet2_direction1;
logic bullet2_direction2;
logic bullet2_direction3;
	 
    parameter [9:0] bullet2_X_Center=320;  // Center position on the X axis
    parameter [9:0] bullet2_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] bullet2_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] bullet2_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] bullet2_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] bullet2_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] bullet2_X_Step=1;      // Step size on the X axis
    parameter [9:0] bullet2_Y_Step=1;      // Step size on the Y axis

    assign bullet2x_Size = 8;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign bullet2y_Size = 8;

    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_bullet2
        if (Reset)  // Asynchronous Reset
        begin 
            bullet2_Y_Motion <= 10'd0; //bullet2_Y_Step;
				bullet2_X_Motion <= 10'd0; //bullet2_X_Step;
				bullet2_Y_Pos <= ballX;
				bullet2_X_Pos <= ballY;
				flag <= 1'b0;
				one_at_a_time <= 1'b0;
				shothit2 <= 1'b0;
				
        end
		  else if (game_over_display) begin
            bullet2_Y_Motion <= 10'd0; //bullet2_Y_Step;
				bullet2_X_Motion <= 10'd0; //bullet2_X_Step;
				bullet2_Y_Pos <= ballX;
				bullet2_X_Pos <= ballY;
				flag <= 1'b0;
				one_at_a_time <= 1'b0;
				shothit2 <= 1'b0;		  
		  end
		  else if (game_over_display2) begin
            bullet2_Y_Motion <= 10'd0; //bullet2_Y_Step;
				bullet2_X_Motion <= 10'd0; //bullet2_X_Step;
				bullet2_Y_Pos <= ballX;
				bullet2_X_Pos <= ballY;
				flag <= 1'b0;
				one_at_a_time <= 1'b0;
				shothit2 <= 1'b0;		  
		  end		  
		  
        else 
        begin
		  				 
						bullet2_Y_Pos <= (bullet2_Y_Pos + bullet2_Y_Motion);
						bullet2_X_Pos <= (bullet2_X_Pos + bullet2_X_Motion);
						shothit2 <= 1'b0;
					
				 case (keycode)
				 
				 8'h28 : begin //enter key
//							  bullet2_on <= 1'b1;
							  if (bullet2_on == 1'b0) begin
									bullet2_Y_Pos <= (ballY+4);  // Update bullet2 position, have it move up everytime
									bullet2_X_Pos <= (ballX+4);
							  end
							  bullet2_on <= 1'b1;
							  flag <= 1'b0;
							  shothit2 <= 1'b0;						  
//							  if (bullet2_direction == 2'b00 && bullet2_X_Motion != -8) begin //A-left
//							  if (bullet2_direction0 == 1'b1 && one_at_a_time == 1'b0) begin	
							  if (ball2xmotion == (~(bullet2_X_Step) + 1'b1) && ball2ymotion == 0) begin	
									bullet2_Y_Motion <= 0;
									bullet2_X_Motion <= -10;
									one_at_a_time <= 1'b1;									
							  end
//							  else if (bullet2_direction == 2'b01) begin //D-right
//							  else if (bullet2_direction1 == 1'b1 && one_at_a_time == 1'b0) begin										
							  else if (ball2xmotion == 1 && ball2ymotion == 0) begin	

									bullet2_Y_Motion <= 0;
									bullet2_X_Motion <= 10;
									one_at_a_time <= 1'b1;									
							  end							 
//							  else if (bullet2_direction == 2'b10) begin //S-down
//							  else if (bullet2_direction2 == 1'b1 && one_at_a_time == 1'b0) begin										
							  else if (ball2xmotion == 0 && ball2ymotion == 1) begin	

									bullet2_Y_Motion <= 10;
									bullet2_X_Motion <= 0;
									one_at_a_time <= 1'b1;									
							  end									
//							  else if (bullet2_direction == 2'b11) begin //W-up
//							  else if (bullet2_direction3 == 1'b1 && one_at_a_time == 1'b0) begin										
							  else if (ball2xmotion == 0 && ball2ymotion == (~(bullet2_Y_Step) + 1'b1)) begin	

									bullet2_Y_Motion <= -10;
									bullet2_X_Motion <= 0;
									one_at_a_time <= 1'b1;									
							  end		
							  
						   end						
						
//					8'h50: begin //left
//								bullet2_direction <= 2'b00;
//								bullet2_direction0 <= 1'b1;
//								bullet2_direction1 <= 1'b0;
//								bullet2_direction2 <= 1'b0;
//								bullet2_direction3 <= 1'b0;
//								
//							  end		        
//					8'h4f:  begin//right
//								bullet2_direction <= 2'b01;
//								bullet2_direction0 <= 1'b0;
//								bullet2_direction1 <= 1'b1;
//								bullet2_direction2 <= 1'b0;
//								bullet2_direction3 <= 1'b0;
//																
//							  end
//					8'h51: begin//down
//								bullet2_direction <= 2'b10;
//								bullet2_direction0 <= 1'b0;
//								bullet2_direction1 <= 1'b0;
//								bullet2_direction2 <= 1'b1;
//								bullet2_direction3 <= 1'b0;
//																
//							 end							  
//					8'h52: begin//up
//								bullet2_direction <= 2'b11;
//								bullet2_direction0 <= 1'b0;
//								bullet2_direction1 <= 1'b0;
//								bullet2_direction2 <= 1'b0;
//								bullet2_direction3 <= 1'b1;																
//							 end 		
				
			    default: ;
				 
				 endcase
				  
//				 begin 
				 
				 for (int i = 0; i < 13; i++) begin				 						
					if ((bullet2_Y_Pos - bullet2y_Size) <= bullet2_Y_Min + 5'd19)  // bullet2 is at the top edge, BOUNCE!
					  begin
						bullet2_Y_Pos <= (ballY-1);  // Update bullet2 position, have it move up everytime
						bullet2_X_Pos <= (ballX+6);
						bullet2_Y_Motion <= 0;
						bullet2_X_Motion <= 0;
						bullet2_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit2 <= 1'b0;						  
					  end
					  
					else if ((bullet2_Y_Pos + bullet2y_Size) >= bullet2_Y_Max - 5'd19)  // bullet2 is at the top edge, BOUNCE!
					  begin
						bullet2_Y_Pos <= (ballY+11);  // Update bullet2 position, have it move up everytime
						bullet2_X_Pos <= (ballX+6);
						bullet2_Y_Motion <= 0;
						bullet2_X_Motion <= 0;
						bullet2_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit2 <= 1'b0;						  					
					  end
					  
					else if ((bullet2_X_Pos - bullet2x_Size) <= bullet2_X_Min + 5'd19)  // bullet2 is at the top edge, BOUNCE!
					  begin
						bullet2_Y_Pos <= (ballY+6);  // Update bullet2 position, have it move up everytime
						bullet2_X_Pos <= (ballX-1);
						bullet2_Y_Motion <= 0;
						bullet2_X_Motion <= 0;
						bullet2_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit2 <= 1'b0;						  						
					  end
					  
					else if ((bullet2_X_Pos + bullet2x_Size) >= bullet2_X_Max - 5'd19)  // bullet2 is at the top edge, BOUNCE!
					  begin
						bullet2_Y_Pos <= (ballY+6);  // Update bullet2 position, have it move up everytime
						bullet2_X_Pos <= (ballX+11);
						bullet2_Y_Motion <= 0;
						bullet2_X_Motion <= 0;
						bullet2_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit2 <= 1'b0;						  						
					  end		
					else if (disappear[i] != 3'b100) begin
						bullet2_Y_Pos <= (ballY+5);  // Update bullet position, have it move up everytime
						bullet2_X_Pos <= (ballX+5);
						bullet2_Y_Motion <= 0;
						bullet2_X_Motion <= 0;
						bullet2_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;
						shothit2 <= 1'b0;						  						
					end
					else if (tank_bullet2[i] != 3'b100) begin
						bullet2_Y_Pos <= (ballY+5);  // Update bullet position, have it move up everytime
						bullet2_X_Pos <= (ballX+5);
						bullet2_Y_Motion <= 0;
						bullet2_X_Motion <= 0;
						bullet2_on <= 1'b0;
						flag <= 1'b1;
						one_at_a_time <= 1'b0;	
						shothit2 <= 1'b1;						  						
					end							

					else
					  begin
					  
//					   if (flag == 1'b1) //"hiding" condition
//							begin
//							bullet2_on <= 1'b0;
//							bullet2_Y_Pos <= (ballY);  
//							bullet2_Y_Motion <= 0;
//							bullet2_X_Motion <= 0;
////							one_at_a_time <= 1'b0;
//
//							end
						
//						else 
//							begin
//							bullet2_Y_Pos <= (bullet2_Y_Pos + bullet2_Y_Motion);
//							bullet2_X_Pos <= (bullet2_X_Pos + bullet2_X_Motion);
//							bullet2_on = 1'b1;
//							one_at_a_time <= 1'b0;
//							end
					 end
				 end //for loop-end

//				end
//			 endcase
							  
		end  
    end
       
    assign bullet2X = bullet2_X_Pos;
   
    assign bullet2Y = bullet2_Y_Pos;
   
    assign bullet2Sx = bullet2x_Size;
	 
	 assign bullet2Sy = bullet2y_Size;
	 
	 assign bullet2On = bullet2_on;
	 
	 assign shot_hit2 = shothit2;
	 
endmodule