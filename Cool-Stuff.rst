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

``figlet``
==============

``figlet`` (``app-misc/figlet``) also makes ASCII art. Try it: ``figlet Hello World``.

************************************
Cool tricks
************************************

Cool login prompts with ``/etc/motd`` and ``/etc/issue``
===================================================================
Coming soon!

Nice console font with ``consolefont``
===================================================================

This makes the console font more readable. Install ``media-fonts/terminus-font``. The available console fonts are in ``/usr/share/consolefonts/``. Test the fonts with ``setfont fontname``, leaving off the extension in the name. To reset the font to the default, use ``setfont``. Set the font in ``/etc/conf.d/consolefont`` with ``consolefont="ter-v18b"`` (I chose ``ter-v18b``). Finally, add ``consolefont`` to the boot runlevel::

    # rc-update add consolefont boot 

ASCII art Linux penguin at boot with ``linux-logo``
===================================================================
Coming soon!

Cool grub theme
===================================================================

.. highlight:: shell

GRUB comes with a nice starfield theme, so I enabled in in `/etc/default/grub`::

    GRUB_THEME="/boot/grub/themes/starfield/theme.txt"

.. highlight:: console

************************************
Useful commands
************************************

Image a failing drive with ``dd``
===================================================================

Just make `dd` ignore the errors::

    # dd if=/dev/sdd of=/path/to/output/file.bin conv=noerror,sync

Mount images made with ``dd`` using ``losetup``
===================================================================

To mount the image made about (of a failing drive or a good drive) use ``losetup``::

    # losetup -P /dev/loop0 /path/to/super/cool/image.img

To unmount it, do::

   # losetup -d /dev/loop0