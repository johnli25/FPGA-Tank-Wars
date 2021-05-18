module obstacle(input logic [9:0] BallX, BallY, BallSx, BallSy, 
					 input logic [9:0] Ball2X, Ball2Y, Ball2Sx, Ball2Sy,
					 input logic [9:0] BulletX, BulletY, BulletSx, BulletSy,
					 input logic [9:0] Bullet2X, Bullet2Y, Bullet2Sx, Bullet2Sy, 					 
					 input logic [9:0] DrawX, DrawY,
					 input logic field1On, field2On,
//					 input I_flag,
					 output logic obstacle_on,
					 output logic [2:0] bounce_on,
					 output logic [2:0] bounce2_on,
					 
					 output logic [2:0] tank_bounce_on,
					 
					 output logic [2:0] disappear,
					 output logic [2:0] disappear2,
					 
					 output logic [2:0] tank_bullet,
					 output logic [2:0] tank_bullet2
);

//shape = obstacle
	parameter [10:0] shape_x = 10'd310; //default
	parameter [10:0] shape_y = 10'd100;
	parameter [10:0] shape_size_x = 30;
	parameter [10:0] shape_size_y = 30;
	
	parameter [10:0] shape2_size_x = 80; //top rectanges of the "I"
	parameter [10:0] shape2_size_y = 20;	

	assign field1 = field1On;
   assign field2 = field2On;
	
always_comb begin
	if (DrawX >= shape_x && DrawX <= shape_x + shape_size_x 
		 && DrawY >= shape_y && DrawY <= shape_y + shape_size_y)
	begin
		obstacle_on = 1'b1;
	end
	else
		obstacle_on = 1'b0;

end
		
//Ball-Obstacle collision		
always_comb begin
	 if ((BallX + BallSx == shape_x) && ((BallY + BallSy >= shape_y) && (BallY <= shape_y + shape_size_y)))
		  bounce_on = 3'b000;
	 else if ((BallX == shape_x + shape_size_x) && ((BallY + BallSy >= shape_y) && (BallY <= shape_y + shape_size_y)))
		  bounce_on = 3'b001;
	 else if ((BallY + BallSy == shape_y) && ((BallX + BallSx >= shape_x) && (BallX <= shape_x + shape_size_x)))
		  bounce_on = 3'b010;
	 else if ((BallY == shape_y + shape_size_y) && ((BallX + BallSx >= shape_x) && (BallX <= shape_x + shape_size_x)))
		  bounce_on = 3'b011;
	 else if ((BallX + BallSx == Ball2X) && ((BallY + BallSy >= Ball2Y) && (BallY <= Ball2Y + Ball2Sy)))
		  bounce_on = 3'b000;
	 else if ((BallX == Ball2X + Ball2Sx) && ((BallY + BallSy >= Ball2Y) && (BallY <= Ball2Y + Ball2Sy)))
		  bounce_on = 3'b001;
	 else if ((BallY + BallSy == Ball2Y) && ((BallX + BallSx >= Ball2X) && (BallX <= Ball2X + Ball2Sx)))
		  bounce_on = 3'b010;
	 else if ((BallY == Ball2Y + Ball2Sy) && ((BallX + BallSx >= Ball2X) && (BallX <= Ball2X + Ball2Sx)))
		  bounce_on = 3'b011;
		
	 else begin
		  bounce_on = 3'b100;
//		  bounce2_on = 3'b100;
	 end
		  
end

