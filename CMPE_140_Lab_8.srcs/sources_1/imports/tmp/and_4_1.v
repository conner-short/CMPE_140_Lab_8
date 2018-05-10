`timescale 1ns / 1ps

module and_4_1(input [3:0] a, input b, output [3:0] out);
    assign out = (b == 1) ? a : 0;
endmodule