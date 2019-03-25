# awPull
Pull Data from the Ambient Weather observerIP and put it in a text file.

This is a Processing3 Script I wrote to get data from a Ambient Weather observerIP Model 1550 by parsing the data off the data page.
It works by loading the page into an Array and I use the ApacheCommons String Tool to parse out the relevant data line by line.   I then write it to a text file.

I have tested this script running directly connected to the observerIP.  It ran for 3 days without issues.  I was pulling data every 15 seconds which is about what I think is the response time for most of the sensors anyway.

I only have one model of the observerIP so I don't know if this will work with other models.  The code however is very straight forward.

You will need to download the Apache Commons String Tools and install them in to the Processing3 Library.  One of the issues I had when doing this is that when Processing3 scans the library directory, it does not like underscores.  Rename your library files.

Pacolux
