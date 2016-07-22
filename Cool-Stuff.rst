.. highlight:: console

###########
Cool Stuff
###########

This section covers all the cool packages and neat tricks.

************************************
Cool packages
************************************

``cowsay``
==============

The ``games-misc/cowsay`` package is a very important package::

     _____________________
    < Need I say anymore? >
     ---------------------
            \   ^__^
             \  (oo)\_______
                (__)\       )\/\
                    ||----w |
                    ||     ||

Be sure to check out all the cowfiles::

    $ cowsay -l
    Cow files in /usr/share/cowsay-3.03/cows:
    beavis.zen bong bud-frogs bunny cheese cower daemon default dragon
    dragon-and-cow elephant elephant-in-snake eyes flaming-sheep ghostbusters
    head-in hellokitty kiss kitty koala kosh luke-koala meow milk moofasa moose
    mutilated ren satanic sheep skeleton small sodomized stegosaurus stimpy
    supermilker surgery telebears three-eyes turkey turtle tux udder vader
    vader-koala www

``fortune``
==============

Just for fun: ``games-misc/fortune-mod``. Can be combined with cowsay::

    # fortune | cowsay -f tux
     ________________________________________
    / On two occasions I have been asked [by \
    | members of Parliament!], "Pray, Mr.    |
    | Babbage, if you put into the machine   |
    | wrong figures, will the right answers  |
    | come out?" I am not able rightly to    |
    | apprehend the kind of confusion of     |
    | ideas that could provoke such a        |
    | question.                              |
    |                                        |
    \ -- Charles Babbage                     /
     ----------------------------------------
       \
        \
            .--.
           |o_o |
           |:_/ |
          //   \ \
         (|     | )
        /'\_   _/`\
        \___)=(___/


``linux-logo``
==============

.. highlight:: none

Pretty self-explanatory (``app-misc/linux-logo``)::

    $ linux_logo -a -L gentoo-alt


                                                .
          .vir.                                d$b
       .d$$$$$$b.    .cd$$b.     .d$$b.   d$$$$$$$$$$$b  .d$$b.      .d$$b.
       $$$$( )$$$b d$$$()$$$.   d$$$$$$$b Q$$$$$$$P$$$P.$$$$$$$b.  .$$$$$$$b.
       Q$$$$$$$$$$B$$$$$$$$P"  d$$$PQ$$$$b.   $$$$.   .$$$P' `$$$ .$$$P' `$$$
         "$$$$$$$P Q$$$$$$$b  d$$$P   Q$$$$b  $$$$b   $$$$b..d$$$ $$$$b..d$$$
        d$$$$$$P"   "$$$$$$$$ Q$$$     Q$$$$  $$$$$   `Q$$$$$$$P  `Q$$$$$$$P
    |  $$$$$$$P       `"""""   ""        ""   Q$$$P     "Q$$$P"     "Q$$$P"
    |  `Q$$P"                                  """
    +--------------------------------------------------------- l  i  n  u  x

     Linux Version 4.4.8-hardened-r1, Compiled #14 SMP Mon Jun 20 14:01:32 EDT 2016
            Eight 4GHz Intel i7 Processors, 31.7GB RAM, 64127 Bogomips Total
                                    greenhippogriff

.. highlight:: console

Be sure to try all the logos::

    $ linux_logo -L list

    Available Built-in Logos:
            Num    Type    Ascii  Name            Description
            1      Banner  Yes    gentoo          Gentoo Logo
            2      Banner  Yes    gentoo-alt      Gentoo Linux Logo
            3      Banner  Yes    banner-simp     Simplified Banner Logo
            4      Banner  Yes    banner          The Default Banner Logo
            5      Classic Yes    classic-nodots  The Classic Logo, No Periods
            6      Classic Yes    classic-simp    Classic No Dots Or Letters
            7      Classic Yes    classic         The Default Classic Logo

    Do "linux_logo -L num" where num is from above to get the appropriate logo.
    Remember to also use -a to get ascii version.


