`timescale 1ns / 1ps

module RGB(
input logic [1:0] a, b,
output logic red, green, blue
    );



always_comb
    begin
        red = ((~b[0]) & (~b[1])) | ((a[0]) & (a[1])) | ((a[0]) & (~b[1])) | ((a[1]) & (~b[1])) | ((a[1]) & (~b[0]));
        green = ((~a[0]) & (~a[1])) | ((b[0]) & (~a[1])) | ((b[1]) & (b[0])) | ((~a[0]) & (b[1])) | ((b[1]) & (~a[1]));
        blue = (a[1] ^ b[1]) | (a[0] ^ b[0]);
    end
endmodule

