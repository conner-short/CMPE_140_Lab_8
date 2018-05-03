`timescale 1ns / 1ps

module fact_addr_dec(input wire [1:0] addr, input wire we, output reg we1, output reg we2, output wire [1:0] rd_sel);
    always@(*)
    begin
        case(addr)
        2'b00:
        begin
            we1 = we;
            we2 = 1'b0;
        end
        
        2'b01:
        begin
            we1 = 1'b0;
            we2 = we;
        end
        
        2'b10:
        begin
            we1 = 1'b0;
            we2 = 1'b0;
        end
        
        2'b11:
        begin
            we1 = 1'b0;
            we2 = 1'b0;
        end
        
        default:
        begin
            we1 = 1'bx;
            we2 = 1'bx;
        end
        endcase
    end
    
    assign rd_sel = addr;
endmodule