``libcaca``
==============

This one (``media-libs/libcaca``) will set your computer on fire: ``aafire``. It can do more too.

``toilet``
==============

``toilet`` (``app-misc/toilet``) actually stands for The Other Implementations LETters. Makes ASCII art. Try it: ``toilet Hello World -f mono9 --gay``.
A useful option is ``-t`` which sets the output width to the width of the terminal. Also, ``--html`` outputs an HTML page. The available fonts are in ``/usr/share/figlet``.

``figlet``
==============

``figlet`` (``app-misc/figlet``) also makes ASCII art. Try it: ``figlet Hello World``.

************************************
Cool tricks
************************************

Cool login prompts with ``/etc/motd`` and ``/etc/issue``
===================================================================
The ``/etc/issue`` file is the login prompt. The default file was this::

    This is \n.\O (\s \m \r) \t

The program ``agetty`` parses ``/etc/issue``, supports the following escape sequences (from ``man agetty``)::

    b   Insert the baudrate of the current line.
    d   Insert the current date.
    s   Insert the system name, the name of the operating system.
    l   Insert the name of the current tty line.
    m   Insert the architecture identifier of the machine, e.g., i686.
    n   Insert the nodename of the machine, also known as the hostname.
    o   Insert the domainname of the machine.
    r   Insert the release number of the kernel, e.g., 2.6.11.12.
    t   Insert the current time.
    u   Insert the number of current users logged in.
    U   Insert the string "1 user" or "<n> users" where <n> is the
        number of current users logged in.
    v   Insert the version of the OS, e.g., the build-date etc.

.. highlight:: shell

An easy way to generate a nice ``/etc/issue`` file is with a script. I put mine in ``/root/scripts`` and called it ``issue.sh``. It looks like this::

    #! /bin/bash

    clear > /etc/issue
    linux_logo -L 2 >> /etc/issue
    echo -e "\n" >> /etc/issue
    echo "This is \n (\s \m \r) \t" >> /etc/issue

The script first deletes the file and replaces it with a new file which has the escape sequence which clears the screen. Then it appends to that file a nice gentoo logo, a blank line, and the standard message without the domain name.

The ``/etc/motd`` file is displayed whenever a user logs in. I wrote a script to generate that too::

    #! /bin/bash

    echo -e "\033[1;32m" > /etc/motd
    toilet -f slant "GreenHippogriff" -w 100 >> /etc/motd

.. highlight:: console