//Ball2-obstacle collision
always_comb begin
	 if ((Ball2X + Ball2Sx == shape_x) && ((Ball2Y + Ball2Sy >= shape_y) && (Ball2Y <= shape_y + shape_size_y)))
		  bounce2_on = 3'b000;
	 else if ((Ball2X == shape_x + shape_size_x) && ((Ball2Y + Ball2Sy >= shape_y) && (Ball2Y <= shape_y + shape_size_y)))
		  bounce2_on = 3'b001;
	 else if ((Ball2Y + Ball2Sy == shape_y) && ((Ball2X + Ball2Sx >= shape_x) && (Ball2X <= shape_x + shape_size_x)))
		  bounce2_on = 3'b010;
	 else if ((Ball2Y == shape_y + shape_size_y) && ((Ball2X + Ball2Sx >= shape_x) && (Ball2X <= shape_x + shape_size_x)))
		  bounce2_on = 3'b011;
	 else if ((Ball2X + Ball2Sx == BallX) && ((Ball2Y + Ball2Sy >= BallY) && (Ball2Y <= BallY + BallSy)))
		  bounce2_on = 3'b000;
	 else if ((Ball2X == BallX + BallSx) && ((Ball2Y + Ball2Sy >= BallY) && (Ball2Y <= BallY + BallSy)))
		  bounce2_on = 3'b001;
	 else if ((Ball2Y + Ball2Sy == BallY) && ((Ball2X + Ball2Sx >= BallX) && (Ball2X <= BallX + BallSx)))
		  bounce2_on = 3'b010;
	 else if ((Ball2Y == BallY + BallSy) && ((Ball2X + Ball2Sx >= BallX) && (Ball2X <= BallX + BallSx)))
		  bounce2_on = 3'b011;		  
	 else begin
//		  bounce_on = 3'b100;
		  bounce2_on = 3'b100;
	 end
end

//always_comb begin
//	 if ((BallX + BallSx == Ball2X) && ((BallY + BallSy >= Ball2Y) && (BallY <= Ball2Y + Ball2Sy)))
//		  bounce_on = 3'b000;
//	 else if ((BallX == Ball2X + Ball2Sx) && ((BallY + BallSy >= Ball2Y) && (BallY <= Ball2Y + Ball2Sy)))
//		  bounce_on = 3'b001;
//	 else if ((BallY + BallSy == Ball2Y) && ((BallX + BallSx >= Ball2X) && (BallX <= Ball2X + Ball2Sx)))
//		  bounce_on = 3'b010;
//	 else if ((BallY == Ball2Y + Ball2Sy) && ((BallX + BallSx >= Ball2X) && (BallX <= Ball2X + Ball2Sx)))
//		  bounce_on = 3'b011;
//		
//	 else begin
//		  bounce_on = 3'b100;
////		  bounce2_on = 3'b100;
//	 end
//		  
//end
//
////Ball2-obstacle collision
//always_comb begin
//	 if ((Ball2X + Ball2Sx == BallX) && ((Ball2Y + Ball2Sy >= BallY) && (Ball2Y <= BallY + BallSy)))
//		  bounce2_on = 3'b000;
//	 else if ((Ball2X == BallX + BallSx) && ((Ball2Y + Ball2Sy >= BallY) && (Ball2Y <= BallY + BallSy)))
//		  bounce2_on = 3'b001;
//	 else if ((Ball2Y + Ball2Sy == BallY) && ((Ball2X + Ball2Sx >= BallX) && (Ball2X <= BallX + BallSx)))
//		  bounce2_on = 3'b010;
//	 else if ((Ball2Y == BallY + BallSy) && ((Ball2X + Ball2Sx >= BallX) && (Ball2X <= BallX + BallSx)))
//		  bounce2_on = 3'b011;
//	 else begin
////		  bounce_on = 3'b100;
//		  bounce2_on = 3'b100;
//	 end
//end

//bullet collision-"disappear"
always_comb begin
	 if ((BulletX + BulletSx >= shape_x) && (BulletX <= shape_x + shape_size_x) && ((BulletY + BulletSy >= shape_y) && (BulletY <= shape_y + shape_size_y)))
			disappear = 3'b000;
	 else if ((BulletX <= shape_x + shape_size_x) && (BulletX >= shape_x) && ((BulletY + BulletSy >= shape_y) && (BulletY <= shape_y + shape_size_y)))
			disappear = 3'b001;	 
	 else if ((BulletY + BulletSy >= shape_y) && (BulletY <= shape_y + shape_size_y) && ((BulletX + BulletSx >= shape_x) && (BulletX <= shape_x + shape_size_x)))
			disappear = 3'b010;	 
	 else if ((BulletY <= shape_y + shape_size_y) && (BulletY >= shape_y) && ((BulletX + BulletSx >= shape_x) && (BulletX <= shape_x + shape_size_x)))
			disappear = 3'b011; 
	 else begin
			disappear = 3'b100;
	 end		  
