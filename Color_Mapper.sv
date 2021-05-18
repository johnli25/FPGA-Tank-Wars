//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

//NOTE: Ball_size refers to the x
module  color_mapper ( input Clk,
							  input [9:0] BallX, BallY, DrawX, DrawY, Ball_sizex, Ball_sizey,
							  input [9:0] Ball2X, Ball2Y, Ball2_sizex, Ball2_sizey,
							  input [9:0] BulletX, BulletY, Bullet_sizex, Bullet_sizey,
							  input [9:0] Bullet2X, Bullet2Y, Bullet2_sizex, Bullet2_sizey,

							  input logic [12:0] obstacle_on,
							  input [1:0] bulletOn,
							  input [1:0] bullet2On,
							  input [2:0] rotation,
							  input [2:0] rotation2, 
							  input logic [2:0] heart1_display, heart2_display,
							  input logic go, go2, //game_over_displays
							  input logic heart_showup,
							  input logic blank,
							  input logic shot1Hit,
							  input logic shot2Hit,
							  input logic field1On,
							  input logic field2On,
							  output logic tank_powerup,
                       output logic [7:0]  Red, Green, Blue);
							  
	 logic obstacle2_on;
	 logic tank_on;
	 logic bullet_on;
	 
	 logic tank2_on;
	 logic bullet2_on;
	 
	 logic shape_on;
	 logic [10:0] shape_x = 100;
	 logic [10:0] shape_y = 400;
	 logic [10:0] shape_size_x = 20;
	 logic [10:0] shape_size_y = 20;
	 
	 logic[2:0] heart1_on; 
	 logic[2:0] heart6_on;
	 
	 logic [3:0] end_screen;

	logic [10:0] sprite_addr;
	logic [15:0] sprite_data;
	
	logic [10:0] sprite2_addr;
	logic [15:0] sprite2_data;
	
	logic [10:0] sprite3_addr; //hearts player 1
	logic [15:0] sprite3_data;	
	
	logic [10:0] sprite4_addr; //hearts player 2
	logic [15:0] sprite4_data;	
	
	logic [10:0] sprite5_addr; //end screen text
	logic [15:0] sprite5_data;

	logic heart_powerup_rgb;
	
	font_rom fr1(.addr(sprite_addr), .data(sprite_data));
	font_rom fr2(.addr(sprite2_addr), .data(sprite2_data));	
	
	font_rom heart(.addr(sprite3_addr), .data(sprite3_data));	 		
	font_rom heart2(.addr(sprite4_addr), .data(sprite4_data));	

	font_rom fr5(.addr(sprite5_addr), .data(sprite5_data)); //endscreen

