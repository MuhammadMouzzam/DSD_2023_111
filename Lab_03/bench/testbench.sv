`timescale 1ns / 1ps

module testbench();
    logic a;
    logic b;
    logic c;
    logic x;
    logic y;

    design_file df(
        .a(a),
        .b(b),
        .c(c),
        .x(x),
        .y(y)
    );


    initial
        begin
            a = 0; b = 0; c = 0;
            #20;
            a = 0; b = 0; c = 1;
            #20;
            a = 0; b = 1; c = 0;
            #20;
            a = 0; b = 1; c = 1;
            #20;
            a = 1; b = 0; c = 0;
            #20;
            a = 1; b = 0; c = 1;
            #20;
            a = 1; b = 1; c = 0;
            #20;
            a = 1; b = 1; c = 1;
            #20;
            $finish;
        end
    initial
        begin
           $monitor("a=%b, b=%b, c=%b, x=%b, y=%b", a,b,c,x,y);
        end
endmodule