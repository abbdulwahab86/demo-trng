`default_nettype none
module tt_um_wahab_demo_trng(
    input  wire [7:0] ui_in,    // Dedicated inputs (used for seed)
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // Will go high when the design is enabled
    input  wire       clk,      // Clock
    input  wire       rst_n     // Reset, active low
);

    reg [7:0] lfsr1;
    reg [7:0] lfsr2;
    wire feedback1 = lfsr1[7] ^ lfsr1[5] ^ lfsr1[4] ^ lfsr1[3];
    wire feedback2 = lfsr2[7] ^ lfsr2[6] ^ lfsr2[5] ^ lfsr2[0];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lfsr1 <= 8'h1;  // Initialize to a non-zero value (default)
            lfsr2 <= 8'hA;  // Initialize to a different non-zero value (default)
        end else if (ena) begin
            lfsr1 <= ui_in;  // Load seed value from ui_in when enabled
            lfsr2 <= ~ui_in; // Load inverse seed value for second LFSR
        end else begin
            lfsr1 <= {lfsr1[6:0], feedback1};
            lfsr2 <= {lfsr2[6:0], feedback2};
        end
    end

    wire [7:0] prng_output = lfsr1 ^ lfsr2;

    assign uo_out = prng_output;
    assign uio_out = prng_output;
    assign uio_oe = 8'hFF;  // Enable all uio_out bits as output

endmodule
