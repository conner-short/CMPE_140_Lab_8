`timescale 1ns / 1ps

module cmp #(parameter WIDTH = 32) (
    input wire [WIDTH - 1 : 0] a,
    input wire [WIDTH - 1 : 0] b,
    output wire gt
);
    assign gt = a > b;
endmodule