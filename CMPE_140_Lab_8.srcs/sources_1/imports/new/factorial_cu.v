`timescale 1ns / 1ps

module factorial_cu(
    input wire clk,
    input wire reset,
    input wire go,
    input wire counter_gt_1,
    input wire d_gt_12,
    output reg counter_load,
    output reg counter_en,
    output reg register_d_mux_sel,
    output reg output_en,
    output reg register_load,
    output reg done,
    output reg err
);
    parameter
        S_IDLE = 2'h0,
        S_LOOP = 2'h1,
        S_DONE = 2'h2;
    
    reg [1:0] cs, ns;
    
    always@(posedge clk)
    begin
        if(reset) cs <= S_IDLE;
        else cs <= ns;
    end
    
    always@(*)
    begin
        counter_load = 1'b0;
        counter_en = 1'b0;
        register_d_mux_sel = 1'b0;
        output_en = 1'b0;
        register_load = 1'b0;
        done = 1'b0;
        err = 1'b0;
        
        case(cs)
        S_IDLE:
        begin
            if(go)
            begin
                counter_load = 1'b1;
                register_load = 1'b1;
                
                ns = S_LOOP;
            end
            
            else
            begin
                ns = S_IDLE;
            end
        end
        
        S_LOOP:
        begin
            if(d_gt_12)
            begin
                ns = S_DONE;
            end
            
            else
            begin
                if(counter_gt_1)
                begin
                    counter_en = 1'b1;
                    register_d_mux_sel = 1'b1;
                    register_load = 1'b1;

                    ns = S_LOOP;
                end
                        
                else
                begin
                    ns = S_DONE;
                end
            end
        end
        
        S_DONE:
        begin
            output_en = 1'b1;
            done = 1'b1;
            
            if(d_gt_12)
            begin
                err = 1'b1;
            end
            
            ns = S_IDLE;
        end
        
        default:
        begin
            ns = S_IDLE;
        end
        endcase
    end
endmodule
