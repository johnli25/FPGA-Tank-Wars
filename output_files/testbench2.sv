module testbench2();

timeunit 10ns;

timeprecision 1ns;

logic Reset;
logic frame_clk = 0;
logic shot_hit1;
logic shot_hit2;
logic [31:0] keycode;
logic [2:0] heart1_display;
logic [2:0] heart2_display;
logic game_over_display;
logic game_over_display2;
logic heart_showup;
logic tank_powerup;

always begin: CLOCK_GENERATION
#1 frame_clk = ~frame_clk;
end

initial begin: CLOCK_INITIALIZATION
	frame_clk = 0;
end

game_sm gsm(.*);

initial begin
Reset = 0;
shot_hit1 = 1'b0;
shot_hit2 = 1'b0;
keycode = 8'b0;
tank_powerup = 1'b0;

#2 Reset = 1;
#2 Reset = 0;

#2 shot_hit1 = 0;
#2 shot_hit1 = 1;

#2 shot_hit1 = 0;
#2 shot_hit1 = 1;

#2 shot_hit1 = 0;
#2 shot_hit1 = 1;

#2 shot_hit1 = 0;
#2 shot_hit1 = 1;

#2 Reset = 1;
#2 Reset = 0;

#2 shot_hit1 = 0;
#2 shot_hit1 = 1;

#10 shot_hit1 = 0;

#2 keycode = 8'h0A;

end

endmodule