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
  wire        cin;
  wire [7:0]  g, p, c;
  wire [35:0] e;
  wire [7:0]  sum;
  wire        cout;


  assign cin = 0;
  assign a[7:0] = ui_in[7:0];
  assign b[7:0] = uio_in[7:0];


  // Generate and Propagate
  assign g = a & b;
  assign p = a ^ b;

  //c[0]
  and (e[0], cin, p[0]);
  or (c[0], e[0], g[0]);

  //c[1]
  and (e[1], cin, p[0], p[1]);
  and (e[2], g[0], p[1]);
  or (c[1], e[1], e[2], g[1]);

  //c[2]
  and (e[3], cin, p[0], p[1], p[2]);
  and (e[4], g[0], p[1], p[2]);
  and (e[5], g[1], p[2]);
  or (c[2], e[3], e[4], e[5], g[2]);

  //c[3]
  and (e[6], cin, p[0], p[1], p[2], p[3]);
  and (e[7], g[0], p[1], p[2], p[3]);
  and (e[8], g[1], p[2], p[3]);
  and (e[9], g[2], p[3]);
  or (c[3], e[6], e[7], e[8], e[9], g[3]);

  //c[4]
  and (e[10], cin, p[0], p[1], p[2], p[3], p[4]);
  and (e[11], g[0], p[1], p[2], p[3], p[4]);
  and (e[12], g[1], p[2], p[3], p[4]);
  and (e[13], g[2], p[3], p[4]);
  and (e[14], g[3], p[4]);
  or (c[4], e[10], e[11], e[12], e[13], e[14], g[4]);

  //c[5]
  and (e[15], cin, p[0], p[1], p[2], p[3], p[4], p[5]);
  and (e[16], g[0], p[1], p[2], p[3], p[4], p[5]);
  and (e[17], g[1], p[2], p[3], p[4], p[5]);
  and (e[18], g[2], p[3], p[4], p[5]);
  and (e[19], g[3], p[4], p[5]);
  and (e[20], g[4], p[5]);
  or (c[5], e[15], e[16], e[17], e[18], e[19], e[20], g[5]);

  //c[6]
  and (e[21], cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6]);
  and (e[22], g[0], p[1], p[2], p[3], p[4], p[5], p[6]);
  and (e[23], g[1], p[2], p[3], p[4], p[5], p[6]);
  and (e[24], g[2], p[3], p[4], p[5], p[6]);
  and (e[25], g[3], p[4], p[5], p[6]);
  and (e[26], g[4], p[5], p[6]);
  and (e[27], g[5], p[6]);
  or (c[6], e[21], e[22], e[23], e[24], e[25], e[26], e[27], g[6]);

  //c[7]
  and (e[28], cin, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
  and (e[29], g[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7]);
  and (e[30], g[1], p[2], p[3], p[4], p[5], p[6], p[7]);
  and (e[31], g[2], p[3], p[4], p[5], p[6], p[7]);
  and (e[32], g[3], p[4], p[5], p[6], p[7]);
  and (e[33], g[4], p[5], p[6], p[7]);
  and (e[34], g[5], p[6], p[7]);
  and (e[35], g[6], p[7]);
  or (c[7], e[28], e[29], e[30], e[31], e[32], e[33], e[34], e[35], g[7]);

  xor (sum[0],p[0],cin);
  xor x[7:1](sum[7:1],p[7:1],c[6:0]);
  assign cout = c[7];
  
  // Connect to output
  assign uo_out[7:0] = sum[7:0];

endmodule
