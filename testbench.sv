//module testbench();
//
//timeunit 10ns;
//
//timeprecision 1ns;
//
//logic [9:0] BallX, BallY, DrawX, DrawY, Ball_sizex, Ball_sizey;
//logic [9:0] Ball2X, Ball2Y, Ball2_sizex, Ball2_sizey;
//logic [9:0] BulletX, BulletY, Bullet_sizex, Bullet_sizey;
//logic [9:0] Bullet2X, Bullet2Y, Bullet2_sizex, Bullet2_sizey;
//
//logic [5:0] obstacle_on;
//logic [1:0] bulletOn;
//logic [1:0] bullet2On;
//logic [2:0] rotation;
//logic [2:0] rotation2; 
//logic [2:0] heart1_display;
//logic [2:0] heart2_display;
//
//logic go;
//logic go2;
//logic blank;
//
//logic heart_showup;
//
//logic [7:0] Red, Green, Blue;
////initial begin: CLOCK_INITIALIZATION
////	frame_clk = 0;
////end
//
//color_mapper b0(.*);
//
//initial begin
//	go = 0;
////	BallX
////	BallY 
////	DrawX 
////	DrawY
////	Ball_sizex
////	Ball_sizey
////	Ball2X, Ball2Y, Ball2_sizex, Ball2_sizey;
////	BulletX, BulletY, Bullet_sizex, Bullet_sizey;
////	Bullet2X, Bullet2Y, Bullet2_sizex, Bullet2_sizey;
//	
//#2 go = 1;
//
//#10 go = 0;
//	
//end
//
//endmodule
////module testbench();
////
////timeunit 10ns;
////
////timeprecision 1ns;
////
////logic Reset;
////logic frame_clk = 0;
////logic [9:0] ballX;
////logic [9:0] ballY;
////logic [7:0] keycode;
////logic [5:0] disappear/*[5:0]*/;
////logic [9:0] bulletX;
////logic [9:0] bulletY; 
////logic [9:0] bulletSx; 
////logic [9:0] bulletSy;
////logic [1:0] bulletOn;
////
////always begin: CLOCK_GENERATION
////#1 frame_clk = ~frame_clk;
////end
////
////initial begin: CLOCK_INITIALIZATION
////	frame_clk = 0;
////end
////
////bullet b0(.*);
////
////initial begin
////	Reset = 1'b1;
////	ballX = 10'b0;
////	ballY = 10'b0;
////	keycode = 8'b0;
////	disappear = 6'b0;
////	bulletX = 10'b0;
////	bulletY = 10'b0;
////	bulletSx = 10'b0;
////	bulletSy = 10'b0;
////	bulletOn = 2'b0;	
////	
////#2	disappear = 6'b0;
////	
////#2	disappear = 6'b1;
////	
////#2	Reset = 1'b0;
////	
////end
////
////endmodule 