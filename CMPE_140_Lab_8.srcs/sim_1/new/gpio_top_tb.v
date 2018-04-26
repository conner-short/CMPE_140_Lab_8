`timescale 1ns / 1ps

module gpio_top_tb();
    wire [31:0] rd, gpo1, gpo2;
    reg clk, reset, we;
    reg [31:0] gpi1, gpi2, wd;
    reg [1:0] addr;
    
    gpio_top dut(.clk(clk), .reset(reset), .addr(addr), .we(we), .gpi1(gpi1), .gpi2(gpi2), .wd(wd), .gpo1(gpo1), .gpo2(gpo2), .rd(rd));
    
    task tick_clk;
        begin
            #5; clk = 1'b1; #5; clk = 1'b0;
        end
    endtask
    
    integer err_count;
    
    initial
    begin
        clk = 1'b0;
        reset = 1'b0;
        we = 1'b0;
        err_count = 0;
            
        // Reset
        reset = 1'b1;
        tick_clk;
        reset = 1'b0;
        
        // Write test to gpi1 and test read
        gpi1 = 32'h55AA55AA;
        addr = 2'b00;
        tick_clk;
        
        if(rd !== 32'h55AA55AA)
        begin
            $display("GPI1 Error");
            err_count = err_count + 1;
        end
        
        // Write test to gpi2 and test read
        gpi2 = 32'hAA55AA55;
        addr = 2'b01;
        tick_clk;
        
        if(rd !== 32'hAA55AA55)
        begin
            $display("GPI2 Error");
            err_count = err_count + 1;
        end
        
        // Write test to gpo1, test gpo1 out, and test read
        wd = 32'hFFCCFFCC;
        addr = 2'b10;
        we = 1'b1;
        tick_clk;
        
        if(rd !== 32'hFFCCFFCC)
        begin
            $display("GPO1 Error");
            err_count = err_count + 1;
        end
        
        if(gpo1 !== 32'hFFCCFFCC)
        begin
            $display("GPO1 Error");
            err_count = err_count + 1;
        end
        
        // Write test to gpo2, test gpo2 out, and test read
        wd = 32'hCCFFCCFF;
        addr = 2'b11;
        we = 1'b1;
        tick_clk;
        
        if(rd !== 32'hCCFFCCFF)
        begin
            err_count = err_count + 1;
        end
                
        if(gpo2 !== 32'hCCFFCCFF)
        begin
            err_count = err_count + 1;
        end
        
        if(err_count > 0) $display("== Found %d errors in simulation.", err_count);
        else $display("== No errors found in simulation.");
        
        $stop;
    end
endmodule
