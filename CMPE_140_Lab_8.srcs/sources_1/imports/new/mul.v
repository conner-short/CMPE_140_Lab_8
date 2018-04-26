`timescale 1ns / 1ps

module mul #(parameter WIDTH = 32) (
    input wire [WIDTH - 1 : 0] a,
    input wire [WIDTH - 1 : 0] b,
    output wire [WIDTH - 1 : 0] q
);
    assign q = a * b;
endmodule