//        8'b00000000, // 0
//        8'b00000000, // 1
//        8'b00000000, // 2
//        8'b00000000, // 3
//        8'b00000000, // 4
//        8'b11000110, // 5 **   **
//        8'b11000110, // 6 **   **
//        8'b11000110, // 7 **   **
//        8'b11000110, // 8 **   **
//        8'b11000110, // 9 **   **
//        8'b11000110, // a **   **
//        8'b01111110, // b  ******
//        8'b00000110, // c      **
//        8'b00001100, // d     **
//        8'b11111000, // e *****
//        8'b00000000, // f
//    always_ff @ (posedge Reset or posedge frame_clk )
//    begin: Move_bullet2
//        if (Reset)  // Asynchronous Reset
//        begin 
//            bullet2_Y_Motion <= 10'd0; //bullet2_Y_Step;
//				bullet2_X_Motion <= 10'd0; //bullet2_X_Step;
//				bullet2_Y_Pos <= ballX;
//				bullet2_X_Pos <= ballY;
//				flag = 1'b0;
//        end
//        
//        else 
//        begin 		 
//				 case (keycode)
//				 
//				 8'h28 : begin //enter
//							  //declare bullet2 here
//							  bullet2_Y_Motion <= -7; //20
//							  bullet2_on = 1'b1;
//							  bullet2_Y_Pos <= (ballY);  // Update bullet2 position, have it move up everytime
//							  bullet2_X_Pos <= (ballX);
//							  flag <= 1'b0;  
//						   end
//							  
//			    default: 
//				 begin
//					if ((bullet2_Y_Pos - bullet2y_Size) <= bullet2_Y_Min + 10'd9)  // bullet2 is at the top edge, BOUNCE!
//					  begin
//						bullet2_Y_Pos <= (ballY-20);  // Update bullet2 position, have it move up everytime
//						bullet2_X_Pos <= (ballX);
//						bullet2_Y_Motion <= 0;
//						bullet2_on = 1'b0;
//						flag <= 1'b1;
//						
//					  end
//					else
//					  begin
//					  
//					   if (flag == 1'b1) //"hiding" condition
//							begin
//							bullet2_on = 1'b0;
//							bullet2_Y_Pos <= (ballY-20);  // Update bullet2 position, have it move up everytime
//							bullet2_X_Pos <= (ballX);
//							bullet2_Y_Motion = 0;
//							end
//						
//						else
//							begin
//							bullet2_Y_Pos <= (bullet2_Y_Pos + bullet2_Y_Motion);
//							bullet2_on = 1'b1;
//							end
//					 end
//				 end
//			    endcase	 
//							  
//		end  
//    end

 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	  
//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;
//	  
//    always_comb
//    begin:Ball_on_proc
//        if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
//            ball_on = 1'b1;
//        else 
//            ball_on = 1'b0;
//     end 
//       
//    always_comb
//    begin:RGB_Display
//        if ((ball_on == 1'b1)) 
//        begin 
//            Red = 8'hff;
//            Green = 8'h55;
//            Blue = 8'h00;
//        end       
//        else 
//        begin 
//            Red = 8'h00; 
//            Green = 8'h00;
//            Blue = 8'h7f - DrawX[9:3];
//        end      
//    end 
//    
//endmodule

 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))
		 
		 
  if ( ( DistX*DistX + DistY*DistY) <= (Size * Size) ) 
            ball_on = 1'b1;
        else 
            ball_on = 1'b0;
				
	
     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). 
	 */
//    int DistX, DistY, Size;
//	 assign DistX = DrawX - BallX;
//    assign DistY = DrawY - BallY;
//    assign Size = Ball_size;