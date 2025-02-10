`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/01/2025 12:47:51 AM
// Design Name: 
// Module Name: design_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module design_file(
    input a,
    input b,
    input c,
    output x,
    output y
    );
    assign or_out = a | b;
    assign x = (~c) ^ or_out;
    assign xor_out = (~(a & b)) ^ (or_out);
    assign y = or_out & xor_out;
endmodule
