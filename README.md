# ISA_POST_card
Simple 8-bit port 80h listener for ISA bus with 7-segment display.

Based on EP2C5... development board from AliExpress: http://land-boards.com/blwiki/index.php?title=Cyclone_II_EP2C5_Mini_Dev_Board, 
with unneeded stuff removed as described in the land-boards page to free some GPIO pins.

Lots of CD4050 chips were used to shift logic levels. Pinout is available in Quartus Pin Planner. Project was created in Altera Quartus II 13.0-sp1 with ModelSim-Altera simulation tool.

The project is configured to embed an instance of Altera Signal Tap II into the device to read POST-sequence memory. This memory is also exposed as a bit stream on some pin, but I've done it just to prevent compiler from optimising "unused" memory out.
