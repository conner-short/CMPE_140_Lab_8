module disp_hex_mux(
    input wire clk,
    input wire reset,
    input wire [3:0] hex0,
    input wire [3:0] hex1,
    input wire [3:0] hex2,
    input wire [3:0] hex3,
    input wire [3:0] dp_in, // TODO: What is this for?
    output wire [7:0] led_sel,
    output wire [7:0] led_out);
    wire [7:0] digits [7:0];
    
    // 7-Segment converters (lower four digits)
    bcd_to_7seg bcd0  (hex0, digits[0]);
    bcd_to_7seg bcd1  (hex1, digits[1]);
    bcd_to_7seg bcd2  (hex2, digits[2]);
    bcd_to_7seg bcd3  (hex3, digits[3]);
    
    // Upper four digits
    assign digits[7] = 8'hFF;
    assign digits[6] = 8'hFF;
    assign digits[5] = 8'hFF;
    assign digits[4] = 8'hFF;
    
    // Multiplexer
    led_mux mux  (clk, reset, digits[7], digits[6], digits[5], digits[4], digits[3], digits[2], digits[1], digits[0], led_sel, led_out);
endmodule
