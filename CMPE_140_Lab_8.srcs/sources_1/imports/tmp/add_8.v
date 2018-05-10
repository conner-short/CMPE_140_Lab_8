`timescale 1ns / 1ps

module add_8(input [7:0] a, input [7:0] b, output [7:0] sum, output carry_out);
    wire [3:0] sumU0;
    wire carryU0;
    
    wire [3:0] sumU1;
    
    add_4 U0(a[3:0], b[3:0], 0, sumU0, carryU0);
    add_4 U1(a[7:4], b[7:4], carryU0, sumU1, carry_out);
    
    assign sum = {sumU1, sumU0};
endmodule