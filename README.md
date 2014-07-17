raspi-led
=============

This ruby script allows you to override the default behavior of the Raspberry Pi's 'ACT' (Activity) LED. The script supports the built in firmware LED modes as well as custom modes you define via bash and ruby. 

Usage
=============
The general format is ...

`sudo ./raspi_led.rb mode poll_rate`

... where `mode` is a mode from the supported list and `poll_rate` is a float or int. `poll_rate` defaults to *2* and is only used for custom modes.

Root access is necessary as the script modifies the following firmware files
 > - /sys/class/led/led0/trigger
 > - /sys/class/led/led0/brightness

Run the script with `./raspi_led.rb` to get a list of available modes.

Modes
=============

Firmware modes
-------------
 > - `none` *- LED off*
 > - `mmc0` *- SD card activity (the Pi's default)*
 > - `timer` *- Blink on a ~1 second timer*
 > - `oneshot` *- ???*
 > - `heartbeat` *- Blink with a "heartbeat" pattern*
 > - `backlight` *- ???*
 > - `gpio` *- Likely disables Pi control but allows GPIO control (untested)*
 > - `cpu0` *- CPU activity*
 > - `default-on` *- LED on*

These modes are provided by the Raspberry Pi firmware.
Custom modes
------------
 > - `ssh-user` *- Lights when one or more users are logged in remotely*
 > - `hot-temp` *- Lights when temp is above 60C*
 > - `high-avg-cpu` *- Lights when the average CPU usage over the last minute is greater than 80%*
 > - `turbo-on` *- Lights when the raspi-config CPU overclock kicks in*
 
Custom modes run in the background, constantly checking their state and updating the LED if necessary. To add your own mode, see the raspi_led.rb source. 

Running on boot
=============
The simplest way to have the script run at boot is to include the command in your /etc/rc.local file, assuming you're using Rasbian. This will execute the command as root.

`` `ruby /FULL/PATH/TO/raspi_led.rb ssh-user 2 &` ``

