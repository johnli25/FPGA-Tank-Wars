//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
		output 	[1:0]		 DRAM_DQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);

logic Reset_h, hssig, vssig, blank, sync, VGA_Clk;

//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizexsig, ballsizeysig;
	logic [9:0] ball2xsig, ball2ysig, ball2sizexsig, ball2sizeysig;
	
	logic [9:0] bulletxsig, bulletysig, bulletsizexsig, bulletsizeysig;
	logic [9:0] bullet2xsig, bullet2ysig, bullet2sizexsig, bullet2sizeysig;
	
	logic [7:0] Red, Blue, Green;
	logic [31:0] keycode;
	logic [7:0] keycodeP1;
	logic [7:0] keycodeP2;
	logic [7:0] keycodeShoot1;
	logic [7:0] keycodeShoot2;
	logic [15:0] keycode2;
	logic [12:0] obstacle_array;
	logic [2:0] bounce_on [13];
	logic [2:0] bounce2_on [12:0];
	logic [2:0] tank_bounce_on [12:0];

	logic [1:0] bulletOnVal;
	logic [1:0] bullet2OnVal;

	logic [2:0] rotation;
	logic [2:0] rotation2;
	logic [2:0] disappear_array [12:0];
	logic [2:0] disappear2_array [12:0];
	logic [2:0] tank_bullet [12:0];
	logic [2:0] tank_bullet2 [12:0];

/*state machine registers and signal*/	
	logic shot_hit1;
	logic shot_hit2;
	logic press_restart;
	logic [2:0] heart1_display;
	logic [2:0] heart2_display;
	logic game_over_display;
	logic game_over_display2;
	
	logic heart_showup;
	
	logic field1On, field2On;
	
	logic [9:0] ball2xmove, ball2ymove;

//=======================================================
//  Structural coding
//=======================================================
	assign keycodeP1 = keycode[7:0];
	assign keycodeP2 = keycode[15:8];
//	assign keycodeShoot1 = keycode[23:16];
//	assign keycodeShoot2 = keycode[31:24]; 

	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//HEX drivers to convert numbers to HEX output
	HexDriver hex_driver4 (hex_num_4, HEX4[6:0]);
	assign HEX4[7] = 1'b1;
	
	HexDriver hex_driver3 (hex_num_3, HEX3[6:0]);
	assign HEX3[7] = 1'b1;
	
	HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	assign HEX1[7] = 1'b1;
	
	HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	assign HEX0[7] = 1'b1;
	
	//fill in the hundreds digit as well as the negative sign
	assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab62_soc u0 (
		.clk_clk                           (MAX10_CLK1_50),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
//		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}), 
		.sdram_wire_dqm(DRAM_DQM),              //.dqm
  
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode),
		.keycode2_export(keycode2)
		
	 );

ball b0(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode[7:0]), .BallX(ballxsig), 
.BallY(ballysig), .BallSx(ballsizexsig), .BallSy(ballsizeysig), .bounce_on(bounce_on),
.shotHit(shot_hit1), .rotation, .game_over_display, .game_over_display2, .field1(field1On));

bullet b1(.Reset(Reset_h), .frame_clk(VGA_VS), .ballX(ballxsig), .ballY(ballysig), 
.keycode(keycode), .disappear(disappear_array), .tank_bullet, 
.bulletX(bulletxsig), .bulletY(bulletysig), .bulletSx(bulletsizexsig), .bulletSy(bulletsizeysig), .bulletOn(bulletOnVal),
.shot_hit1, .game_over_display, .game_over_display2);

vga_controller vga0(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS),
.pixel_clk(VGA_Clk), .blank, .sync, .DrawX(drawxsig), .DrawY(drawysig));

