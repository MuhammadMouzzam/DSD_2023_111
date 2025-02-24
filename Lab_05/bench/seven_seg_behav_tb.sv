`timescale 1ns / 1ps

module seven_seg_behav_tb();
    logic [3:0] num;
    logic [2:0] sel;
    logic A,B,C,D,E,F,G,DP;
    logic [7:0] AN;

    seven_seg_behav seg(
        .num(num),
        .sel(sel),
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .F(F),
        .G(G),
        .DP(DP),
        .AN(AN)
    );

task driver(input logic [3:0] NUM = $random, input logic [2:0] SEL = $random);  //If provided with a value, it'll assign that
    num = NUM;                                                                  //value to num and sel, otherwise will assign
    sel = SEL;                                                                  //them a random value
    #10;
endtask

task monitor();
    logic [6:0] expected_output_cat;
    logic [7:0] expected_output_an;   //Monitors the output of the module
    case(num)                       //A Check for num input
        4'b0000 : expected_output_cat = 7'b0000001;
        4'b0001 : expected_output_cat = 7'b1001111;
        4'b0010 : expected_output_cat = 7'b0010010;
        4'b0011 : expected_output_cat = 7'b0000110;
        4'b0100 : expected_output_cat = 7'b1001100;
        4'b0101 : expected_output_cat = 7'b0100100;
        4'b0110 : expected_output_cat = 7'b0100000;
        4'b0111 : expected_output_cat = 7'b0001111;
        4'b1000 : expected_output_cat = 7'b0000000;
        4'b1001 : expected_output_cat = 7'b0000100;
        4'b1010 : expected_output_cat = 7'b0001000;
        4'b1011 : expected_output_cat = 7'b1100000;
        4'b1100 : expected_output_cat = 7'b0110001;
        4'b1101 : expected_output_cat = 7'b1000010;
        4'b1110 : expected_output_cat = 7'b0110000;
        4'b1111 : expected_output_cat = 7'b0111000;
    endcase

    case(sel)                       //A Check for sel input
        3'b000 : expected_output_an = 8'b11111110;
        3'b001 : expected_output_an = 8'b11111101;
        3'b010 : expected_output_an = 8'b11111011;
        3'b011 : expected_output_an = 8'b11110111;
        3'b100 : expected_output_an = 8'b11101111;
        3'b101 : expected_output_an = 8'b11011111;
        3'b110 : expected_output_an = 8'b10111111;
        3'b111 : expected_output_an = 8'b01111111;
    endcase
    if(expected_output_cat != {A,B,C,D,E,F,G}) begin
        $display("ERROR - Cathode : Given = %b, Expected = %b, Got = %b", num, expected_output_cat, {A,B,C,D,E,F,G});
    end
    else begin
        $display("Passed : Given = %b, Cathode Got = %b", num, {A,B,C,D,E,F,G});
    end
    if(expected_output_an != AN) begin
        $display("ERROR - Anode : Given = %b, Expected = %b, Got = %b", sel, expected_output_an, AN);
    end
    else begin
        $display("Passed : Given = %b, Anode Got = %b", sel, AN);
    end
endtask

task direct_test(input logic [3:0] NUM, input logic [2:0] SEL);
    driver(NUM, SEL);
    monitor();
endtask

task random_test(input int number);
    for(int i = 0; i < number; i++) begin
        driver();
        monitor();
    end
endtask

initial
    begin
        for(int i = 0; i < 16; i++) begin
            direct_test(i, i % 8);
        end
    end

endmodule
