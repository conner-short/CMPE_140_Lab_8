`timescale 1ns / 1ps

module mux #(parameter WIDTH = 32) (
    input wire [WIDTH - 1 : 0] a,
    input wire [WIDTH - 1 : 0] b,
    input wire sel,
    output wire [WIDTH - 1 : 0] q
);
    assign q = sel ? b : a;
endmodule