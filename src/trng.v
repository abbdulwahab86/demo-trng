module trng (
  input clk,
  input n_reset,
  output reg [7:0] rand_out
);

// Ring oscillator (simplified model) - adjust delays for better randomness
reg [2:0] ring_oscillator;

always @(posedge clk) begin
  if (!n_reset) begin
    ring_oscillator <= 3'b0; // Reset ring oscillator on active reset
  end else begin
    ring_oscillator[2:1] <= ring_oscillator[1:0];
    ring_oscillator[0] <= ring_oscillator[2]^ring_oscillator[1];
  end
end

// LFSR with feedback taps (adjust taps for better randomness)
localparam int TAP1 = 2;
localparam int TAP2 = 3;

always @(posedge clk) begin
  if (!n_reset) begin
    rand_out <= 8'h00;  // Reset random output on active reset
  end else begin
    rand_out[7:1] <= rand_out[6:0];
    rand_out[0]   <= ring_oscillator[0]^rand_out[TAP1]^rand_out[TAP2];
  end
end
endmodule