color_mapper c0(.Clk(MAX10_CLK1_50),
.BallX(ballxsig), .BallY(ballysig), .DrawX(drawxsig), .DrawY(drawysig),
.Ball_sizex(ballsizexsig), .Ball_sizey(ballsizeysig),
.Ball2X(ball2xsig), .Ball2Y(ball2ysig),
.Ball2_sizex(ball2sizexsig), .Ball2_sizey(ball2sizeysig),
.BulletX(bulletxsig), .BulletY(bulletysig), 
.Bullet_sizex(bulletsizexsig), .Bullet_sizey(bulletsizeysig), .bulletOn(bulletOnVal),
.Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), 
.Bullet2_sizex(bullet2sizexsig), .Bullet2_sizey(bullet2sizeysig), .bullet2On(bullet2OnVal), 
.obstacle_on(obstacle_array), 
.rotation, .rotation2, 
.heart1_display, .heart2_display, .go(game_over_display), .go2(game_over_display2),
.heart_showup, .blank,//.disappear(disappear_array),
.shot1Hit(shot_hit1), .shot2Hit(shot_hit2), .field1On(field1On),
.field2On(field2On),
.Red, .Green, .Blue);

ball2 b2(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode[15:8]), .ball2X(ball2xsig), 
.ball2Y(ball2ysig), .ball2Sx(ball2sizexsig), .ball2Sy(ball2sizeysig), .bounce_on(bounce2_on), 
.shotHit(shot_hit2), .rotation2, .field2On, .game_over_display, .game_over_display2,
.ball2xmove, .ball2ymove);

bullet2 b3(.Reset(Reset_h), .frame_clk(VGA_VS), .ballX(ball2xsig), .ballY(ball2ysig), 
.keycode(keycode[23:16]), .keycodeShoot2(keycode[15:8]),
.ball2xmotion(ball2xmove), .ball2ymotion(ball2ymove),
 .disappear(disappear2_array), .tank_bullet2,
.bullet2X(bullet2xsig), .bullet2Y(bullet2ysig), .bullet2Sx(bullet2sizexsig), .bullet2Sy(bullet2sizeysig), .bullet2On(bullet2OnVal),
.shot_hit2, .game_over_display, .game_over_display2);

parameter int ARRAYX_VALUE[13] = '{250, 500, 120, 420, 120, 310, 310, 310, 310, 290, 290, 330, 330}; //ii iterator
parameter int ARRAYY_VALUE[13] = '{100, 150, 300, 320, 169, 230, 250, 210, 270, 210, 270, 210, 270};
genvar ii;
generate 
for(ii=0; ii< 13; ii++) begin : counter_loop
    obstacle #(.shape_x(ARRAYX_VALUE[ii]), .shape_y(ARRAYY_VALUE[ii])) obs0 (.BallX(ballxsig), 
.BallY(ballysig), .BallSx(ballsizexsig), .BallSy(ballsizeysig), 
.Ball2X(ball2xsig), .Ball2Y(ball2ysig), .Ball2Sx(ball2sizexsig), .Ball2Sy(ball2sizeysig),
.BulletX(bulletxsig), .BulletY(bulletysig), .BulletSx(bulletsizexsig), .BulletSy(bulletsizeysig),
.Bullet2X(bullet2xsig), .Bullet2Y(bullet2ysig), .Bullet2Sx(bullet2sizexsig), .Bullet2Sy(bullet2sizeysig),
.DrawX(drawxsig), .DrawY(drawysig), .field1On(field1On), .field2On(field2On),
.obstacle_on(obstacle_array[ii]), .bounce_on(bounce_on[ii]), .bounce2_on(bounce2_on[ii]),
.tank_bounce_on(tank_bounce_on[ii]), .disappear(disappear_array[ii]), .disappear2(disappear2_array[ii]),
.tank_bullet(tank_bullet[ii]), .tank_bullet2(tank_bullet2[ii])
); 
end : counter_loop
endgenerate

game_sm gsm(.Reset(Reset_h), .frame_clk(VGA_VS), .shot_hit1, .shot_hit2, .keycode,//inputs
.heart1_display, .heart2_display, .game_over_display, .game_over_display2, .heart_showup); //outputs

endmodule
