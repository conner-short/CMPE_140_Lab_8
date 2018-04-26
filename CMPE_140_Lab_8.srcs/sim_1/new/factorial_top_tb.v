`timescale 1ns / 1ps

module factorial_top_tb();
    reg clk, reset, we;
    reg [3:0] wd;
    reg [1:0] addr;
    
    wire [31:0] rd;
    
    factorial_top dut(
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .we(we),
        .wd(wd),
        .rd(rd)
    );
    
    integer i, cycle_count;
    
    task tick_clk;
        begin
            #5; clk = 1'b1; #5; clk = 1'b0; cycle_count = cycle_count + 1;
        end
    endtask
    
    initial
    begin
        clk = 1'b0;
        reset = 1'b0;
        
        // Reset
        reset = 1'b1;
        tick_clk;
        reset = 1'b0;
        
        // Iterate over each possible input n
        for(i = 'h0; i < 'h10; i = i + 'h1)
        begin
            // Write n to DUT
            wd = i[3:0];
            addr = 2'b00;
            we = 1'b1;
            tick_clk;
            
            // Write go
            wd = 4'b0001;
            addr = 2'b01;
            we = 1'b1;
            tick_clk;
            
            we = 1'b0;
            
            cycle_count = 0;
            
            // Wait for done
            addr = 2'b10;
            tick_clk;
            while(!(rd & 32'h00000001)) tick_clk;
            
            $display("Cycle count for n = %d: %d cycles", i[3:0], cycle_count);
            cycle_count = 0;
        end
        
        $stop;
    end
endmodule
