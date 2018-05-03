`timescale 1ns / 1ps

module addr_dec(input wire [31:0] addr, input wire we, output reg we_gpio, output reg we_f, output reg we_dm, output reg [1:0] rd_sel);
    always@(*)
    begin
        case(addr[31:8])
        24'h000000: begin we_gpio = 1'b0;  we_f = 1'b0;  we_dm =   we;  rd_sel = 2'b00; end
        24'h000008: begin we_gpio = 1'b0;  we_f =   we;  we_dm = 1'b0;  rd_sel = 2'b01; end
        24'h000009: begin we_gpio =   we;  we_f = 1'b0;  we_dm = 1'b0;  rd_sel = 2'b10; end
        default:    begin we_gpio = 1'bx;  we_f = 1'bx;  we_dm = 1'bx;  rd_sel = 2'bxx; end
        endcase
    end
endmodule