This script first writes the color code for green to the file, and then appends a nice ASCII art version of my computer name. The output looks like this (but in green)::

       ______                     __  ___                              _ ________
      / ____/_______  ___  ____  / / / (_)___  ____  ____  ____ ______(_) __/ __/
     / / __/ ___/ _ \/ _ \/ __ \/ /_/ / / __ \/ __ \/ __ \/ __ `/ ___/ / /_/ /_
    / /_/ / /  /  __/  __/ / / / __  / / /_/ / /_/ / /_/ / /_/ / /  / / __/ __/
    \____/_/   \___/\___/_/ /_/_/ /_/_/ .___/ .___/\____/\__, /_/  /_/_/ /_/
                                     /_/   /_/          /____/

Some common ANSI color escape codes are:

============== ===========
Color          Code
============== ===========
Black          ``0;30``
Dark Gray      ``1;30``
Red            ``0;31``
Light Red      ``1;31``
Green          ``0;32``
Light Green    ``1;32``
Brown/Orange   ``0;33``
Yellow         ``1;33``
Blue           ``0;34``
Light Blue     ``1;34``
Purple         ``0;35``
Light Purple   ``1;35``
Cyan           ``0;36``
Light Cyan     ``1;36``
Light Gray     ``0;37``
White          ``1;37``
No Color       ``0``
============== ===========

Nice console font with ``consolefont``
===================================================================

This makes the console font more readable. Install ``media-fonts/terminus-font`` [#terminus]_. The available console fonts are in ``/usr/share/consolefonts/``. Test the fonts with ``setfont fontname``, leaving off the extension in the name. To reset the font to the default, use ``setfont``. Set the font in ``/etc/conf.d/consolefont`` with ``consolefont="ter-v18b"`` (I chose ``ter-v18b``). Finally, add ``consolefont`` to the boot runlevel::

    # rc-update add consolefont boot

Before changing the console font, I sometimes had squares for quotes and other strange things, but changing the font fixed that [#squares]_.

ASCII art Linux penguin at boot with ``linux-logo``
===================================================================
Edit the ``/etc/conf.d/linux-logo``::

    # Seq   Description             Output
    # ----------------------------------------------------------------
    # ##                            #
    # #B    Bogomips                374.37
    # #C    Compiled Date           #47 Fri Jan 8 10:37:09 EST 1999
    # #E    User Text               My Favorite Linux Distribution
    #       Displayed with -t
    # #H    Hostname                deranged
    # #L    Load average            Load average 0.04, 0.01, 0.01
    # #M    Megahertz               188Mhz
    #       where supported
    # #N    Number of CPU's         Two
    # #O    OS Name                 Linux
    # #P    Processor or Processors Processor
    # #R    Ram                     64M
    #       in Megabytes
    # #S    Plural                  s
    # #T    Type of CPU             K6
    # #U    Uptime                  Uptime 10 hours 59 minutes
    # #V    Version of OS           2.2.0-pre5
    # #X    CPU Vendor              AMD
    # \\n   carriage return

    # Changed from gentoo to 3 ------------------------------------------------
    LOGO="-L 3"
    FORMAT="Gentoo #O `cat /etc/gentoo-release | awk '{ print $5,$6 }'`\n#O #V, Compiled #C\n#N #X #T #M CPU#S, #R RAM, #B Bogomips\n#U\n#H / \l  \n"
    FORMATNET="Gentoo #O `cat /etc/gentoo-release | awk '{ print $5,$6 }'`\n#O #V, Compiled #C\n#N #X #T #M CPU#S, #R RAM, #B Bogomips\n#U\n#H\n"
    OPTIONS="-f -u"

Add ``linux-logo`` to the default runlevel::

    # rc-update add linux-logo default

Note that the ``linux-logo`` init script overwrites ``/etc/issue``.

Cool grub theme
===================================================================

.. highlight:: shell

GRUB comes with a nice starfield theme, so I enabled in ``/etc/default/grub``::

    GRUB_THEME="/boot/grub/themes/starfield/theme.txt"

.. highlight:: console

************************************
Useful commands
************************************

Image a failing drive with ``dd``
===================================================================

.. highlight:: none

Just make ``dd`` ignore the errors::

    # dd if=/dev/sdd of=/path/to/output/file.bin conv=noerror,sync

.. highlight:: console

Mount images made with ``dd`` using ``losetup``
===================================================================

To mount an image made with ``dd`` (of a failing drive or a good drive) use ``losetup``::

    # losetup -P /dev/loop0 /path/to/super/cool/image.img

To unmount it, do::

   # losetup -d /dev/loop0

Use ``fdisk -l`` on a file
===================================================================

Perfect for an image made using ``dd``::

    # fdisk -l imagefile.img
    Disk imagefile.img: 233.8 GiB, 251000193024 bytes, 490234752 sectors
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: dos
    Disk identifier: 0xe9b7948b

    Device           Start       End   Sectors   Size Id Type
    imagefile.img1    2048    999423    997376   487M 83 Linux
    imagefile.img2 1001470 490233855 489232386 233.3G  5 Extended
    imagefile.img5 1001472 490233855 489232384 233.3G 83 Linux

.. rubric:: Footnotes

.. [#terminus] See https://www.artembutusov.com/modify-linux-kernel-font/.
.. [#squares] See https://forums.gentoo.org/viewtopic-t-980980-start-0.html.
