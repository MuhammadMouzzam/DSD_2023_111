`timescale 1ns / 1ps


module RGB_tb();
    logic [1:0] a, b;
    logic red, green, blue;

    RGB tb(
    .a(a),
    .b(b),
    .red(red),
    .green(green),
    .blue(blue)
    );

task driver(input logic [1:0] A = $random, B = $random);
    begin
        a = A;
        b = B;
        #10;
    end
endtask

task monitor();
    begin
        logic [1:0] C_A, C_B;
        logic exp_red, exp_green, exp_blue;

        C_A = a;
        C_B = b;

        exp_red = ((~C_B[0]) & (~C_B[1])) | ((C_A[0]) & (C_A[1])) | ((C_A[0]) & (~C_B[1])) | ((C_A[1]) & (~C_B[1])) | ((C_A[1]) & (~C_B[0]));
        exp_green = ((~C_A[0]) & (~C_A[1])) | ((C_B[0]) & (~C_A[1])) | ((C_B[1]) & (C_B[0])) | ((~C_A[0]) & (C_B[1])) | ((C_B[1]) & (~C_A[1]));
        exp_blue = (C_A[1] ^ C_B[1]) | (C_A[0] ^ C_B[0]);

        if (exp_red !== red & exp_green !== green & exp_blue !== blue) begin
            $display("ERROR : a = %b, b = %b, exp_red = %b, Got = %b, exp_green = %b, Got = %b, exp_blue = %b, Got = %b", C_A, C_B, exp_red, red, exp_green, green, exp_blue, blue);
        end 
        else begin
            $display("PASS : a = %b, b = %b, exp_red = %b, exp_green = %b,  exp_blue = %b", C_A, C_B, exp_red, exp_green, exp_blue);
        end
    end
endtask

task direct_test(input logic [1:0] A, B);
    begin
        driver(A, B);
        monitor();
    end
endtask

    initial
        begin
            for(int i = 0; i < 4; i++)
            begin
                for(int j = 0; j < 4; j++)
                begin
                    direct_test(i, j);
                end
            end
        end
endmodule
