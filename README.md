# xrecord

Still working through the kinks but this is a command-line utility for capturing video on OS X.


More importantly, With 10.10.2 (Yosemite) or later and iOS 8+ devices connected by lightning cable it can capture video from iOS devices that are connected to the Mac.


Right now there is a limitation that Quicktime needs to be running with a new capture window (can be audio) otherwise iOS devices don't show in the list (open ticket with Apple to figure out why).


Capture is also hard-coded to 10 seconds right now.  The plan is to have it accept a sigint (ctrl-c) and terminate recording based on that.
