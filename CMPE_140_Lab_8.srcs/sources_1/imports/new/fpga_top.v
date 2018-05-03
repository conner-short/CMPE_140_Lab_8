module fpga_top(
    input wire CLK_100MHZ,
    input wire RESET,
    input wire CLK_BTN,
    input wire [4:0] SW,
    output wire [4:0] LD,
    output wire [7:0] LEDSEL,
    output wire [7:0] LEDOUT);
    reg [15:0] hex;
    wire [31:0] gpi1, gpo1, gpo2;
    wire clk_5KHz, sys_clk;
    
    assign gpi1 = {{27{1'b0}}, SW};
    
    // Clock generator
    clk_gen clk_5KHz_gen(.clk100MHz(CLK_100MHZ), .rst(RESET), .clk_sec(), .clk_5KHz(clk_5KHz));
    
    // System clock debouncer
    bdebouncer sys_clk_db(.clk(clk_5KHz), .button(CLK_BTN), .debounced_button(sys_clk));
    
    // SoC unit
    system sys(.clk(sys_clk), .reset(RESET), .gpi1(gpi1), .gpi2(gpo1), .gpo1(gpo1), .gpo2(gpo2), .pc());
    
    // 7-Segment output selector
    always@(*)
    begin
        case(gpo1[4])
        1'b0: begin hex = gpo2[15:0]; end
        1'b1: begin hex = gpo2[31:16]; end
        default: begin hex = {16{1'bx}}; end
        endcase
    end
    
    // 7-Segment multiplexer
    disp_hex_mux ss_mux(
        .clk(clk_5KHz),
        .reset(RESET),
        .hex0(hex[3:0]),
        .hex1(hex[7:4]),
        .hex2(hex[11:8]),
        .hex3(hex[15:12]),
        .dp_in(4'b1111),
        .led_sel(LEDSEL),
        .led_out(LEDOUT));
    
    // Status LEDs
    assign LD[4] = gpo1[4];
    assign LD[3:0] = {4{gpo1[0]}};
endmodule
