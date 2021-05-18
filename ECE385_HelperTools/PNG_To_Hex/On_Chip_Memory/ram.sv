//module  background_frameRAM
//(
//		input [9:0] 	DrawX,
//							DrawY,
//		input Clk,
//
//		output logic [23:0] data_out
//);
//	parameter bit [0:6][23:0] palette = {24'hFF0000,
//												24'h020100,
//												24'h14041E,
//												24'h1D001D,
//												24'h220005,
//												24'h270020,
//												24'h21083F};
//	
//	parameter [9:0] mem_seg_x_start = 0;
//	parameter [9:0] mem_seg_x_size = 640;
//	parameter [9:0] mem_seg_y_size = 177;
//	parameter [9:0] mem_seg_y_start = 253;
//	parameter [9:0] mem_seg_y_end = 480;
//	
//	// mem has width of 3 bits and a total of 400 addresses
//	// 400 elements of 32 bits
//	//logic [23:0] mem [0:399];
//	logic [3:0] mem [0:113279]; // 640*480 = 307200 pixels so 307199
//	logic [3:0] LUT_idx;
//	logic [16:0] address;
//
//	initial
//	begin
//		$readmemh("ECE385_HelperTools/PNG_To_Hex/On_Chip_Memory/sprite_bytes/space-background.txt", mem);
//	end
//	
//	assign address = (DrawY - mem_seg_y_start)*mem_seg_x_size + (DrawX - mem_seg_x_start);
//	
//	always_comb
//	begin
//		LUT_idx = mem[address];
//		if(DrawY <= mem_seg_y_start)
//			data_out = 24'hFF0000;
//		else if(DrawY >= mem_seg_y_end)
//			data_out = 24'h21083F;
//		else
//			data_out = palette[LUT_idx];
//	end
//
//endmodule
/////*
//// * ECE385-HelperTools/PNG-To-Txt
//// * Author: Rishi Thakkar
//// *
//// */
////module  frameRAM
////(
//////		input [4:0] data_In,
////		input [18:0] /*write_address,*/ read_address,
////		input Clk, we,
////
////		output logic [4:0] data_Out
////);
////
////// mem has width of 3 bits and a total of 400 addresses
////logic [2:0] mem [0:307199];
////
////initial
////begin
////	 $readmemh("sprite_bytes/space-background.txt", mem);
////end
////
////always_ff @ (posedge Clk) begin
//////	if (we)
//////		mem[write_address] <= data_In;
////	data_Out<= mem[read_address];
////end
////
////endmodule
