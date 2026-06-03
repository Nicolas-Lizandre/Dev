**C (STM32CubeIDE – Nucleo board)**
Implementation of a speed control loop for a drone motor using a Hall effect sensor and PWM (report available on GitHub). Extraction of NMEA frames from a Grove GPS module via USART and simple geolocation. Development of a multitask LED pattern generator with adjustable modes, speed control and OLED display. Control of a stepper motor using a TMC2225 driver (encoder + converter) via PWM. Implementation of a digital compass using the BMM150 sensor.

**Rust**
Extraction of drone identification frames (French electronic signaling regulation, JORF n°0303, 31 Dec 2019) from pcap files. Development of a Logo compiler and interpreter in Rust using the Santiago library. Implementation of drivers (bargraph, gamepad, encoder, stepper motor, OLED display) in a multitask architecture running on an STM32L476RG Nucleo 64 board using the Embassy framework.

**VHDL**
Integration of a NIOS V soft processor on a Basys3 board using Quartus IP, including bus, memory and peripheral architecture. Development of a digital guitar tuner in VHDL on a Basys2 board using Xilinx ISE, with an attempted LCD display integration (report available on GitHub). Implementation of a “Magic Screen” on Basys3 using Quartus Prime: HDMI output (VLC display), pixel movement via two encoders, and storage using dual port RAM.
