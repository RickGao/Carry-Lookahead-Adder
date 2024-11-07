<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

1. Basic Concept

  A standard adder, such as a Ripple Carry Adder, requires carry signals to propagate from the least significant bit (LSB) to the most significant bit (MSB). This bit-by-bit propagation can cause delays, especially in higher-bit adders. The Carry Lookahead Adder anticipates the carry for each bit position by calculating Generate and Propagate signals, allowing it to produce carry results in parallel and greatly reduce delay.

2. Definition of Generate and Propagate Signals

  In a Carry Lookahead Adder, the Generate (G) and Propagate (P) signals are defined as follows:

  Generate signal Gi: Indicates that the ith bit position will generate a carry independently of the previous carry. It occurs when both Ai and Bi are 1.

  Gi = Ai ⋅ Bi

  Propagate signal Pi: Indicates that the ith bit position will propagate a carry from the previous bit. It occurs when one of Ai or Bi is 1.

  Gi = Ai ^ Bi

3. Carry Signal Calculation

  Using the Generate and Propagate signals, we can calculate the carry signals C for each bit position. For an 8-bit adder, the carry signals C1 through C7 and Cout expand as follows:

  C[0] = initial carry = 0

  C[1] = G[0] + (P[0] * C[0])

  C[2] = G[1] + (P[1] * G[0]) + (P[1] * P[0] * C[0])

  C[3] = G[2] + (P[2] * G[1]) + (P[2] * P[1] * G[0]) + (P[2] * P[1] * P[0] * C[0])

  And so on, continuing up to C[7] and Cout.

  This expanded formula enables parallel carry calculation, rather than sequential, significantly reducing delay in large adders.

4. Sum Calculation

  The sum for each bit position can be calculated as:

  Sum i= Pi ^ Ci

## How to test

Run test and conduct exhaustive verification of the design within the Tiny Tapeout flow to ensure complete functional accuracy and robustness across all input combinations.

Input two 8 bit integers from input pins and get one 8 bit integer from output pins

## External hardware

No external hardware