end

//bullet2 collision-"disappear"
always_comb begin
	 if ((Bullet2X + Bullet2Sx >= shape_x) && (Bullet2X <= shape_x + shape_size_x) && ((Bullet2Y + Bullet2Sy >= shape_y) && (Bullet2Y <= shape_y + shape_size_y)))
			disappear2 = 3'b000;
	 else if ((Bullet2X <= shape_x + shape_size_x) && (Bullet2X >= shape_x) && ((Bullet2Y + Bullet2Sy >= shape_y) && (Bullet2Y <= shape_y + shape_size_y)))
			disappear2 = 3'b001;	 
	 else if ((Bullet2Y + Bullet2Sy >= shape_y) && (Bullet2Y <= shape_y + shape_size_y) && ((Bullet2X + Bullet2Sx >= shape_x) && (Bullet2X <= shape_x + shape_size_x)))
			disappear2 = 3'b010;	 
	 else if ((Bullet2Y <= shape_y + shape_size_y) && (Bullet2Y >= shape_y) && ((Bullet2X + Bullet2Sx >= shape_x) && (Bullet2X <= shape_x + shape_size_x)))
			disappear2 = 3'b011;		
	 else begin
			disappear2 = 3'b100;
	 end		  
end
	
//bullet-tank2	
always_comb begin

	 if ((BulletX + BulletSx >= Ball2X) && (BulletX <= Ball2X + Ball2Sx) && ((BulletY + BulletSy >= Ball2Y) && (BulletY <= Ball2Y + Ball2Sy)))
			 if (field2 == 1'b1)
			 begin
				tank_bullet = 3'b100;
			 end
			 
			 else
			 begin
				tank_bullet = 3'b000;
			 end
	 else if ((BulletX <= Ball2X + Ball2Sx) && (BulletX >= Ball2X) && ((BulletY + BulletSy >= Ball2Y) && (BulletY <= Ball2Y + Ball2Sy)))
			if (field2 == 1'b1)
			 begin
				tank_bullet = 3'b100;
			 end
			 
			 else
			 begin
				tank_bullet = 3'b001;	
			 end
			
			 
	 else if ((BulletY + BulletSy >= Ball2Y) && (BulletY <= Ball2Y + Ball2Sy) && ((BulletX + BulletSx >= Ball2X) && (BulletX <= Ball2X + Ball2Sx)))
			if (field2 == 1'b1)
			 begin
				tank_bullet = 3'b100;
			 end
			 
			 else
			 begin
				tank_bullet = 3'b010;
			 end			 
	 else if ((BulletY <= Ball2Y + Ball2Sy) && (BulletY >= Ball2Y) && ((BulletX + BulletSx >= Ball2X) && (BulletX <= Ball2X + Ball2Sx)))
			if (field2 == 1'b1)
			 begin
				tank_bullet = 3'b100;
			 end
			 
			 else
			 begin
				tank_bullet = 3'b011;
			 end
	 else
	 begin
			tank_bullet = 3'b100;
    end			
end

//bullet2-tank
always_comb begin

		 if ((Bullet2X + Bullet2Sx >= BallX) && (Bullet2X <= BallX + BallSx) && ((Bullet2Y + Bullet2Sy >= BallY) && (Bullet2Y <= BallY + BallSy)))
				if (field1 == 1'b1)
				 begin
					tank_bullet2 = 3'b100;
				 end
				 
				 else
				 begin
					tank_bullet2 = 3'b000;
				 end
		 else if ((Bullet2X <= BallX + BallSx) && (Bullet2X >= BallX) && ((Bullet2Y + Bullet2Sy >= BallY) && (Bullet2Y <= BallY + BallSy)))
				if (field1 == 1'b1)
				 begin
					tank_bullet2 = 3'b100;
				 end
				 
				 else
				 begin
					tank_bullet2 = 3'b001;
				 end	 
		 else if ((Bullet2Y + Bullet2Sy >= BallY) && (Bullet2Y <= BallY + BallSy) && ((Bullet2X + Bullet2Sx >= BallX) && (Bullet2X <= BallX + BallSx)))
				if (field1 == 1'b1)
				 begin
					tank_bullet2 = 3'b100;
				 end
				 
				 else
				 begin
					tank_bullet2 = 3'b010;	 
				 end	 
		 else if ((Bullet2Y <= BallY + BallSy) && (Bullet2Y >= BallY) && ((Bullet2X + Bullet2Sx >= BallX) && (Bullet2X <= BallX + BallSx)))
				if (field1 == 1'b1)
				 begin
					tank_bullet2 = 3'b100;
				 end
				 
				 else
				 begin
					tank_bullet2 = 3'b011; 
				 end	 
		 else
		 begin
				tank_bullet2 = 3'b100;
		end

end

//end
//
///*TOP AND BOTTOM RECTANGLES OF ILLINI "I"*/
////draw
//else begin //if I_flag == 0 or shape_x != 280
//always_comb begin
//	if (DrawX >= shape && DrawX <= shape_x + shape2_size_x 
//		 && DrawY >= shape_y && DrawY <= shape_y + shape2_size_y)
//	begin
//		obstacle_on = 1'b1;
//	end
//	else
//		obstacle_on = 1'b0;
//
//end
//		
////Ball-Obstacle collision		
//always_comb begin
//	 if ((BallX + BallSx == shape_2) && ((BallY + BallSy >= shape_y) && (BallY <= shape_y + shape2_size_y)))
//		  bounce_on = 3'b000;
//	 else if ((BallX == shape_x + shape2_size_x) && ((BallY + BallSy >= shape_y) && (BallY <= shape_y + shape2_size_y)))
//		  bounce_on = 3'b001;
//	 else if ((BallY + BallSy == shape_y) && ((BallX + BallSx >= shape_x) && (BallX <= shape_x + shape2_size_x)))
//		  bounce_on = 3'b010;
//	 else if ((BallY == shape_y + shape2_size_y) && ((BallX + BallSx >= shape_x) && (BallX <= shape_x + shape2_size_x)))
//		  bounce_on = 3'b011;
//		
//	 else begin
//		  bounce_on = 3'b100;
////		  bounce2_on = 3'b100;
//	 end
//		  
//end
//
////Ball2-obstacle collision
//always_comb begin
//	 if ((Ball2X + Ball2Sx == shape_x) && ((Ball2Y + Ball2Sy >= shape_y) && (Ball2Y <= shape_y + shape2_size_y)))
//		  bounce2_on = 3'b000;
//	 else if ((Ball2X == shape_x + shape2_size_x) && ((Ball2Y + Ball2Sy >= shape_y) && (Ball2Y <= shape_y + shape2_size_y)))
//		  bounce2_on = 3'b001;
//	 else if ((Ball2Y + Ball2Sy == shape_y) && ((Ball2X + Ball2Sx >= shape_x) && (Ball2X <= shape_x + shape2_size_x)))
//		  bounce2_on = 3'b010;
//	 else if ((Ball2Y == shape_y + shape2_size_y) && ((Ball2X + Ball2Sx >= shape_x) && (Ball2X <= shape_x + shape2_size_x)))
//		  bounce2_on = 3'b011;
//	 else begin
////		  bounce_on = 3'b100;
//		  bounce2_on = 3'b100;
//	 end
//end
//
////bullet collision-"disappear"
//always_comb begin
//	 if ((BulletX + BulletSx >= shape_x) && (BulletX <= shape_x + shape2_size_x) && ((BulletY + BulletSy >= shape_y) && (BulletY <= shape_y + shape2_size_y)))
//			disappear = 3'b000;
//	 else if ((BulletX <= shape_x + shape2_size_x) && (BulletX >= shape_x) && ((BulletY + BulletSy >= shape_y) && (BulletY <= shape_y + shape2_size_y)))
//			disappear = 3'b001;	 
//	 else if ((BulletY + BulletSy >= shape_y) && (BulletY <= shape_y + shape2_size_y) && ((BulletX + BulletSx >= shape_x) && (BulletX <= shape_x + shape2_size_x)))
//			disappear = 3'b010;	 
//	 else if ((BulletY <= shape_y + shape2_size_y) && (BulletY >= shape_y) && ((BulletX + BulletSx >= shape_x) && (BulletX <= shape_x + shape2_size_x)))
//			disappear = 3'b011; 
//	 else begin
//			disappear = 3'b100;
//	 end		  
//end
//
////bullet2 collision-"disappear"
//always_comb begin
//	 if ((Bullet2X + Bullet2Sx >= shape_x) && (Bullet2X <= shape_x + shape2_size_x) && ((Bullet2Y + Bullet2Sy >= shape_y) && (Bullet2Y <= shape_y + shape2_size_y)))
//			disappear2 = 3'b000;
//	 else if ((Bullet2X <= shape_x + shape2_size_x) && (Bullet2X >= shape_x) && ((Bullet2Y + Bullet2Sy >= shape_y) && (Bullet2Y <= shape_y + shape2_size_y)))
//			disappear2 = 3'b001;	 
//	 else if ((Bullet2Y + Bullet2Sy >= shape_y) && (Bullet2Y <= shape_y + shape2_size_y) && ((Bullet2X + Bullet2Sx >= shape_x) && (Bullet2X <= shape_x + shape2_size_x)))
//			disappear2 = 3'b010;	 
//	 else if ((Bullet2Y <= shape_y + shape2_size_y) && (Bullet2Y >= shape_y) && ((Bullet2X + Bullet2Sx >= shape_x) && (Bullet2X <= shape_x + shape2_size_x)))
//			disappear2 = 3'b011;		
//	 else begin
//			disappear2 = 3'b100;
//	 end		  
//end
//	
////bullet-tank2	
//always_comb begin
//	 if ((BulletX + BulletSx >= Ball2X) && (BulletX <= Ball2X + Ball2Sx) && ((BulletY + BulletSy >= Ball2Y) && (BulletY <= Ball2Y + Ball2Sy)))
//			tank_bullet = 3'b000;
//	 else if ((BulletX <= Ball2X + Ball2Sx) && (BulletX >= Ball2X) && ((BulletY + BulletSy >= Ball2Y) && (BulletY <= Ball2Y + Ball2Sy)))
//			tank_bullet = 3'b001;	 
//	 else if ((BulletY + BulletSy >= Ball2Y) && (BulletY <= Ball2Y + Ball2Sy) && ((BulletX + BulletSx >= Ball2X) && (BulletX <= Ball2X + Ball2Sx)))
//			tank_bullet = 3'b010;	 
//	 else if ((BulletY <= Ball2Y + Ball2Sy) && (BulletY >= Ball2Y) && ((BulletX + BulletSx >= Ball2X) && (BulletX <= Ball2X + Ball2Sx)))
//			tank_bullet = 3'b011;	
//	 else
//			tank_bullet = 3'b100;			
//end
//
////bullet2-tank
//always_comb begin
//	 if ((Bullet2X + Bullet2Sx >= BallX) && (Bullet2X <= BallX + BallSx) && ((Bullet2Y + Bullet2Sy >= BallY) && (Bullet2Y <= BallY + BallSy)))
//			tank_bullet2 = 3'b000;
//	 else if ((Bullet2X <= BallX + BallSx) && (Bullet2X >= BallX) && ((Bullet2Y + Bullet2Sy >= BallY) && (Bullet2Y <= BallY + BallSy)))
//			tank_bullet2 = 3'b001;	 
//	 else if ((Bullet2Y + Bullet2Sy >= BallY) && (Bullet2Y <= BallY + BallSy) && ((Bullet2X + Bullet2Sx >= BallX) && (Bullet2X <= BallX + BallSx)))
//			tank_bullet2 = 3'b010;	 
//	 else if ((Bullet2Y <= BallY + BallSy) && (Bullet2Y >= BallY) && ((Bullet2X + Bullet2Sx >= BallX) && (Bullet2X <= BallX + BallSx)))
//			tank_bullet2 = 3'b011;	
//	 else
//			tank_bullet2 = 3'b100;			
//end
//  
endmodule