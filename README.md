# Leapable

This is a simple library I used to be able to control a [Sphero](http://www.gosphero.com/) with
a [Leap Motion](https://www.leapmotion.com/) during [Robots Conf 2013](http://2013.robotsconf.com/).

It allows you to control a Sphero via moving your hard forward, backward, and side to side. A simple
"three hits of life" game is implemented as well. You start green but your first hit turns you yellow
before you head to red.

There is an issue with a communication overflow (is my guess) between the computer and Sphero. Too many
commands are sent to the Sphero so sometimes the Sphero will crash. You should impelement some sort of
averaging over the frames potentially.
