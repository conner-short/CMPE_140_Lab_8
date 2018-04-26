`timescale 1ns / 1ps

module cnt #(parameter WIDTH = 4) (
    input wire clk,
    input wire en,
    input wire load,
    input wire [WIDTH - 1 : 0] d,
    output reg [WIDTH - 1 : 0] q
);
    always@(posedge clk)
    begin
        if(load)
        begin
            q <= d;
        end
        else if(en)
        begin
            q <= q - 1;
        end
        else
        begin
            q <= q;
        end
    end
endmodule
