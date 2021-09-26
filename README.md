# BlueMax

![BlueMax](/img/IMG_2148_best2_xp_25p.png)


BlueMax - a wearable FPGA board to hardware-accelerate signal processing and machine learning, based on an Altera/Intel MAX 10 (10M16SAU169


Key features:
* FPGA
  * 10M16SAU169 FPGA (Altera/Intel Max 10 FPGA)
    * 16K Logic Elements
    * 549Kbit memory
    * 45 18x18 multipliers
    * 4 PLLs
    * 1 ADC
  * 24MHz oscillator
* Peripherals
  * 5 push buttons
  * 2 7-segment displays, including dot
  * 6 user LEDs
  * 2 system LEDs (programming status)
  * Extensions: PMOD-compatible, 16x2 (I/O) + 6x2 Samtec (power, I/O) 
  * Reset button
* Usage
  * Suitable for standalone use or as an extension to plug onto ![BlueSense4](https://github.com/droggen/BlueSense4)
  
  
  
## Configuration

Install USB Blaster driver: https://www.terasic.com.tw/wiki/Altera_USB_Blaster_Driver_Installation_Instructions
If the driver isn't installed, it may be an issue of expired certificate: https://www.intel.com/content/www/us/en/support/programmable/articles/000086243.html
Follow this https://www.intel.com/content/www/us/en/support/programmable/articles/000086243.html and install both patches pointing to the Quartus Lite directory.
