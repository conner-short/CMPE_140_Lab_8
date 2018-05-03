`timescale 1ns / 1ps

module system_tb();
    reg [31:0] gpi1;
    reg clk, reset;
    wire [31:0] gpo1, gpo2, pc;
    
    system dut(.clk(clk), .reset(reset), .gpi1(gpi1), .gpi2(gpo1), .gpo1(gpo1), .gpo2(gpo2), .pc(pc));
    
    task tick_clk;
        begin
            #5; clk = 1'b1; #5; clk = 1'b0;
        end
    endtask
    
    task tick_reset;
        begin
            #5; reset = 1'b1; #5; reset = 1'b0;
        end
    endtask
    
    initial
    begin
        gpi1 = 32'h1C;
        tick_reset;
        while(pc != 32'h4C) tick_clk;
        $finish;
    end
endmodule
