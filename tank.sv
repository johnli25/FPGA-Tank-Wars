module  ball ( input Reset, frame_clk,
					input [7:0] keycode,
               output [9:0]  BallX, BallY, BallSx, BallSy,
					input [2:0] bounce_on [12:0],
					input game_over_display, game_over_display2,
//					input [2:0] tank_bounce_on [5:0],
					input logic shotHit,
					output [2:0] rotation,
					output logic field1
					);
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ballx_Size, Bally_Size;
	 logic [2:0] rotation_internal;
	 logic obstacle_on;

	 logic [10:0] shape_x = 100;
	 logic [10:0] shape_y = 100;
	 logic [10:0] shape_size_x = 16;
	 logic [10:0] shape_size_y = 16;
	 
	 logic [10:0] sprite_addr;
	 logic [15:0] sprite_data;
	 //font_rom(.addr(sprite_addr), .data(sprite_data));

    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

	 logic [9:0] pistonxsig, pistonysig, pistonsizexsig, pistonsizeysig;
	 
    assign Ballx_Size = shape_size_x;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
	 assign Bally_Size = shape_size_y;
	 
	 logic fieldOn = 1'b0;
    always_ff @ (posedge Reset or posedge frame_clk )
    begin: Move_Ball
        if (Reset)   // Asynchronous Reset
        begin 
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center - 10'd200;
        end
		  else if (game_over_display) begin
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center - 10'd200;	
		  end
		  else if (game_over_display2) begin
            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
				Ball_X_Motion <= 10'd0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center - 10'd200;	
		  end
        else if (shotHit == 1'b1)
        begin
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center - 10'd200;
        end		  
        else
		  begin				
		 		case (keycode)
					8'h04 : begin

								Ball_X_Motion <= -1;//A
								Ball_Y_Motion<= 0;
								rotation_internal <= 3'b001;
								if ( (Ball_X_Pos - Ballx_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
									Ball_X_Motion <= Ball_X_Step;
									
							  end		        
					8'h07 : begin
								
					        Ball_X_Motion <= 1;//D
							  Ball_Y_Motion <= 0;
							  rotation_internal <= 3'b000;

							  if ( (Ball_X_Pos + Ballx_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
									Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
							  end
					8'h16 : begin

					        Ball_Y_Motion <= 1;//S
							  Ball_X_Motion <= 0;
							  rotation_internal <= 3'b010;
							  if ( (Ball_Y_Pos + Bally_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
									Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
							 end							  
					8'h1A : begin
					        Ball_Y_Motion <= -1;//W
							  Ball_X_Motion <= 0;
							  rotation_internal <= 3'b011;
							  if ( (Ball_Y_Pos - Bally_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
									Ball_Y_Motion <= Ball_Y_Step;
							 end
			 		8'h09 : begin //f key pressed activate shield
						   fieldOn <= 1'b1;
						   end
					default: 
							
							fieldOn <= 1'b0;

			   endcase 
				
         
				 for (int i = 0; i < 13; i++) begin

				 if ( (Ball_Y_Pos + Bally_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_Y_Pos) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
					  Ball_Y_Motion <= Ball_Y_Step;
					  
				 else if ( (Ball_X_Pos + Ballx_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
					  
				 else if ( (Ball_X_Pos) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
					  Ball_X_Motion <= Ball_X_Step;
					  
				 else if (bounce_on[i] == 3'b000)
				 		Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);

				 else if (bounce_on[i] == 3'b001)
				 		Ball_X_Motion <= Ball_X_Step;
						
				 else if (bounce_on[i] == 3'b010)
						Ball_Y_Motion <= (~(Ball_Y_Step) + 1'b1);
						
				 else if (bounce_on[i] == 3'b011)
						Ball_Y_Motion <= Ball_Y_Step;
						
//				 else if (tank_bounce_on[i] == 3'b000)
//				 		Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
//
//				 else if (tank_bounce_on[i] == 3'b001)
//				 		Ball_X_Motion <= Ball_X_Step;
//						
//				 else if (tank_bounce_on[i] == 3'b010)
//						Ball_Y_Motion <= (~(Ball_Y_Step) + 1'b1);
//						
//				 else if (tank_bounce_on[i] == 3'b011)
//						Ball_Y_Motion <= Ball_Y_Step;
				 
				 else begin
//					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
				 end
			end //for loop's end			
			
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 //check if x and y position of player is in obstacle, move it out
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
			
		end  
    end
	 
//    always_comb begin
//		  	if (Ball_X_Motion == -1 && Ball_Y_Motion == 0) begin
//				rotation_internal = 3'b001;
//			end
//			else if (Ball_X_Motion == 1 && Ball_Y_Motion == 0) begin
//				rotation_internal = 3'b000;
//			end
//			else if (Ball_X_Motion == 0 && Ball_Y_Motion == 1) begin
//				rotation_internal = 3'b010;
//			end
//			else if (Ball_X_Motion == 0 && Ball_Y_Motion == -1) begin
//				rotation_internal = 3'b011;
//			end
//			else 
//				rotation_internal = 3'b100;
//	 end 
	 
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
   
    assign BallSx = Ballx_Size;
	 
	 assign BallSy = Bally_Size;
	 
	 assign rotation = rotation_internal;
	 
	 assign field1 = fieldOn;
endmodule
//    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion, Ballx_Size,Bally_Size;
//	 logic obstacle_on;
////	 logic [10:0] 
//	 
//    parameter [9:0] Ball_X_Center=320;  // Center position on the X axis
//    parameter [9:0] Ball_Y_Center=240;  // Center position on the Y axis
//    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
//    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
//    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
//    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
//    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
//    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
//
//    assign Ballx_Size = 12;  // assigns the value 4 as a 10-digit binary number, ie "0000000100"
//	 assign Bally_Size = 9;
//    always_ff @ (posedge Reset or posedge frame_clk )
//    begin: Move_Ball
//        if (Reset)  // Asynchronous Reset
//        begin 
//            Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
//				Ball_X_Motion <= 10'd0; //Ball_X_Step;
//				Ball_Y_Pos <= Ball_Y_Center;
//				Ball_X_Pos <= Ball_X_Center - 10'd200;
//        end
//           
//        else 
//        begin 
//				 if ( (Ball_Y_Pos + Bally_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//					  Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);  // 2's complement.
//					  
//				 else if ( (Ball_Y_Pos - Bally_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
//					  Ball_Y_Motion <= Ball_Y_Step;
//					  
//				  else if ( (Ball_X_Pos + Ballx_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
//					  Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);  // 2's complement.
//					  
//				 else if ( (Ball_X_Pos - Ballx_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
//					  Ball_X_Motion <= Ball_X_Step;
//					  
//				 else 
//					  Ball_Y_Motion <= Ball_Y_Motion;  // Ball is somewhere in the middle, don't bounce, just keep moving
//					  
//				 
//				 case (keycode)
//					8'h04 : begin
//
//								Ball_X_Motion <= -1;//A
//								Ball_Y_Motion<= 0;
//								if ( (Ball_X_Pos - Ballx_Size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
//									Ball_X_Motion <= Ball_X_Step;
//							  end		        
//					8'h07 : begin
//								
//					        Ball_X_Motion <= 1;//D
//							  Ball_Y_Motion <= 0;
//							  if ( (Ball_X_Pos + Ballx_Size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
//									Ball_X_Motion <= (~ (Ball_X_Step) + 1'b1);
//							  end
//					8'h16 : begin
//
//					        Ball_Y_Motion <= 1;//S
//							  Ball_X_Motion <= 0;
//							  if ( (Ball_Y_Pos + Bally_Size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//									Ball_Y_Motion <= (~ (Ball_Y_Step) + 1'b1);
//							 end							  
//					8'h1A : begin
//					        Ball_Y_Motion <= -1;//W
//							  Ball_X_Motion <= 0;
//							  if ( (Ball_Y_Pos - Bally_Size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
//									Ball_Y_Motion <= Ball_Y_Step;
//							 end	  
//					default: ;
//			   endcase
//				 
//				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
//				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
//			
//		end  
//    end
//       
//    assign BallX = Ball_X_Pos;
//   
//    assign BallY = Ball_Y_Pos;
//   
//    assign BallSx = Ballx_Size;
//	 
//	 assign BallSy = Bally_Size; 
//    
//endmodule
