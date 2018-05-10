`timescale 1ns / 1ps

module add_4_ha_array(input [3:0] a, input [3:0] b, output [3:0] sum, output [3:0] carry);
    add_4_ha U0(a[0], b[0], sum[0], carry[0]);
    add_4_ha U1(a[1], b[1], sum[1], carry[1]);
    add_4_ha U2(a[2], b[2], sum[2], carry[2]);
    add_4_ha U3(a[3], b[3], sum[3], carry[3]);
endmodule
