# APB Master-Slave Verification Using UVM

This project focuses on developing and verifying an APB (Advanced Peripheral Bus) master-slave interface using SystemVerilog and the Universal Verification Methodology (UVM). The goal was to create a structured, reusable testbench that could thoroughly validate the functionality of an APB-compliant slave by simulating various master transactions and observing the slave’s responses.

The APB protocol, part of ARM’s AMBA family, is a simple low-power, low-latency bus typically used for communication with peripherals. Through this project, the aim was to understand its timing behavior and control sequence while designing a scalable verification setup that reflects modern SoC verification practices.

## Overview

The verification environment was built around a UVM architecture that models a master-slave interaction. The UVM master agent generates both read and write operations by driving PSEL, PENABLE, and PWRITE signals according to APB protocol timing. The slave, acting as the Design Under Test (DUT), receives address and data information, responds with PRDATA, and indicates completion through PREADY.

The monitor observes all signal transitions on the bus and reconstructs transactions for the scoreboard, which compares actual and expected results. This setup ensures that both timing and data integrity are verified. The UVM structure promotes modularity and reuse, allowing the same environment to be extended for multiple peripheral verification scenarios.

## Operation and Methodology

APB transactions occur in two stages: a setup phase, where PSEL is asserted and control signals are driven, and an access phase, initiated by PENABLE. For write cycles, the slave captures PWDATA during access, while for read cycles, it places valid data on PRDATA. Any invalid access triggers an error response through PSLVERR.

The UVM environment automates this entire process. The sequencer generates randomized and directed transactions, the driver converts them into pin-level activity, and the monitor observes real-time signal behavior. Functional correctness is validated through the scoreboard, while coverage analysis ensures that all protocol scenarios—read, write, idle, and error are exercised.

## Simulation and Results

The simulation was performed using Mentor QuestaSim and demonstrated correct APB protocol behavior across a range of test cases.
Read and write cycles executed as expected, with proper synchronization between PSEL, PENABLE, and PREADY signals.

For write operations, the slave successfully stored data in the addressed register locations and responded with PREADY = 1 to indicate completion. For read transactions, the slave output valid data on PRDATA consistent with previously written values.

Error-handling behavior was verified by initiating invalid address accesses and observing PSLVERR assertions, confirming compliance with the APB specification.
The UVM scoreboard reported no functional mismatches, and waveform inspection validated correct signal sequencing through both setup and access phases.

Overall, the simulation results verified that the slave module conformed to the APB protocol and that the developed UVM environment was capable of robust, reusable verification.

## Observations and Discussion

During verification, it was observed that proper timing control between the setup and access phases was essential to avoid glitches or incomplete transactions.
The UVM monitor provided valuable insights into signal transitions, making it possible to trace issues such as delayed PREADY assertions or incorrect PWRITE handling.
By integrating both directed and random sequences, the verification achieved broad coverage, ensuring reliability across edge conditions.

The methodology demonstrated how a UVM-based environment enhances debugging efficiency, promotes reusability, and supports scalable verification of bus-based designs.
