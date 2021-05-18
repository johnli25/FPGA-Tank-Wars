module game_sm(input logic frame_clk,
					input logic Reset,
					
					input logic shot_hit1,
					input logic shot_hit2,
					input logic tank_powerup,
					input logic [31:0] keycode, 
					output logic [2:0] heart1_display,
					output logic [2:0] heart2_display,
					output logic game_over_display, game_over_display2, heart_showup);

enum logic [4:0] {
WAIT,
START,
DONE,
DONE2,
PLAY, //move, shoot, etc.
TANK1_BULLET,
TANK2_BULLET
//HEART_SHOW,
//HEART_UPGRADE
//TANK1_LIFE,
//TANK2_LIFE,
} state, next_state;

logic [2:0] count;
logic [2:0] next_count;

logic [2:0] count2;
logic [2:0] next_count2;

logic heart_up_reg; 
logic next_heart_up_reg;

always_ff @ (posedge frame_clk) begin
	if (Reset) begin
		state <= START; 
		count <= 3'd0;
		count2 <= 3'd0;
		heart_up_reg <= 1'b0;
//		heart1_display <= 3'd4;
//		heart2_display <= 3'd4;
//		heart1_display <= 3'b0;
//		heart2_display <= 3'b0;
//		game_over_display <= 1'b0;
	end
	else begin
		state <= next_state;
		count <= next_count;
		count2 <= next_count2;
		heart_up_reg <= next_heart_up_reg;
	end
end

always_comb begin
	next_count = count;
	next_count2 = count2;	
	heart1_display = count; //or 5?
	heart2_display = count2;
	game_over_display = 1'b0;
	game_over_display2 = 1'b0;
	
	next_heart_up_reg = heart_up_reg;
	heart_showup = heart_up_reg;

	case(state)
	
	START: begin 
		next_count = 3'd4;
		next_count2 = 3'd4;	
		heart1_display = 3'd4;
		heart2_display = 3'd4;
		game_over_display = 1'b0;
		game_over_display2 = 1'b0;
		next_heart_up_reg = 1'b0;
		heart_showup = 1'b0;
		
		next_state = PLAY;		
	end

	PLAY: begin

		if (shot_hit1 == 1'b1) 
			next_state = TANK1_BULLET;
			
		else if (shot_hit2 == 1'b1) begin
			next_state = TANK2_BULLET;		
		end

//		else if (count + count2 <= 5 && tank_powerup == 2'b0) begin //when it was set to 6, it was 8 lmao
//			heart_showup = 1'b1;
//			next_heart_up_reg = 1'b1;
//			next_state = HEART_SHOW;
//		end
//		else if (tank_powerup != 0) begin
//			next_state = HEART_UPGRADE;
//		end		
		else 
			next_state = PLAY; 		
	end
	
	TANK1_BULLET: begin
//		heart_showup = 1'b1;
//		if (count + count2 <= 5 && tank_powerup == 2'b0)
//			heart_showup = 1'b1;
//		next_heart_up_reg = heart_up_reg;
		next_count = count - 3'd1;
//		shot_hit1 = 1'b0; //can I do this?
//		heart1_display = next_count; //turns 1 one heart off or black 

		if (count == 3'd0)
			next_state = DONE;
		else 
			next_state = PLAY;
	
	end   
	
	TANK2_BULLET: begin
//		if (count + count2 <= 5 && tank_powerup == 2'b0)
//			heart_showup = 1'b1;
//		next_heart_up_reg = heart_up_reg;
		next_count2 = count2 - 3'd1;
//		heart2_display = next_count2; //turns 1 one heart off or black 
		if (count2 == 3'd0)
			next_state = DONE2;
		else 
			next_state = PLAY;	
	
	end
	
//	HEART_SHOW: begin //temp-wait state
//		next_heart_up_reg = heart_up_reg;
//		next_heart_up_reg = 1'b1;
//		heart_showup = 1'b1;
//		next_state = PLAY;		
//	end
	
//	HEART_UPGRADE: begin
//		if (tank_powerup == 2'd2)
//			next_count2 = count2 + 3'd1;
//		else if (tank_powerup == 2'd1) begin
//			next_count = count + 3'd1;				
//		end	
//		heart_showup = 1'b0;		
//		next_state = PLAY;
//	end
	
	DONE: begin
		game_over_display = 1'b1; //color mapper: game over-end screen
		if (keycode == 8'h0A) //keycode
			next_state = START;
		else 
			next_state = DONE;	
	end
	
	DONE2: begin
		game_over_display2 = 1'b1; //color mapper: game over-end screen
		if (keycode == 8'h0A) //keycode
			next_state = START;
		else 
			next_state = DONE2;			
	end
	
	default: begin
		heart1_display = 3'b0; //or 5?
		heart2_display = 3'b0;
		game_over_display = 1'b0;
		game_over_display2 = 1'b0;	
		next_state = START; //or PLAY?
		heart_showup = 1'b0;
//		heart_showup_reg = 1'b0;
	end
	
	endcase
	
end

endmodule