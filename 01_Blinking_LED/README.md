# 01 Blinking LED - First Light

This project is the "Hello World" of FPGA development, designed to verify the clock source and basic GPIO functionality of the Tang Nano 25K.

## The Goal
Toggle an onboard or breadboard LED at a visible frequency using a clock divider in Verilog.

## Media & Documentation
- **Working Demo:** See `Working.mp4` for the hardware in action.
- **The Struggle:** `error.jpeg` shows the synthesis error encountered during the first build.

## Problems Faced: Dual-Purpose Pin Error
During the initial "Place & Route" phase, the Gowin EDA threw an error regarding **Dual-Purpose Pins**. 

### The Issue:
The pins used for SCL/SDA or specific LEDs are often shared with the **MSPI Interface** (used for loading the bitstream from Flash). By default, the tool restricts these pins to prevent user logic from interfering with chip configuration.

### The Fix:
I had to change the Project Configuration to allow these pins to act as regular I/O:
1. Open **Project Settings** in Gowin EDA.
2. Go to **Place & Route** -> **Configuration**.
3. Change **MSPI / CPU Pins** to **"Use as regular I/O"**.

!
