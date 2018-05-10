module maindec
(input [5:0] opcode, output branch, jump, we_reg, alu_src, we_dm,[1:0] dm2reg, [1:0] alu_op, [1:0] reg_dst);
    reg [10:0] ctrl;
    assign {branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_op} = ctrl;
    always @ (opcode)
    begin
        case (opcode)
            6'b00_0000: ctrl = 11'b0_0_01_1_0_0_00_10; // R-type
            6'b00_1000: ctrl = 11'b0_0_00_1_1_0_00_00; // ADDI
            6'b00_0100: ctrl = 11'b1_0_00_0_0_0_00_01; // BEQ
            6'b00_0010: ctrl = 11'b0_1_00_0_0_0_00_00; // J
            6'b10_1011: ctrl = 11'b0_0_00_0_1_1_00_00; // SW
            6'b10_0011: ctrl = 11'b0_0_00_1_1_0_01_00; // LW
            
            //EXTENDED DESIGN
            6'b00_0011: ctrl = 11'b0_1_10_1_0_0_10_10; // JAL
            default:    ctrl = 11'bx_x_xx_x_x_x_xx_xx;
        endcase
    end
endmodule

module auxdec
(input [1:0] alu_op, [5:0] funct, output mult_en, mf_ctrl, pc_ovr, [1:0] wd_ctrl, [2:0] alu_ctrl);
    reg [7:0] ctrl;
    assign {mult_en, mf_ctrl, pc_ovr, wd_ctrl, alu_ctrl} = ctrl;
    always @ (alu_op, funct)
    begin
        case (alu_op)
            2'b00: ctrl = 3'b010; // add
            2'b01: ctrl = 3'b110; // sub
            default: case (funct)
                6'b10_0100: ctrl = 8'b0_0_0_00_000; // AND
                6'b10_0101: ctrl = 8'b0_0_0_00_001; // OR
                6'b10_0000: ctrl = 8'b0_0_0_00_010; // ADD
                6'b10_0010: ctrl = 8'b0_0_0_00_110; // SUB
                6'b10_1010: ctrl = 8'b0_0_0_00_111; // SLT
                
                //EXTENDED DESIGN
                6'b01_1001: ctrl = 8'b1_0_0_00_000;  // MULTU
                6'b01_0010: ctrl = 8'b0_0_0_01_000;  // MFLO
                6'b01_0000: ctrl = 8'b0_1_0_01_000;  // MFHI
                6'b00_1000: ctrl = 8'b0_0_1_10_000;  // JR
                
                //default: ctrl = 5'bx_x_x_xx_xxx;
                default: ctrl = 8'b0_0_0_00_000;
            endcase
        endcase
    end
endmodule