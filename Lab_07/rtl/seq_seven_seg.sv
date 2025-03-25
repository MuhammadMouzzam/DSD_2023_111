`timescale 1ns / 1ps

module seq_seven_seg(
    input logic write,
    input logic [3:0] num,
    input logic [2:0] sel,
    input logic clk,
    input logic reset,
    output logic [7:0] anode,
    output logic [6:0] cathodes
);
    logic [3:0] mem [8];
    logic [2:0] new_sel;
    logic [16:0] Q1, Y1;
    logic [2:0] Q2, Y2;

//Clock frequency Controller: Decreases the frequency to 763Hz
    always_ff @(posedge clk) begin
        if (reset)
            Q1 <= 0;
        else
            Q1 <= Y1;
    end

    always_comb begin
        if (Q1 == 17'b11111111111111111)
            Y1 = 0;
        else
            Y1 = Q1 + 1'b1;
    end

//This further decreases the frequency to 100Hz for each segment for 8 segments resulting in approx.
//800Hz overall

    always_ff @(posedge Q1[16], posedge write) begin
        if (write)
            Q2 <= 0;
        else
            Q2 <= Y2;
    end

    always_comb begin
        if (Q2 == 3'b111)
            Y2 = 0;
        else
            Y2 = Q2 + 1'b1;
    end

//Desired Number storage portion: Contains 8 flipflops, each used to store desired number's data for individual segments
    always_ff @(posedge clk) begin
        if (reset)
            mem <= {0,0,0,0,0,0,0,0};
        else if (write)
            mem[sel] <= num;
    end

    always_comb begin
        if (write)
            new_sel = sel;
        else
            new_sel = Q2;
    end

//Selection decoder portion
    always_comb begin
        case(new_sel)
            3'b000 : anode = 8'b11111110;
            3'b001 : anode = 8'b11111101;
            3'b010 : anode = 8'b11111011;
            3'b011 : anode = 8'b11110111;
            3'b100 : anode = 8'b11101111;
            3'b101 : anode = 8'b11011111;
            3'b110 : anode = 8'b10111111;
            3'b111 : anode = 8'b01111111;
        endcase
    end

//Number decoder Portion
    always_comb begin
        case(mem[new_sel])
            4'b0000 : cathodes = 7'b0000001;
            4'b0001 : cathodes = 7'b1001111;
            4'b0010 : cathodes = 7'b0010010;
            4'b0011 : cathodes = 7'b0000110;
            4'b0100 : cathodes = 7'b1001100;
            4'b0101 : cathodes = 7'b0100100;
            4'b0110 : cathodes = 7'b0100000;
            4'b0111 : cathodes = 7'b0001111;
            4'b1000 : cathodes = 7'b0000000;
            4'b1001 : cathodes = 7'b0000100;
            4'b1010 : cathodes = 7'b0001000;
            4'b1011 : cathodes = 7'b1100000;
            4'b1100 : cathodes = 7'b0110001;
            4'b1101 : cathodes = 7'b1000010;
            4'b1110 : cathodes = 7'b0110000;
            4'b1111 : cathodes = 7'b0111000;
        endcase
    end

endmodule
