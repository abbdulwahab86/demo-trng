module trng(
    input clk,
    input reset,
    output reg [7:0] rand_out
);

reg [7:0] noise;
reg [7:0] lfsr_state;

// Thermal noise generator
always @(posedge clk or posedge reset) begin
    if (reset)
        noise <= 8'h00; // Reset noise to zero on reset
    else
        noise <= $random; // Assuming $random generates random noise
end

// LFSR to mix noise
always @(posedge clk or posedge reset) begin
    if (reset)
        lfsr_state <= 8'hFF; // Initialize LFSR to all ones
    else if (clk) begin
        // LFSR taps for maximal length sequence
        lfsr_state <= {lfsr_state[6:0], lfsr_state[7] ^ lfsr_state[5]}; 
    end
end

// XOR noise and LFSR to produce output
always @(posedge clk) begin
    if (reset)
        rand_out <= 8'h00; // Output zero on reset
    else
        rand_out <= noise ^ lfsr_state; // XOR noise and LFSR state
end

endmodule

