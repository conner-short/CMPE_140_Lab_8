`timescale 1ns / 1ps

module factorial_dreg #(parameter WIDTH = 32) (
    input wire clk,
    input wire reset,
    input wire load,
    input wire [WIDTH - 1 : 0] d,
    output reg [WIDTH - 1 : 0] q
);
    always@(posedge clk, posedge reset)
    begin
        if(reset)     q <= 0;
        else if(load) q <= d;
        else          q <= q;
    end
endmodule
