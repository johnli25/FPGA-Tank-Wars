module  ball2 ( input Reset, frame_clk,
					input [7:0] keycode,
               output [9:0]  ball2X, ball2Y, ball2Sx, ball2Sy,
					input game_over_display, game_over_display2,
					input [2:0] bounce_on [12:0],
//					input [2:0] tank_bounce_on [5:0]
					output [2:0] rotation2,
					input logic shotHit,
					output logic field2On,
					output logic [9:0] ball2xmove, ball2ymove
					);

    logic [9:0] ball2_X_Pos, ball2_X_Motion, ball2_Y_Pos, ball2_Y_Motion, ball2x_Size, ball2y_Size;
	 logic obstacle_on;
	 logic [2:0] rotation_internal;

	 logic [10:0] shape_x = 100;
	 logic [10:0] shape_y = 100;
	 logic [10:0] shape_size_x = 16;
	 logic [10:0] shape_size_y = 16;
	 
	 logic [10:0] sprite_addr;
	 logic [15:0] sprite_data;
	 
	 logic fieldOn = 1'b0;

	 //font_rom(.addr(sprite_addr), .data(sprite_data));

    parameter [9:0] ball2_X_Center=320;  // Center position on the X axis
    parameter [9:0] ball2_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] ball2_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] ball2_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] ball2_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] ball2_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] ball2_X_Step=1;      // Step size on the X axis
    parameter [9:0] ball2_Y_Step=1;      // Step size on the Y axis

	 logic [9:0] pistonxsig, pistonysig, pistonsizexsig, pistonsizeysig;
	 
    assign ball2x_Size = shape_size_x;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign ball2y_Size = shape_size_y;
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_ball2
        if (Reset)  // Asynchronous Reset
        begin 
            ball2_Y_Motion <= 10'd0; //ball2_Y_Step;
				ball2_X_Motion <= 10'd0; //ball2_X_Step;
				ball2_Y_Pos <= ball2_Y_Center;
				ball2_X_Pos <= ball2_X_Center + 10'd205;
        end
		  else if (game_over_display) begin
            ball2_Y_Motion <= 10'd0; //Ball_Y_Step;
				ball2_X_Motion <= 10'd0; //Ball_X_Step;
				ball2_Y_Pos <= ball2_Y_Center;
				ball2_X_Pos <= ball2_X_Center + 10'd205;	
		  end 
		  else if (game_over_display2) begin
            ball2_Y_Motion <= 10'd0; //Ball_Y_Step;
				ball2_X_Motion <= 10'd0; //Ball_X_Step;
				ball2_Y_Pos <= ball2_Y_Center;
				ball2_X_Pos <= ball2_X_Center + 10'd205;	
		  end 	
		  else if (shotHit == 1'b1)
        begin
				ball2_Y_Pos <= ball2_Y_Center;
				ball2_X_Pos <= ball2_X_Center + 10'd205;
        end		  
        else
				begin	
		 		case (keycode)
					8'h50 : begin

								ball2_X_Motion <= -1;//A
								ball2_Y_Motion<= 0;
								rotation_internal <= 3'b001;
								if ( (ball2_X_Pos - ball2x_Size) <= ball2_X_Min )  // ball2 is at the Left edge, BOUNCE!
									ball2_X_Motion <= ball2_X_Step;	
							  end		        
					8'h4f : begin
								
					        ball2_X_Motion <= 1;//D
							  ball2_Y_Motion <= 0;
							  rotation_internal <= 3'b000;
							  if ( (ball2_X_Pos + ball2x_Size) >= ball2_X_Max )  // ball2 is at the Right edge, BOUNCE!
									ball2_X_Motion <= (~ (ball2_X_Step) + 1'b1);
							  end
					8'h51 : begin

					        ball2_Y_Motion <= 1;//S
							  ball2_X_Motion <= 0;
							  rotation_internal <= 3'b010;
							  
							  if ( (ball2_Y_Pos + ball2y_Size) >= ball2_Y_Max )  // ball2 is at the bottom edge, BOUNCE!
									ball2_Y_Motion <= (~ (ball2_Y_Step) + 1'b1);
							 end							  
					8'h52 : begin
					        ball2_Y_Motion <= -1;//W
							  ball2_X_Motion <= 0;
							  rotation_internal <= 3'b011;							
							  if ( (ball2_Y_Pos - ball2y_Size) <= ball2_Y_Min )  // ball2 is at the top edge, BOUNCE!
									ball2_Y_Motion <= ball2_Y_Step;
							 end  
							 
					8'h13 : begin //p key pressed activate shield
							 fieldOn <= 1'b1;
						     end
					default: 
					
							fieldOn <= 1'b0;
			   endcase 
				
         
				 for (int i = 0; i < 13; i++) begin

				 if ( (ball2_Y_Pos + ball2y_Size) >= ball2_Y_Max )  // ball2 is at the bottom edge, BOUNCE!
					  ball2_Y_Motion <= (~ (ball2_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (ball2_Y_Pos) <= ball2_Y_Min )  // ball2 is at the top edge, BOUNCE!
					  ball2_Y_Motion <= ball2_Y_Step;
					  
				 else if ( (ball2_X_Pos + ball2x_Size) >= ball2_X_Max )  // ball2 is at the Right edge, BOUNCE!
					  ball2_X_Motion <= (~ (ball2_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (ball2_X_Pos) <= ball2_X_Min )  // ball2 is at the Left edge, BOUNCE!
					  ball2_X_Motion <= ball2_X_Step;
					  
				 else if (bounce_on[i] == 3'b000)
				 		ball2_X_Motion <= (~ (ball2_X_Step) + 1'b1);

				 else if (bounce_on[i] == 3'b001)
				 		ball2_X_Motion <= ball2_X_Step;
						
				 else if (bounce_on[i] == 3'b010)
						ball2_Y_Motion <= (~(ball2_Y_Step) + 1'b1);
						
				 else if (bounce_on[i] == 3'b011)
						ball2_Y_Motion <= ball2_Y_Step;
						
//				 else if (tank_bounce_on[i] == 3'b000)
//				 		ball2_X_Motion <= (~ (ball2_X_Step) + 1'b1);
//
//				 else if (tank_bounce_on[i] == 3'b001)
//				 		ball2_X_Motion <= ball2_X_Step;
//						
//				 else if (tank_bounce_on[i] == 3'b010)
//						ball2_Y_Motion <= (~(ball2_Y_Step) + 1'b1);
//						
//				 else if (tank_bounce_on[i] == 3'b011)
//						ball2_Y_Motion <= ball2_Y_Step;						
				 
				 else begin
//					  ball2_Y_Motion <= ball2_Y_Motion;  // ball2 is somewhere in the middle, don't bounce, just keep moving

				 end
			end //for loop's end
				 
				 ball2_Y_Pos <= (ball2_Y_Pos + ball2_Y_Motion);  // Update ball2 position
				 //check if x and y position of player is in obstacle, move it out
				 ball2_X_Pos <= (ball2_X_Pos + ball2_X_Motion);
			
		end  
    end
       
    assign ball2X = ball2_X_Pos;
   
    assign ball2Y = ball2_Y_Pos;
   
    assign ball2Sx = ball2x_Size;
	 
	 assign ball2Sy = ball2y_Size;
	 
	 assign rotation2 = rotation_internal;

	 assign field2On = fieldOn;
	 
	 assign ball2xmove = ball2_X_Motion;
	 
	 assign ball2ymove = ball2_Y_Motion;	 

endmodule