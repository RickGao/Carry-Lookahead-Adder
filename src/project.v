/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_carry_lookahead_adder (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // Bidirectional is input
    assign uio_oe[7:0]  = 8'b00000000;

    // All output pins must be assigned. If not used, assign to 0.
    assign uio_out = 0;

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, 1'b0};


    wire [7:0]  a, b;
    wire [7:0]  g, p, c;
    // wire [35:0] e;
    wire [7:0]  sum;
    wire        cout;


    assign a[7:0] = ui_in[7:0];
    assign b[7:0] = uio_in[7:0];


    // Generate and Propagate
    assign g = a & b;
    // assign p = a ^ b; // XOR Propagate
    assign p = a | b;


    // Carry
    assign c[0] = 1'b0;
    assign c[1] = g[0];
    assign c[2] = g[1] | (p[1] & g[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) | (p[4] & p[3] & p[2] & p[1] & g[0]);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) | (p[5] & p[4] & p[3] & p[2] & g[1]) | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) | (p[6] & p[5] & p[4] & p[3] & g[2]) | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0]);


    // Sum
    // assign sum = p[7:0] ^ c[7:0];           // XOR Propagate
    assign sum = g[7:0] ^ p[7:0] ^ c[7:0];  // OR Propagate
    // assign sum = a + b;


    // Connect to output
    assign uo_out[7:0] = sum[7:0];

endmodule
