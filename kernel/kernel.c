/*

How to enter the 64 bit kernel, idea, may not be the best one or even the correct one but it is an idea:

Assign a memory address where it is expected for the 64 bit kernel to be.
After putting the processor in the 64 bit mode, far jump to that know address
The 64 bit kernel will clean up some things, such as relocating the pages to a
higher memory address and scraping all valuable information from the bootloader
and putting into another memory address. At which point it will free up the
bootloader, and start doing regular kernel work.

*/