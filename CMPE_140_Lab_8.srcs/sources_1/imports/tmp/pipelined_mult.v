`timescale 1ns / 1ps

module pipelined_mult(input clk, input [3:0] a, input [3:0] b, output [7:0] product);
    wire [3:0] a_reg_q;
    wire [3:0] b_reg_q;
    
    wire [3:0] andU2;
    wire [3:0] andU3;
    wire [3:0] andU4;
    wire [3:0] andU5;
            
    wire [7:0] sumU6;
    wire [7:0] sumU7;
    wire [7:0] sumU10;
    
    wire [7:0] U8_q;
    wire [7:0] U9_q;
    
    d_reg #(4) U0(clk, 1'b0, 1'b1, a, a_reg_q);
    d_reg #(4) U1(clk, 1'b0, 1'b1, b, b_reg_q);
        
    and_4_1 U2(a_reg_q, b_reg_q[0], andU2);
    and_4_1 U3(a_reg_q, b_reg_q[1], andU3);
    and_4_1 U4(a_reg_q, b_reg_q[2], andU4);
    and_4_1 U5(a_reg_q, b_reg_q[3], andU5);
        
    add_8 U6({4'h0, andU2}, {3'h0, andU3, 1'h0}, sumU6);
    add_8 U7({2'h0, andU4, 2'h0}, {1'h0, andU5, 3'h0}, sumU7);
    
    d_reg #(8) U8(clk, 1'b0, 1'b1, sumU6, U8_q);
    d_reg #(8) U9(clk, 1'b0, 1'b1, sumU7, U9_q);
    
    add_8 U10(U8_q, U9_q, sumU10);
    
    d_reg #(8) U11(clk, 1'b0, 1'b1, sumU10, product);
endmodule