//	logic [23:0] backgroundRAM_data;
//	background_frameRAM background_color_data(.DrawX(DrawX),
//								.DrawY(DrawY),
//								.Clk(Clk),
//								.data_out(backgroundRAM_data)
//								);

	always_comb
	begin: Tank_on_proc //tank1
		if (rotation == 3'b011 && DrawX >= BallX && DrawX < BallX + Ball_sizex && DrawY >= BallY && DrawY < BallY + Ball_sizey)
		begin
			tank_on = 1'b1;
			bullet_on = 1'b0;
//			heart1_on = 1'b0;
			sprite_addr = (DrawY-BallY + 16*'h7f); //up
		end
		else if (rotation == 3'b001 && DrawX >= BallX && DrawX < BallX + Ball_sizex && DrawY >= BallY && DrawY < BallY + Ball_sizey)
		begin
			tank_on = 1'b1;
			bullet_on = 1'b0;
//			heart1_on = 1'b0;			
			sprite_addr = (DrawY-BallY + 16*'h7e);//right
		end
		else if (rotation == 3'b010 && DrawX >= BallX && DrawX < BallX + Ball_sizex && DrawY >= BallY && DrawY < BallY + Ball_sizey)
		begin
			tank_on = 1'b1;
			bullet_on = 1'b0;
//			heart1_on = 1'b0;
			sprite_addr = (DrawY-BallY + 16*'h7d); //down
		end	
		else if (rotation == 3'b000 && DrawX >= BallX && DrawX < BallX + Ball_sizex && DrawY >= BallY && DrawY < BallY + Ball_sizey)
		begin
			tank_on = 1'b1;
			bullet_on = 1'b0;
//			heart1_on = 1'b0;			
			sprite_addr = (DrawY-BallY + 16*'h7c); //left
		end			
		else if (DrawX >= BulletX && DrawX < BulletX + Bullet_sizex && DrawY >= BulletY && DrawY < BulletY + Bullet_sizey && bulletOn)
		begin
			bullet_on = 1'b1;
			tank_on = 1'b0;
//			heart1_on = 1'b0;
			sprite_addr = 10'b0;
		end
		else
		begin
			tank_on = 1'b0;
			bullet_on = 1'b0;
//			heart1_on = 1'b0;
			sprite_addr = 10'b0;
		end
	end    

always_comb
begin: Tank2_on_proc
	if (rotation2 == 3'b011 && DrawX >= Ball2X && DrawX <= Ball2X + Ball2_sizex && DrawY >= Ball2Y && DrawY <= Ball2Y + Ball2_sizey)
	begin
		tank2_on = 1'b1;
		bullet2_on = 1'b0;
		sprite2_addr = (DrawY-Ball2Y + 16*'h7f);
	end
	else if (rotation2 == 3'b001 && DrawX >= Ball2X && DrawX < Ball2X + Ball_sizex && DrawY >= Ball2Y && DrawY < Ball2Y + Ball2_sizey)
	begin
		tank2_on = 1'b1;
		bullet2_on = 1'b0;
		sprite2_addr = (DrawY-Ball2Y + 16*'h7e);//right
	end
	else if (rotation2 == 3'b010 && DrawX >= Ball2X && DrawX < Ball2X + Ball2_sizex && DrawY >= Ball2Y && DrawY < Ball2Y + Ball2_sizey)
	begin
		tank2_on = 1'b1;
		bullet2_on = 1'b0;
		sprite2_addr = (DrawY-Ball2Y + 16*'h7d); //down
	end	
	else if (rotation2 == 3'b000 && DrawX >= Ball2X && DrawX < Ball2X + Ball2_sizex && DrawY >= Ball2Y && DrawY < Ball2Y + Ball2_sizey)
	begin
		tank2_on = 1'b1;
		bullet2_on = 1'b0;
		sprite2_addr = (DrawY-Ball2Y + 16*'h7c); //left
	end	
	else if (DrawX >= Bullet2X && DrawX < Bullet2X + Bullet2_sizex && DrawY >= Bullet2Y && DrawY < Bullet2Y + Bullet2_sizey && bullet2On)
	begin
		bullet2_on = 1'b1;
		tank2_on = 1'b0;
		sprite2_addr = 10'b0;
	end
	else
	begin
		tank2_on = 1'b0;
		bullet2_on = 1'b0;
		sprite2_addr = 10'b0;
	end
end   

/*player 1 lives */
always_comb begin: player_1_lives
		if (DrawX >= 100 && DrawX <= 115 && DrawY >= 440 && DrawY <= 455) begin
			heart6_on = 3'b001;	
			
			sprite4_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
		end
		else if (DrawX >= 120 && DrawX <= 135 && DrawY >= 440 && DrawY <= 455) begin
			heart6_on = 3'b010;			
			sprite4_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 
		end
		else if (DrawX >= 140 && DrawX <= 155 && DrawY >= 440 && DrawY <= 455) begin
			heart6_on = 3'b011;				
			sprite4_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite
		end
		else if (DrawX >= 160 && DrawX <= 175 && DrawY >= 440 && DrawY <= 455) begin
			heart6_on = 3'b100;	
			
			sprite4_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 
		end	
		else if (DrawX >= 180 && DrawX <= 195 && DrawY >= 440 && DrawY <= 455) begin
			heart6_on = 3'b101;	

			sprite4_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
		end
		else begin
			heart6_on = 3'b000;
		
			sprite4_addr = 10'b0;		
		end
end

/*player_2 lives*/
always_comb begin
	if (DrawX >= 420 && DrawX <= 435 && DrawY >= 440 && DrawY <= 455) begin
		heart1_on = 3'b001;		
		sprite3_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
	end
	else if (DrawX >= 440 && DrawX <= 455 && DrawY >= 440 && DrawY <= 455) begin
		heart1_on = 3'b010;		
		sprite3_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
	end	
	else if (DrawX >= 460 && DrawX <= 475 && DrawY >= 440 && DrawY <= 455) begin
		heart1_on = 3'b011;		
		sprite3_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
	end
	else if (DrawX >= 480 && DrawX <= 495 && DrawY >= 440 && DrawY <= 455) begin
		heart1_on = 3'b100;		
		sprite3_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
	end
	else if (DrawX >= 500 && DrawX <= 515 && DrawY >= 440 && DrawY <= 455) begin
		heart1_on = 3'b101;		
		sprite3_addr = (DrawY - 10'd440 + 16*'h7b); //heart sprite 				
	end	
	else begin
		heart1_on = 3'b000;
		sprite3_addr = 10'b0;	
	end
end

always_comb begin: game_over_screen //HEX letters
	if ((go || go2) && DrawX >= 290 && DrawX <= 305 && DrawY >= 240 && DrawY <= 255) begin
		end_screen = 4'd1;		
		sprite5_addr = (DrawY - 10'd240 + 16*'h77); //p			
	end
	else if ((go || go2) && DrawX >= 310 && DrawX <= 325 && DrawY >= 240 && DrawY <= 255) begin
		end_screen = 4'd2;		
		sprite5_addr = (DrawY - 10'd240 + 16*'h78); //z				
	end
	else if ((go || go2) && DrawX >= 330 && DrawX <= 345 && DrawY >= 240 && DrawY <= 255) begin
		end_screen = 4'd3;		
		sprite5_addr = (DrawY - 10'd240 + 16*'h79); //heart sprite //61 				
	end
	else if ((go || go2) && DrawX >= 350 && DrawX <= 365 && DrawY >= 240 && DrawY <= 255) begin
		end_screen = 4'd4;		
		sprite5_addr = (DrawY - 10'd240 + 16*'h7a); //heart sprite 				
	end
	
	else if (go && DrawX >= 312 && DrawX <= 327 && DrawY >= 220 && DrawY <= 237) begin
		end_screen = 4'd5;		
		sprite5_addr = (DrawY - 10'd220 + 16*'h7f); //heart sprite 				
	end
	else if (go2 && DrawX >= 312 && DrawX <= 327 && DrawY >= 220 && DrawY <= 237) begin
		end_screen = 4'd6;		
		sprite5_addr = (DrawY - 10'd220 + 16*'h7f); //heart sprite 				
	end
	else begin
		end_screen = 4'd0;
		sprite5_addr = 10'b0;	
	end
	
end	

//always_comb begin: health_powerup_draw //draws the powerup
//	if (heart_showup && DrawX >= 310 && DrawX <= 325 && DrawY >= 150 && DrawY <= 165) 
//		heart_powerup_rgb = 1'b1;
//	else
//		heart_powerup_rgb = 1'b0;
//end
//
//always_comb begin: tank_health_powerup_interaction //interaction between tank-health up
//  if (tank_on && heart_powerup_rgb) begin
//	tank_powerup = 2'd1;
//  end
//  else if (tank2_on && heart_powerup_rgb) begin
//	tank_powerup = 2'd2;	  
//  end	
//  else 
//	tank_powerup = 2'd0;
//end

always_comb
begin:RGB_Display
	 if (go || go2) begin 
		  if (~blank) begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;		  
		  end		  
		  else if (end_screen == 1 && sprite5_data[305-DrawX]) begin
				Red = 8'hfe;
				Green = 8'hfe;
				Blue = 8'hfe;			
		  end
		  else if (end_screen == 2 && sprite5_data[325-DrawX]) begin
				Red = 8'hfe;
				Green = 8'hfe;
				Blue = 8'hfe;			
		  end 
		  else if (end_screen == 3 && sprite5_data[345-DrawX]) begin
				Red = 8'hfe;
				Green = 8'hfe;
				Blue = 8'hfe;			
		  end 
		  else if (end_screen == 4 && sprite5_data[365-DrawX]) begin
				Red = 8'hfe;
				Green = 8'hfe;
				Blue = 8'hfe;			
		  end 
/*player # wins */ 		  
		  else if (end_screen == 5 && sprite5_data[327-DrawX]) begin
				Red = 8'hff;
				Green = 8'h55;
				Blue = 8'h00;		
		  end 
		  else if (end_screen == 6 && sprite5_data[327-DrawX]) begin
				Red = 8'd43;
				Green = 8'd165;
				Blue = 8'd88;		
		  end 
		  else begin // background
//		  		Red = backgroundRAM_data[23:16];
//				Green = backgroundRAM_data[15:8];
//				Blue = backgroundRAM_data[7:0];
				Red = 8'h00; 
				Green = 8'h00;
				Blue = 8'd96; //128				  
		  end
	 end
		  
	 else begin //if go == 0
	  
		  if (!end_screen && (tank_on == 1'b1) && sprite_data[DrawX-BallX] == 1'b1)  
		  begin
				//if (shot2Hit == 1'b1)
				//begin
					//Red = 8'hfe;
					//Green = 8'hfe;
					//Blue = 8'hfe;
				//end
				//else 
				if (field1On == 1'b1)
			   begin
					Red = 8'h00;
					Green = 8'h55;
					Blue = 8'hff;
				end
				else if (shot2Hit == 1'b1)
				begin
					Red = 8'hfe; 
					Green = 8'hfe;
					Blue = 8'hfe;
				end
				
				else
				begin
					Red = 8'hff;
					Green = 8'h55;
					Blue = 8'h00;
				end
		  end  
		  else if (!end_screen && (tank2_on == 1'b1) && sprite2_data[DrawX-Ball2X] == 1'b1)  
		  begin
				//if (shot1Hit == 1'b1)
				//begin
					//Red = 8'hfe; //green
					//Green = 8'hfe;
					//Blue = 8'hfe;
				//end
				//else
				if (field2On == 1'b1)
			   begin
					Red = 8'h00;
					Green = 8'h55;
					Blue = 8'hff;
				end
				
				else if (shot1Hit == 1'b1)
				begin
					Red = 8'hfe; 
					Green = 8'hfe;
					Blue = 8'hfe;
				end
				else
				begin
					Red = 8'd43; 
					Green = 8'd165;
					Blue = 8'd88;
				end
		  end	  
		  else if (!end_screen && (obstacle_on[0] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd255;
				Blue = 8'd50;
		  end
		  else if (!end_screen && (obstacle_on[1] == 1'b1))
		  begin
				Red = 8'd105;
				Green = 8'd246;
				Blue = 8'd255;
		  end
		  else if ((obstacle_on[2] == 1'b1))
		  begin
				Red = 8'd138;
				Green = 8'd253;
				Blue = 8'd180;
		  end
		  else if ((obstacle_on[3] == 1'b1))
		  begin
				Red = 8'd95;
				Green = 8'd84;
				Blue = 8'd188;
		  end
		  else if ((obstacle_on[4] == 1'b1))
		  begin
				Red = 8'hfe;
				Green = 8'hfe;
				Blue = 8'hfe; //128
		  end	
		  else if ((obstacle_on[5] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end	
		  else if ((obstacle_on[6] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end	
		  else if ((obstacle_on[7] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end	 	
		  else if ((obstacle_on[8] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end
		  else if ((obstacle_on[9] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end	 	 
		  else if ((obstacle_on[10] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end	 	 
		  else if ((obstacle_on[11] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end	
		  else if ((obstacle_on[12] == 1'b1))
		  begin
				Red = 8'd255;
				Green = 8'd153;
				Blue = 8'd50;
		  end			  
		  else if ((bullet_on == 1'b1)) 
		  begin 
				Red = 8'hff;
				Green = 8'haa;
				Blue = 8'h00;
		  end
		  else if ((bullet2_on == 1'b1)) 
		  begin 
				Red = 8'd43; //green
				Green = 8'd165;
				Blue = 8'd88;
		  end	  
		  else if (heart2_display >= 0 && heart6_on == 3'b001 && (sprite4_data[DrawX - 100])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end	  
		  else if (heart2_display >= 1 && heart6_on == 3'b010 && (sprite4_data[DrawX - 120])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end
		  else if (heart2_display >= 2 && heart6_on == 3'b011 && (sprite4_data[DrawX - 140])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end	  
		  else if (heart2_display >= 3 && !end_screen && heart6_on == 3'b100 && (sprite4_data[DrawX - 160])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end
		  
		  else if (heart2_display >= 4 && !end_screen && heart6_on == 3'b101 && (sprite4_data[DrawX - 180])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end	
		  else if (heart1_display >= 0 && heart1_on == 3'b001 && (sprite3_data[DrawX - 420])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end	  
		  else if (heart1_display >= 1 && heart1_on == 3'b010 && (sprite3_data[DrawX - 440])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end
		  else if (heart1_display >= 2 && heart1_on == 3'b011 && (sprite3_data[DrawX - 460])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end	  
		  else if (heart1_display >= 3 && heart1_on == 3'b100 && (sprite3_data[DrawX - 480])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end
//		  else if () begin //bottom border for hearts
//		  end		  
		  else if (heart1_display >= 4 && heart1_on == 3'b101 && (sprite3_data[DrawX - 500])) // || sprite3_data[DrawX - 120] || sprite3_data[DrawX - 140] || sprite3_data[DrawX - 160] || sprite3_data[DrawX - 180]))
		  begin
				Red = 8'd255;
				Green = 8'd75;
				Blue = 8'd112;
		  end		  
		  else if (~blank) begin
				Red = 8'h00;
				Green = 8'h00;
				Blue = 8'h00;		  
		  end			  
		  else 
		  begin 
//		  		Red = backgroundRAM_data[23:16];
//				Green = backgroundRAM_data[15:8];
//				Blue = backgroundRAM_data[7:0];
				Red = 8'h00; 
				Green = 8'h00;
				Blue = 8'h80; 		
		  end 

	end //overarching else end
	
 end
    
endmodule
