sdspeed - SD Memeory Card Speed Test - Fight Flash Fraud
=======
Measures the effective read and write speed of SD memory cards. sdspeed runs on Mac OS X.
sdspeed is based on F3 (see details below) but with some changes so that it was possible 
to write a nativ Mac OS X user interface based on it.
Homepage: http://www.flagsoft.com/cmswp/products/sdspeed-sd-card-memory-speed-test/

LIMITATIONS
===========
The author of this application is not responsible if your SD card get damaged by the use
of this software. You should always make backup first before try any software that touches
your SD card.

Version and Authors
===================

sdspeed 9.9.9 (DD.MMM.YYYY)
 - (Maybe you... :)

sdspeed 1.0.1 (09.OCT.2013)
 - Joseph Chiocchi (yyolk) for the sd_card.png icon, thank you! (Maybe you also provide the source file, svg?)
 - Michael Mustun (flagsoft) minor changes, documentation

sdspeed 1.0 (18.MAR.2013) by Michael Mustun <michael.mustun@gmail.com>
- Initial version.
- (Maybe you... :)

Compile
=======
Just fire up Xcode and compile it.

Author System
-------------
- Mac OS X 10.8.3 on MacBook Pro with one SD memory card slot
- Xcode 4.6.1

Usage
=====
Version 1.0.1:
 - Just start the application and follow the instructions there

Version 1.0:
1. Insert the SD memory card
2. Start sdspeed, the card should be recognized
3. Hit start. It will first make a write speed test and after that a read speed test. 
   After all, the average of the write and read speed test is showed
4. You can run the test again or just quit the application CMD+Q or red button as usual

Todo
====
- Display read speed while read test is running. Add also progress bar.
- Display the CLASS of the SD card (assume, based on the average of read/write)
- done: Recognize SD card after sdspeed is started. (Maybe timer, check every second for a card)
- done: Display the size of the SD card

Credits
=======
The model behind this user interface is based on F3 - Fight Flash Fraud Version 2.2 by 
Michel Machado who wrote an open source alternative to h2testw and released the code 
under GNU General Public License (GPL) version 3. For more information about F3 please 
visit http://oss.digirati.com.br/f3/
Github repo https://github.com/AltraMayor/f3
