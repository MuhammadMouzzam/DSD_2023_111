`timescale 1ns / 1ps

module seq_seven_seg_tb();
    logic write;
    logic [3:0] num;
    logic [2:0] sel;
    logic clk;
    logic reset;
    logic [7:0] anode;
    logic [6:0] cathodes;

    seq_seven_seg UUT(
        .write(write),
        .num(num),
        .sel(sel),
        .clk(clk),
        .reset(reset),
        .anode(anode),
        .cathodes(cathodes)
    );

int num_memory [8] = {0,0,0,0,0,0,0,0};

//clk generator
initial begin
    clk <= 1'b0;
    write <= 0;
    forever #5 clk <= ~clk;
end

//Resets everything when run
task reseter;
    reset <= 0;
    @(posedge clk);
    reset <= #1 1;
    @(posedge clk);
    reset <= #1 0;
endtask


task write_toggler;
    @(posedge clk);
    write <= #1 ~write;
endtask

task driver(input logic [3:0] rnum = $random, input logic [2:0] rsel = $random);
    @(posedge clk);
    num_memory[rsel] = rnum;
    num <= #1 rnum;
    sel <= #1 rsel;
    @(posedge clk);
endtask

function [7:0] anode_decoder(input logic [2:0] rsel);
    logic [7:0] anode_out;
    case(rsel)
            3'b000 : anode_out = 8'b11111110;
            3'b001 : anode_out = 8'b11111101;
            3'b010 : anode_out = 8'b11111011;
            3'b011 : anode_out = 8'b11110111;
            3'b100 : anode_out = 8'b11101111;
            3'b101 : anode_out = 8'b11011111;
            3'b110 : anode_out = 8'b10111111;
            3'b111 : anode_out = 8'b01111111;
        endcase
    return anode_out;
endfunction

function [6:0] cathode_decoder(input logic [3:0] rnum);
    logic [6:0] cathode_out;
    case(rnum)
            4'b0000 : cathode_out = 7'b0000001;
            4'b0001 : cathode_out = 7'b1001111;
            4'b0010 : cathode_out = 7'b0010010;
            4'b0011 : cathode_out = 7'b0000110;
            4'b0100 : cathode_out = 7'b1001100;
            4'b0101 : cathode_out = 7'b0100100;
            4'b0110 : cathode_out = 7'b0100000;
            4'b0111 : cathode_out = 7'b0001111;
            4'b1000 : cathode_out = 7'b0000000;
            4'b1001 : cathode_out = 7'b0000100;
            4'b1010 : cathode_out = 7'b0001000;
            4'b1011 : cathode_out = 7'b1100000;
            4'b1100 : cathode_out = 7'b0110001;
            4'b1101 : cathode_out = 7'b1000010;
            4'b1110 : cathode_out = 7'b0110000;
            4'b1111 : cathode_out = 7'b0111000;
        endcase
endfunction

task monitor();
    logic [7:0] expected_anode;
    logic [6:0] expected_cathode;
    @(posedge clk)
    expected_anode = anode_decoder(UUT.new_sel);
    expected_cathode = cathode_decoder(num_memory[UUT.new_sel]);

    if(expected_anode != anode)
        $display("Error-In-Anode: Number = %d, selector = %d, Expected Anode Output = %b, Got = %b", num_memory[UUT.new_sel], UUT.new_sel, expected_anode, anode);
    else
        $display("Anode-Pass: Number = %d, Selector = %d, Got = %b", num_memory[UUT.new_sel], UUT.new_sel, anode);
    if(expected_cathode != cathodes)
        $display("Error-In-Cathode: Number = %d, selector = %d, Expected Cathode Output = %b, Got = %b", num_memory[UUT.new_sel], UUT.new_sel, expected_cathode, cathodes);
    else
        $display("Cathode-Pass: Number = %d, Selector = %d, Got = %b", num_memory[UUT.new_sel], UUT.new_sel, cathodes);
endtask

initial begin
    for (int i = 0; i < 8; i++) begin
        driver();
    end
    write_toggler;
    for(int i = 0; i < 8; i++) begin
        monitor();
    end
end
initial begin
    write_toggler;
end

initial begin
    reseter;
end

endmodule
