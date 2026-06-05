# 4-Wheel Drive Robot Control System (ATmega32 + Dual L298)

This repository contains the C source code and hardware schematics for a 4-wheel drive (4WD) robot control system based on the **ATmega32** microcontroller. The system utilizes two **L298 H-Bridge motor drivers** to control four DC motors independently, enabling standard directional movement as well as differential (tank) turning.

## Features

* **4-Motor Independent Drive:** Controls 4 DC motors split into pairs driven by dual L298 ICs.
* **Simple Tactile Control:** 4 push-buttons act as inputs to command movement (Forward, Backward, Left Turn, Right Turn).
* **Tank Steering:** Implements differential turning where side motors spin in opposite directions to achieve sharp, on-the-spot rotation.
* **Hardware-Level Safety:** Software ensures all motors stop instantly if no buttons are pressed.

---
## Simulation Preview

https://github.com/user-attachments/assets/a1f54131-1fe3-4785-a789-33d5ad5a0071

---

## Hardware Architecture & Pinout

The project is designed and simulated using an **ATmega32** running at an internal or external clock speed of **8.0 MHz** (`F_CPU = 8000000UL`).

### 1. Inputs (Buttons with Pull-up Resistors)

The control buttons are connected to **PORTA** (Pins PA4 - PA7). They use active-low logic (pressing the button pulls the pin to GND).

* `PA7` -> **Forward**
* `PA6` -> **Backward**
* `PA5` -> **Left Turn**
* `PA4` -> **Right Turn**

### 2. Outputs (Motor Drivers)

Two **L298 drivers** (`U8` and `U15`) handle the high-current demands of the motors. They are driven synchronously by **PORTB** and **PORTC** (Pins 0–5 on both ports are configured as outputs).

* **PORTB (Pins 0-5):** Controls Driver 1 (`U8`) for the left/front side motors.
* **PORTC (Pins 0-5):** Controls Driver 2 (`U15`) for the right/rear side motors.
* *Pins 4 and 5 are mapped to Enable pins (ENA/ENB) to keep the drivers active, while Pins 0-3 handle the IN1-IN4 direction states.*

---

## Control Logic Matrix

The code uses predefined hexadecimal values sent to `PORTB` and `PORTC` to dictate the state of the H-Bridges:

| Command | Hex Code | Description |
| --- | --- | --- |
| `M_FORWARD` | `0x1B` | All four motors spin forward |
| `M_BACKWARD` | `0x2D` | All four motors spin backward |
| `M_LEFT` | `0x1D` | Left motors backward, Right motors forward (Tank turn Left) |
| `M_RIGHT` | `0x2B` | Left motors forward, Right motors backward (Tank turn Right) |
| `M_STOP` | `0x00` | All inputs and enable lines low (Coasting stop) |

---

## Code Overview

The firmare is written in embedded C for AVR.

* `init_system()`: Sets the Data Direction Registers (`DDRB`, `DDRC` as output; `DDRA` as input) and ensures the robot is stationary at boot.
* `main()`: Runs a continuous polling loop with a 10ms debounce delay (`_delay_ms(10)`), prioritizing movements via an `if-else if` structure based on which button is pressed.




