# FPGA Digital Stopwatch (Basys3)

A digital stopwatch developed on the Artix-7 FPGA and implemented using the VHDL programming language and the Basys3 board.
The stopwatch is SS.hh format and offers the functions of Start/Stop and Reset via pushbuttons on the unit itself.
The project is concerned with the design, timing issues, and hardware debugging stages and is not related to the simulation-only aspect.

---

## Features
- Precise timing with a 100 MHz FPGA clock
- Displays seconds and hundredths of seconds (SS.hh) on a 4-digit 7-Segment display
- Start/Stop toggle using debounced push button
- Reset functionality having clean edge detection
- Fully Multiplexed 7-Segment Display
- Synthesised and verified on real Hardware (Basys3)

## Hardware and Tools
- Board: Basys3 (Dig
- FPGA: Artix-7 (xc7a35tcpg236)
- Language: VHDL (2008)
- Toolchain: AMD Vivado (tested with Vivado 2023)

---

# Controls

| BUTTON |           Function           |
|--------|------------------------------|
|  btnU  | Start / Stop stopwatch       |
|  btnC  | Reset the stopwatch to 00.00 |

---

# Display Format

SS.hh
- `SS` → Seconds (00-99
- `hh` -> Hundredths of a second
- Decimal point distinguishes seconds and hundredths.

---

## Project Architecture
- It is modular by design and implemented completely in RTL:
- `tick_gen`: Produces ticks of 1 ms and 10 ms from a 100 MHz clock
- `debounce`: Mechanical button input debouncing
- `edge_pulse`: Produces single-cycle pulses for button presses
- `run_toggle`: Handles the running/paused mode
- `time_counter_bcd`: BCD-based time counter
- `display_mux`: multiplexes 7 segment
- `sevenseg_decoder`: BCD to segment decoder
- `stopwatch_top`: Top-level integration

---

## How to Build & Run

1. Open Vivado
2. Create a new RTL Project
3. FPGA Selection: `xc7a35tcpg236`
4. Add all `.vhd` files from `src/`
5. Add constraints file from `constraints/`
6. Set `stopwatch_top` as the top module
7. Run Synthesis → Implementation → Generate Bitstream
8. Program Basys3 Board Using Hardware Manager
---
## Notes - Button debouncing and the logic to reset the buttons were added to handle the actual hardware correctly - Digit order and anode mapping were checked directly on the Basys3 board
