`timescale 1ns/1ps

module trng_tb;

reg clk;
reg reset;
wire [7:0] rand_out;

// Instantiate TRNG module
trng uut (
    .clk(clk),
    .reset(reset),
    .rand_out(rand_out)
);

// Clock generation
always #5 clk = ~clk;

// Reset generation
initial begin
    clk = 0;
    reset = 1;
    #10 reset = 0;
end

// Dumping data to VCD file
initial begin
    $dumpfile("trng_tb.vcd"); // Define VCD file name
    $dumpvars(0, trng_tb); // Dump all signals
end

// Stimulus
initial begin
    #1000;
    $display("Random Number: %h", rand_out);
    $finish;
end

endmodule

