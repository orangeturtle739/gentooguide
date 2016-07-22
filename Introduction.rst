##############
Introduction
##############

As I built my own computer and installed Gentoo Linux on it, I ran into a number of issues, and had to read many different guides in order to figure out how to proceed. In order to both record how my system is set up and to provide a reference for others seeking to configure similar setups, I wrote this guide. Throughout the guide, I tried to fully explain every command that I used by explaining the purpose of the command and that of every parameter. Furthermore, I tried to list every step so that anyone can easily follow this guide without the need to consult another reference. In cases where there is more than one good way to do something, I provided references to documentation which explains the alternative. I hope that you find this guide useful in setting up your own computer and in understanding the components of a Gentoo system.

****************
Installation
****************
This guide documents the installation of Gentoo Linux on my computer. The computer has the following parts:

* **CPU:** Intel Core i7-6700K 4.0GHz Quad-Core Processor
* **CPU Cooler:** Cooler Master Hyper 212 EVO 82.9 CFM Sleeve Bearing CPU Cooler
* **Motherboard:** ASRock Fatal1ty Z170 Gaming-ITX/ac Mini ITX LGA1151 Motherboard
* **Memory:** G.Skill Ripjaws V Series 32GB (2 x 16GB) DDR4-3200 Memory
* **Storage:** Mushkin Reactor 1TB 2.5" Solid State Drive
* **Case:** Fractal Design Define Nano S Mini ITX Desktop Case
* **Power Supply:** Cooler Master 550W 80+ Bronze Certified Semi-Modular ATX Power Supply
* **Keyboard:** Corsair STRAFE RGB Wired Gaming Keyboard
* **Mouse:** Corsair Sabre RGB Wired Optical Mouse

The Gentoo installation is hardened and set up with an encrypted root partition. The purpose of the encrypted root partition is so that if someone gains physical access to the hard drive, he cannot read your information. However, with only the root partition encrypted (the boot partition is not encrypted), an attacker can replace the boot programs with malicious ones [#attack]_. The only way to solve this problem is to put the boot partition on a flash drive, and ensure no one has access to the flash drive. The purpose of the hardened installation is to protect against vulnerabilities in software. Essentially, should some software have a vulnerability that a hacker would normally be able to exploit, on a hardened system, exploiting it will be much harder [#hardened]_.

*************
Setup
*************

This guide also documents the setup of the computer, including WiFi, sound, and printing.

*************
Cool stuff
*************

Finally, I list all the cool packages and neat tricks to make the computer as cool as possible.

*************
Conventions
*************

In this book, a ``$`` indicates a user prompt and ``#`` indicates a root prompt.

.. rubric:: Footnotes

.. [#attack] See this post: https://twopointfouristan.wordpress.com/.
.. [#hardened] For information about how exactly hardened software works, see the Gentoo wiki: https://wiki.gentoo.org/wiki/Hardened/Introduction_to_Hardened_Gentoo.
