module you_win_text_map
(
	input logic [5:0] X,
	input logic [4:0] Y,
	output logic pixel
);

	logic [7:0] rom_address;
	logic [7:0] text_slice;
	
	assign pixel = text_slice[3'b111 - X[2:0]];
	
	you_win_rom ywr(.address(rom_address), .data(text_slice));

	always_comb begin
	
		if(X >= 6'd0 && X < 6'd8 && Y >= 5'd0 && Y < 5'd16)
			rom_address = 8'd0 + Y;
		
		else if(X >= 6'd8 && X < 6'd16 && Y >= 5'd0 && Y < 5'd16)
			rom_address = 8'd16 + Y;
		
		else if(X >= 6'd16 && X < 6'd24 && Y >= 5'd0 && Y < 5'd16)
			rom_address = 8'd32 + Y;
				
		else if(X >= 6'd0 && X < 6'd8 && Y >= 5'd16)
			rom_address = 8'd48 + Y - 8'd16;
		
		else if(X >= 6'd8 && X < 6'd16 && Y >= 5'd16)
			rom_address = 8'd64 + Y - 8'd16;
	
		//else if(X >= 6'd24 && X < 6'd32 && Y >= 5'd16 && Y < 5'd32)
		else
			rom_address = 8'd80 + Y - 8'd16;
					
	end

endmodule 

module you_win_rom
(
	input [7:0] address,
	output [7:0] data
);

	parameter[0:95][7:0] ROM = {
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111100, // 2 ******
        8'b01100110, // 3  **  **
        8'b01100110, // 4  **  **
        8'b01100110, // 5  **  **
        8'b01111100, // 6  *****
        8'b01100000, // 7  **
        8'b01100000, // 8  **
        8'b01100000, // 9  **
        8'b01100000, // a  **
        8'b11110000, // b ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f	         
		  
		  // code x01
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00111000, // 2   ***
        8'b00011000, // 3    **
        8'b00011000, // 4    **
        8'b00011000, // 5    **
        8'b00011000, // 6    **
        8'b00011000, // 7    **
        8'b00011000, // 8    **
        8'b00011000, // 9    **
        8'b00011000, // a    **
        8'b00111100, // b   ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f		  
	};
	
	assign data = ROM[address];

endmodule 