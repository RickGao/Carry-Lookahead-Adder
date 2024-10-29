# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles


# @cocotb.test()
# async def test_project(dut):
#     dut._log.info("Start")
#
#     # Set the clock period to 10 us (100 KHz)
#     clock = Clock(dut.clk, 10, units="us")
#     cocotb.start_soon(clock.start())
#
#     dut._log.info("Test project behavior")
#
#     # Set the input values you want to test
#     dut.a.value = 13
#     dut.b.value = 10
#
#     # Wait for one clock cycle to see the output values
#     await ClockCycles(dut.clk, 10)
#
#
#     # The following assersion is just an example of how to check the output values.
#     # Change it to match the actual expected output of your module:
#     dut._log.info(f"value of outputs are: {dut.sum.value} and {dut.carry_out.value}.")
#     assert dut.sum.value == 7 and dut.carry_out.value == 1
#
#     # Keep testing the module by changing the input values, waiting for
#     # one or more clock cycles, and asserting the expected output values.

@cocotb.test()
async def test_project(dut):
    # Start the clock
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    # Iterate over all possible 8-bit values for a and b
    for a_val in range(256):  # 0 to 255 for 8-bit values
        for b_val in range(256):  # 0 to 255 for 8-bit values
            # Apply inputs
            dut.ui_in.value = a_val
            dut.uio_in.value = b_val

            # Wait for some clock cycles for the result to settle
            await ClockCycles(dut.clk, 1)

            # Calculate expected values
            expected_sum = (a_val + b_val) & 0xFF  # 8-bit sum (lower 8 bits)

            # Log the test case and result
            dut._log.info(
                f"Testing a={a_val:08b} b={b_val:08b}: Expected sum={expected_sum}"
            )

            # Check results
            assert dut.uo_out.value == expected_sum, \
                f"Sum mismatch for a={a_val} b={b_val}: got {dut.uo_out.value}, expected {expected_sum}"