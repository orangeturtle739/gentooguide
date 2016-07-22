.. highlight:: console

#########
Setup
#########

This section covers setting up useful things on Gentoo.

************************************
Sudo
************************************

The ``sudo`` command lets you run commands as root. One important ``USE`` flag is ``offensive``, which makes ``sudo`` print insults when the user types the wrong password. Set the ``USE`` flag with the following command::

    # echo "app-admin/sudo offensive" > /etc/portage/package.use/sudo

The ``offensive`` flag greatly improves ``sudo``::

    $ sudo -i
    Password:
    Hold it up to the light --- not a brain in sight!
    Password:
    It can only be attributed to human error.
    Password:
    sudo: 3 incorrect password attempts
    $ sudo -i
    Password:
    Maybe if you used more than just two fingers...
    Password:
    My mind is going. I can feel it.
    Password:
    $ sudo -i
    Password:
    My pet ferret can type better than you!
    Password:
    I've seen penguins that can type better than that.
    Password:
    sudo: 3 incorrect password attempts

Then, install ``sudo``::

    # emerge app-admin/sudo

.. highlight:: shell

The sudoers file is ``/etc/sudoers``. It says at the top it must be edited using the ``visudo`` command::

    ## This file MUST be edited with the 'visudo' command as root.
    ## Failure to use 'visudo' may result in syntax or file permission errors
    ## that prevent sudo from running.

To allow all users in the ``wheel`` group to execute all commands with ``sudo``, uncomment the following line::

    %wheel ALL=(ALL) ALL

.. highlight:: console

********************************
GPG signed portage snapshots
********************************
Setting up portage to verify the tree with GPG signatures ensures that the tree is authentic and has not been changed by anyone other than the Gentoo developers. While portage does checks the hashes of source code it downloads against those in the portage tree [#portagehashes]_, it does not by default verify that the tree (and the hashes in it) are authentic. Thus, an attacker could launch a man-in-the-middle-attack and change the manifests and source code location in the tree. Then, when you installed the package the hacker changed, you would get a malicious version. To solve this problem, configure portage to verify the tree. First, get the Gentoo GPG keys::

   # emerge app-crypt/gentoo-keys

.. highlight:: shell

Then, add ``webrsync-gpg`` to the ``FEATURES`` variable in ``/etc/portage/make.conf``, and also configure the ``PORTAGE_GPG_DIR``::

    # Enabled GPG support in Portage
    FEATURES="webrsync-gpg"
    PORTAGE_GPG_DIR="/var/lib/gentoo/gkeys/keyrings/gentoo/release"

Edit the gentoo section of ``/etc/portage/repos.conf/gentoo.conf`` to make is read as follows [#portagegpgconf]_::

    [gentoo]
    location = /usr/portage
    # Changed from rsync to webrsync ------------------
    sync-type = webrsync
    sync-uri = rsync://rsync.gentoo.org/gentoo-portage
    auto-sync = yes

.. highlight:: console

In order to the signatures to be valid, the keys must also be valid. To verify this, list the key fingerprints::

    # gpg --homedir /var/lib/gentoo/gkeys/keyrings/gentoo/release --with-fingerprint --list-keys
    gpg: WARNING: unsafe permissions on homedir `/var/lib/gentoo/gkeys/keyrings/gentoo/release'
    /var/lib/gentoo/gkeys/keyrings/gentoo/release/pubring.gpg
    ---------------------------------------------------------
    pub   4096R/F6CD6C97 2014-10-03 [expires: 2017-09-17]
          Key fingerprint = D2DE 1DBB A0F4 3EBA 341B  97D8 8255 33CB F6CD 6C97
    uid       [ unknown] Gentoo-keys Team <gkeys@gentoo.org>
    sub   4096R/151C3FC7 2014-10-03 [expires: 2017-09-17]

    pub   1024D/17072058 2004-07-20 [expires: 2016-08-13]
          Key fingerprint = D99E AC73 79A8 50BC E47D  A5F2 9E64 38C8 1707 2058
    uid       [ unknown] Gentoo Linux Release Engineering (Gentoo Linux Release Signing Key) <releng@gentoo.org>
    sub   2048g/1415B4ED 2004-07-20 [expires: 2016-08-13]

    pub   4096R/96D8BF6D 2011-11-25 [expires: 2016-07-01]
          Key fingerprint = DCD0 5B71 EAB9 4199 527F  44AC DB6B 8C1F 96D8 BF6D
    uid       [ unknown] Gentoo Portage Snapshot Signing Key (Automated Signing Key)
    sub   4096R/C9189250 2011-11-25 [expires: 2016-07-01]

    pub   4096R/2D182910 2009-08-25 [expires: 2017-08-25]
          Key fingerprint = 13EB BDBE DE7A 1277 5DFD  B1BA BB57 2E0E 2D18 2910
    uid       [ unknown] Gentoo Linux Release Engineering (Automated Weekly Release Key) <releng@gentoo.org>

Verify the fingerprints printed with those on Gentoo's website: https://wiki.gentoo.org/wiki/Project:RelEng#Keys. Of course, this verification is only as trustworthy as the HTTPS connection, but maybe the best you can do. To test it, run ``emerge --sync``. It should output something like this::

    Checking signature ...
    gpg: WARNING: unsafe permissions on homedir `/var/lib/gentoo/gkeys/keyrings/gentoo/release'
    gpg: Signature made Wed 22 Jun 2016 08:52:03 PM EDT using RSA key ID C9189250
    gpg: checking the trustdb
    gpg: no ultimately trusted keys found
    gpg: Good signature from "Gentoo Portage Snapshot Signing Key (Automated Signing Key)" [unknown]
    gpg: WARNING: This key is not certified with a trusted signature!
    gpg:          There is no indication that the signature belongs to the owner.
    Primary key fingerprint: DCD0 5B71 EAB9 4199 527F  44AC DB6B 8C1F 96D8 BF6D
         Subkey fingerprint: E1D6 ABB6 3BFC FB4B A02F  DF1C EC59 0EEA C918 9250

While it verified the signature, it prints warnings because the key is not signed by a trusted key. Since there is no easy way to verify the fingerprints without relying on HTTPS, you should not sign the key.

********************************
PaXtest
********************************

.. highlight:: shell

In order to verify that the PaX security extensions are working, use the ``PaXtest`` program. It is masked for amd64, so unmask it by editing ``/etc/portage/package.accept_keywords/paxtest``::

    # required by paxtest (argument)
    =app-admin/paxtest-0.9.14 ~amd64

.. highlight:: console

Install it, and then run it::

    $ paxtest blackhat
    PaXtest - Copyright(c) 2003-2014 by Peter Busser <peter@adamantix.org> and Brad Spengler <spender@grsecurity.net>
    Released under the GNU Public Licence version 2 or later

    Writing output to paxtest.log
    It may take a while for the tests to complete
    Test results:
    PaXtest - Copyright(c) 2003-2014 by Peter Busser <peter@adamantix.org> and Brad Spengler <spender@grsecurity.net>
    Released under the GNU Public Licence version 2 or later

    Mode: blackhat
    Linux greenhippogriff 4.4.8-hardened-r1 #15 SMP Thu Jul 7 21:37:20 EDT 2016 x86_64 Intel(R) Core(TM) i7-6700K CPU @ 4.00GHz GenuineIntel GNU/Linux

    Executable anonymous mapping             : Killed
    Executable bss                           : Killed
    Executable data                          : Killed
    Executable heap                          : Killed
    Executable stack                         : Killed
    Executable shared library bss            : Killed
    Executable shared library data           : Killed
    Executable anonymous mapping (mprotect)  : Killed
    Executable bss (mprotect)                : Killed
    Executable data (mprotect)               : Killed
    Executable heap (mprotect)               : Killed
    Executable stack (mprotect)              : Killed
    Executable shared library bss (mprotect) : Killed
    Executable shared library data (mprotect): Killed
    Writable text segments                   : Killed
    Anonymous mapping randomization test     : 33 quality bits (guessed)
    Heap randomization test (ET_EXEC)        : 22 quality bits (guessed)
    Heap randomization test (PIE)            : 40 quality bits (guessed)
    Main executable randomization (ET_EXEC)  : 33 quality bits (guessed)
    Main executable randomization (PIE)      : 33 quality bits (guessed)
    Shared library randomization test        : 33 quality bits (guessed)
    VDSO randomization test                  : 33 quality bits (guessed)
    Stack randomization test (SEGMEXEC)      : 40 quality bits (guessed)
    Stack randomization test (PAGEEXEC)      : 40 quality bits (guessed)
    Arg/env randomization test (SEGMEXEC)    : 44 quality bits (guessed)
    Arg/env randomization test (PAGEEXEC)    : 44 quality bits (guessed)
    Randomization under memory exhaustion @~0: 33 bits (guessed)
    Randomization under memory exhaustion @0 : 33 bits (guessed)
    Return to function (strcpy)              : paxtest: return address contains a NULL byte.
    Return to function (memcpy)              : Vulnerable
    Return to function (strcpy, PIE)         : paxtest: return address contains a NULL byte.
    Return to function (memcpy, PIE)         : Vulnerable

Note that the vulnerable functions are normal. See: https://wiki.gentoo.org/wiki/Hardened/Grsecurity2_Quickstart#Verifying_the_PaX_settings.

********************************
Setting up ccache
********************************
The compiler cache (ccache) speeds up compilation by saving output from previous compilations and reusing it if the source files have not changed. This is useful when updating software because not all the files will change. To use it, first install it::

    # emerge dev-util/ccache

.. highlight:: shell

The, add ``ccache`` to the ``FEATURES`` variable in ``/etc/portage/make.conf``, and also configure the ``CCACHE_SIZE``::

    FEATURES="webrsync-gpg ccache"
    CCACHE_SIZE="10G"

.. highlight:: console

To check the status of the cache, use::

    # CCACHE_DIR="/var/tmp/ccache" ccache -s
    cache directory                     /var/tmp/ccache
    primary config                      /var/tmp/ccache/ccache.conf
    secondary config      (readonly)    /etc/ccache.conf
    cache hit (direct)                  1096
    cache hit (preprocessed)            1729
    cache miss                         32775
    called for link                     3346
    called for preprocessing            3973
    multiple source files                  6
    compiler produced stdout               1
    compile failed                      1450
    preprocessor error                   513
    can't use precompiled header           6
    bad compiler arguments               380
    unsupported source language         1328
    autoconf compile/link               9530
    unsupported compiler option           85
    no input file                       3983
    files in cache                     74286
    cache size                         694.7 MB
    max cache size                      10.0 GB

********************************
Configuring WiFi using ``wicd``
********************************

The Wireless Interface Connection Daemon (``wicd``) is a lightweight daemon for managing wired and wireless connections [#wicd]_. It can automatically switch to a wired connection if one becomes available, and also switch to a wireless connection if there is no wired connection. It also has a ncurses user interface. To emerge it, first set the ``ncurses`` use flag::

    # echo "net-misc/wicd ncurses" > /etc/portage/package.use/wicd

Then emerge it::

    # emerge net-misc/wicd

Make it start on boot::

    # rc-update add wicd default

Also, make sure no other network scripts run at boot. For example, to remove the standard netifrc ethernet script, run::

    # rc-update del net.enp0s31f6

Then, run the ``wicd`` configuration program::

    # wicd-curses

My computer had a ``BCM4352`` chip, so I had to emerge the ``net-wireless/broadcom-sta`` package. Unfortunately, this package is a proprietary binary package. The package requires the following settings::

    B43: If you insist on building this, you must blacklist it!
    BCMA: If you insist on building this, you must blacklist it!
    SSB: If you insist on building this, you must blacklist it!
    LIB80211: Please enable it. If you can't find it: enabling the driver for "Intel PRO/Wireless 2100" or "Intel PRO/Wireless 2200BG" (IPW2100 or IPW2200) should suffice.
    MAC80211: If you insist on building this, you must blacklist it!
    LIB80211_CRYPT_TKIP: You will need this for WPA.

For information about other Broadcom chips, see: https://wireless.wiki.kernel.org/en/users/Drivers/b43#Supported_devices.

********************************
Sound
********************************

ALSA Setup
==============

ALSA is the Advanced Linux Sound Architecture [#alsawiki]_. The sound might just work. But, if it does not or you want to change the sound output, first list the sound devices::

    # aplay -L
    null
        Discard all samples (playback) or generate zero samples (capture)
    default:CARD=PCH
        HDA Intel PCH, ALC1150 Analog
        Default Audio Device
    sysdefault:CARD=PCH
        HDA Intel PCH, ALC1150 Analog
        Default Audio Device
    front:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        Front speakers
    surround21:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        2.1 Surround output to Front and Subwoofer speakers
    surround40:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        4.0 Surround output to Front and Rear speakers
    surround41:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        4.1 Surround output to Front, Rear and Subwoofer speakers
    surround50:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        5.0 Surround output to Front, Center and Rear speakers
    surround51:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        5.1 Surround output to Front, Center, Rear and Subwoofer speakers
    surround71:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Analog
        7.1 Surround output to Front, Center, Side, Rear and Woofer speakers
    iec958:CARD=PCH,DEV=0
        HDA Intel PCH, ALC1150 Digital
        IEC958 (S/PDIF) Digital Audio Output
    hdmi:CARD=PCH,DEV=0
        HDA Intel PCH, HDMI 0
        HDMI Audio Output
    hdmi:CARD=PCH,DEV=1
        HDA Intel PCH, HDMI 1
        HDMI Audio Output
    hdmi:CARD=PCH,DEV=2
        HDA Intel PCH, HDMI 2
        HDMI Audio Output

You can also look at ``/proc/asound/cards``::

    # cat /proc/asound/cards
     0 [PCH            ]: HDA-Intel - HDA Intel PCH
                          HDA Intel PCH at 0xdf440000 irq 136

Then, test them with ``speaker-test``::

    # speaker-test -Dfront:PCH -c2 -twav

    speaker-test 1.0.29

    Playback device is front:PCH
    Stream parameters are 48000Hz, S16_LE, 2 channels
    WAV file(s)
    Rate set to 48000Hz (requested 48000Hz)
    Buffer size range from 64 to 16384
    Period size range from 32 to 8192
    Using max buffer size 16384
    Periods = 4
    was set period_size = 4096
    was set buffer_size = 16384
     0 - Front Left
     1 - Front Right

Change the device until it works. For example, to use HDMI, try ``-Dhdmi:PCH``. To make the device which works the default, use a ``.asoundrc`` file in your home directory. When I use a ``genkernel`` kernel, I need the following ``.asoundrc`` to make sound work::

    pcm.!default{
        type hw
        card 0
        device 0
    }

However, with my manually-configured kernel, sound works find without the ``.asoundrc``. For more information about the ``.asoundrc`` file, see: http://www.alsa-project.org/main/index.php/Asoundrc.

Playing Music
==============

The simplest way to play music from the command line is with ``media-sound/sox``. Install it with the following ``USE`` flags:

* ``amr``: adds support for Adaptive Multi-Rate Audio support
* ``flac``: adds support for the Free Lossless Audio Codec
* ``mad``: adds support for MP3
* ``ogg``: adds support for for ogg files
* ``wavpack``: adds support for wav files
* ``encode``: adds support for encoding

To set the ``USE`` flags, put them in ``/etc/protage/package.use/sox``::

    # echo "media-sound/sox amr flac mad ogg wavpack encode" > /etc/protage/package.use/sox

Then, play music with ``play``::

    # play Koji\ Kondo/The\ Legend\ Of\ Zelda\ 25th\ Anniversary\ Soundtrack/01\ -\ The\ Legend\ Of\ Zelda\ 25th\ Anniversary\ Medley.mp3
    play WARN alsa: can't encode 0-bit Unknown or not applicable

    Koji Kondo/The Legend Of Zelda 25th Anniversary Soundtrack/01 - The Legend Of Zelda 25th Anniversary Medley.mp3:

     File Size: 16.0M     Bit Rate: 263k
      Encoding: MPEG audio
      Channels: 2 @ 16-bit
    Samplerate: 44100Hz
    Replaygain: off
      Duration: 00:08:08.41

    In:0.00% 00:00:00.00 [00:08:08.41] Out:0     [      |      ]        Clip:0

For some reason, adding the flag ``-t alsa`` prevents the ``can't encode 0-bit`` warning [#bitwarning]_.

************************************
GRUB Default Boot Choice
************************************

.. highlight:: shell

In order to set the default boot choice in GRUB, edit the ``GRUB_DEFAULT`` variable in ``/etc/default/grub``. It identifies the kernel, with counting starting from 0. For example, to boot the 5\ :sup:`th` kernel on the menu, use::

    GRUB_DEFAULT=4

In order for this to work, I had to disable the GRUB submenus::

    GRUB_DISABLE_SUBMENU=y

.. highlight:: console

************************************
Layman
************************************

.. highlight:: console

Layman (``app-portage/layman``) is a program which makes it easy to manage overlays. When I installed the most recent unmaksed version (2.0.0-r3), I got the following warning::

    !!! Repository 'x-portage' is missing masters attribute in '/usr/local/portage/metadata/layout.conf'
    !!! Set 'masters = gentoo' in this file for future compatibility

.. highlight:: console

While I could fix the warning by creating that file and putting the line ``masters = gentoo`` in it, I decided to try the new version of layman (2.4.1-r1), even though it was masked for amd64. To install it, first set the the following ``USE`` flags:

* ``git``: for supporting overlays from git
* ``gpg``: for verifying overlays, but I am not sure if it is used
* ``sync-plugin-portage``: for using portage's plugin system, which is what makes the new version different from the old one

To set the ``USE`` flags, put them in ``/etc/protage/package.use/layman``::

    # echo "app-portage/layman sync-plugin-portage gpg" > /etc/protage/package.use/layman

In order to determine the keyword changes necessary, try to emerge it::

    emerge -pv =layman-2.4.1-r1

.. highlight:: shell

I had to make the following keyword changes in ``/etc/portage/package.accept_keywords/layman``::

    # required by app-portage/layman-2.4.1-r1::gentoo
    # required by =layman-2.4.1-r1 (argument)
    =dev-python/ssl-fetch-0.4 ~amd64
    # required by =layman-2.4.1-r1 (argument)
    =app-portage/layman-2.4.1-r1 ~amd64
    # required by app-portage/layman-2.4.1-r1::gentoo[gpg]
    # required by =layman-2.4.1-r1 (argument)
    =dev-python/pyGPG-0.2 ~amd64

.. highlight:: console

Run ``layman-updater`` to set it up::

    # layman-updater -R
     *   Creating layman's repos.conf file
     *   You are now ready to add overlays into your system.
     *
     *     layman -L
     *
     *   will display a list of available overlays.
     *
     *   Select an overlay and add it using
     *
     *     layman -a overlay-name
     *

************************************
Avahi Daemon
************************************

The Avahi mDNS/DNS-SD daemon allows you to find computers and other things by name on the local network. It has two components: the daemon, ``net-dns/avahi``, and the client, ``sys-auth/nss-mdns``. In order to get the ``avahi-browse`` command and lots of other useful commands, ``avahi`` needs the ``dbus`` ``USE`` flag. To set the ``USE`` flags, put them in ``/etc/protage/package.use/avahi``::

    # echo "net-dns/avahi dbus" > /etc/protage/package.use/avahi

After installing, start the daemon::

    # rc-update add avahi-daemon default
    # rc-service avahi-daemon start

To configure the client, edit the ``/etc/nsswitch.conf`` file. Find the line::

    hosts:       files dns

Change it to::

    hosts:       files mdns_minimal [NOTFOUND=return] dns mdns

While this option enables IPv6 support, to use only IPv4, instead use the line::

    hosts:       files mdns4_minimal [NOTFOUND=return] dns mdns4

If this line is wrong, the DNS system will not work properly (you will be able to ping 8.8.8.8, but not google.com). You should now be able to ping your computer::

    # ping hostname.local

************************************
Common Unix Printing System (CUPS)
************************************

First, emerge ``net-print/cups``. For a USB printer, set the ``usb`` ``USE`` flag. However, if USB printer support is enabled in the kernel, do not set the USB use flag. In order for CUPS to work properly, it needs to interface with Avahi, and so must have the ``zeroconf`` and ``dbus`` flags.

Add users who will need to print to the ``lp`` group::

    # gpasswd -a username lp

Add users who will need to add printers to the ``lpadmin`` group::

    # gpasswd -a username lpadmin

Make the CUPS daemon start at boot::

    # rc-update add cupsd default

Scan for printers with ``lpinfo``::

    # lpinfo -l -v
    Device: uri = https
            class = network
            info = Internet Printing Protocol (https)
            make-and-model = Unknown
            device-id =
            location =
    Device: uri = ipps
            class = network
            info = Internet Printing Protocol (ipps)
            make-and-model = Unknown
            device-id =
            location =
    Device: uri = http
            class = network
            info = Internet Printing Protocol (http)
            make-and-model = Unknown
            device-id =
            location =
    Device: uri = lpd
            class = network
            info = LPD/LPR Host or Printer
            make-and-model = Unknown
            device-id =
            location =
    Device: uri = ipp
            class = network
            info = Internet Printing Protocol (ipp)
            make-and-model = Unknown
            device-id =
            location =
    Device: uri = socket
            class = network
            info = AppSocket/HP JetDirect
            make-and-model = Unknown
            device-id =
            location =
    Device: uri = lpd://BRW008092859C92/BINARY_P1
            class = network
            info = Brother MFC-8950DW
            make-and-model = Brother MFC-8950DW
            device-id = MFG:Brother;CMD:PJL,PCL,PCLXL,URF;MDL:MFC-8950DW;CLS:PRINTER;CID:Brother Laser Type2;URF:W8,CP1,IS11-19-4,MT1-3-4-5-8-11,OB10,PQ4,RS300-600-1200,DM1;
            location = spaceport
    Device: uri = dnssd://Brother%20MFC-8950DW._ipp._tcp.local/?uuid=e3248000-80ce-11db-8000-001ba9c62678
            class = network
            info = Brother MFC-8950DW
            make-and-model = Brother MFC-8950DW
            device-id = MFG:Brother;MDL:MFC-8950DW;CMD:PJL,PCL,PCLXL,URF;
            location =

To get a shorter output, just use the ``-v`` flag::

    # lpinfo -v
    network https
    network ipps
    network http
    network lpd
    network ipp
    network socket
    network dnssd://Brother%20MFC-8950DW._ipps._tcp.local/?uuid=e3248000-80ce-11db-8000-001ba9c62678
    network lpd://BRW008092859C92/BINARY_P1

Above, the ``dnssd`` addresses use the Internet Printing Protocol (IPP), which is newer than the LPD protocol the other addresses use [#cupsprotocol]_. IPP also provides bidirectional communication, while LPD does not. Thus, choose IPP when possible.

Look at the available drivers using ``lpinfo``::

    # lpinfo -m
    lsb/usr/cupsfilters/Fuji_Xerox-DocuPrint_CM305_df-PDF.ppd Fuji Xerox
    brother-BrGenML1-cups-en.ppd Brother BrGenML1 for CUPS
    drv:///sample.drv/dymo.ppd Dymo Label Printer
    drv:///sample.drv/epson9.ppd Epson 9-Pin Series
    drv:///sample.drv/epson24.ppd Epson 24-Pin Series
    drv:///cupsfilters.drv/pwgrast.ppd Generic IPP Everywhere Printer
    drv:///sample.drv/generpcl.ppd Generic PCL Laser Printer
    lsb/usr/cupsfilters/Generic-PDF_Printer-PDF.ppd Generic PDF Printer
    drv:///sample.drv/generic.ppd Generic PostScript Printer
    lsb/usr/cupsfilters/textonly.ppd Generic text-only printer
    lsb/usr/cupsfilters/HP-Color_LaserJet_CM3530_MFP-PDF.ppd HP Color LaserJet CM3530 MFP PDF
    lsb/usr/cupsfilters/pxlcolor.ppd HP Color LaserJet Series PCL 6 CUPS
    drv:///cupsfilters.drv/dsgnjt600pcl.ppd HP DesignJet 600 pcl, 1.0
    drv:///cupsfilters.drv/dsgnjt750cpcl.ppd HP DesignJet 750c pcl, 1.0
    drv:///cupsfilters.drv/dsgnjt1050cpcl.ppd HP DesignJet 1050c pcl, 1.0
    drv:///cupsfilters.drv/dsgnjt4000pcl.ppd HP DesignJet 4000 pcl, 1.0
    drv:///cupsfilters.drv/dsgnjtt790pcl.ppd HP DesignJet T790 pcl, 1.0
    drv:///cupsfilters.drv/dsgnjtt1100pcl.ppd HP DesignJet T1100 pcl, 1.0
    drv:///sample.drv/deskjet.ppd HP DeskJet Series
    drv:///sample.drv/laserjet.ppd HP LaserJet Series PCL 4/5
    lsb/usr/cupsfilters/pxlmono.ppd HP LaserJet Series PCL 6 CUPS
    lsb/usr/cupsfilters/HP-PhotoSmart_Pro_B8300-hpijs-pdftoijs.ppd HP PhotoSmart Pro B8300 CUPS/pdftoijs/hpijs
    drv:///sample.drv/intelbar.ppd Intellitech IntelliBar Label Printer, 2.1
    drv:///sample.drv/okidata9.ppd Oki 9-Pin Series
    drv:///sample.drv/okidat24.ppd Oki 24-Pin Series
    raw Raw Queue
    lsb/usr/cupsfilters/Ricoh-PDF_Printer-PDF.ppd Ricoh PDF Printer
    drv:///sample.drv/zebracpl.ppd Zebra CPCL Label Printer
    drv:///sample.drv/zebraep1.ppd Zebra EPL1 Label Printer
    drv:///sample.drv/zebraep2.ppd Zebra EPL2 Label Printer
    drv:///sample.drv/zebra.ppd Zebra ZPL Label Printer

Then, install the printer::

    # lpadmin -p Brother_MFC-8950DW -E -v dnssd://Brother%20MFC-8950DW._ipps._tcp.local/?uuid=e3248000-80ce-11db-8000-001ba9c62678 -m brother-BrGenML1-cups-en.ppd

Verify the setup with ``lpstat``::

    # lpstat -d -l -t
    system default destination: Brother_MFC-8950DW
    scheduler is running
    system default destination: Brother_MFC-8950DW
    device for Brother_MFC-8950DW: dnssd://Brother%20MFC-8950DW._ipps._tcp.local/?uuid=e3248000-80ce-11db-8000-001ba9c62678
    Brother_MFC-8950DW accepting requests since Tue 19 Jul 2016 06:42:55 AM EDT
    printer Brother_MFC-8950DW is idle.  enabled since Tue 19 Jul 2016 06:42:55 AM EDT
    	Form mounted:
    	Content types: any
    	Printer types: unknown
    	Description: Brother_MFC-8950DW
    	Alerts: none
    	Location:
    	Connection: direct
    	Interface: /etc/cups/ppd/Brother_MFC-8950DW.ppd
    	On fault: no alert
    	After fault: continue
    	Users allowed:
    		(all)
    	Forms allowed:
    		(none)
    	Banner required
    	Charset sets:
    		(none)
    	Default pitch:
    	Default page size:
    	Default port settings:

To set the default printer for a user, use ``lpoptions``::

    $ lpoptions -d Brother_MFC-8950DW
    copies=1 device-uri=dnssd://Brother%20MFC-8950DW._ipps._tcp.local/?uuid=e3248000-80ce-11db-8000-001ba9c62678 finishings=3 job-cancel-after=10800 job-hold-until=no-hold job-priority=50 job-sheets=none,none marker-change-time=0 number-up=1 printer-commands=AutoConfigure,Clean,PrintSelfTestPage printer-info=Brother_MFC-8950DW printer-is-accepting-jobs=true printer-is-shared=true printer-location printer-make-and-model='Brother BrGenML1 for CUPS ' printer-state=3 printer-state-change-time=1468924975 printer-state-reasons=none printer-type=8425492 printer-uri-supported=ipp://localhost/printers/Brother_MFC-8950DW

To view all the options for the printer, use ``-l``::

    $ lpoptions -p Brother_MFC-8950DW -l
    OptionTrays/Number of Input Trays: *1Trays 2Trays 3Trays
    PageSize/Media Size: Custom.WIDTHxHEIGHT Letter Legal Executive FanFoldGermanLegal *A4 A5 A6 Env10 EnvMonarch EnvDL EnvC5 ISOB5 B5 ISOB6 B6 4x6 Postcard DoublePostcardRotated EnvYou4 195x270mm 184x260mm 197x273mm CUSTOM1 CUSTOM2 CUSTOM3
    BrMediaType/MediaType: *PLAIN THIN THICK THICKERPAPER2 BOND ENV ENVTHICK ENVTHIN
    InputSlot/InputSlot: MPTRAY TRAY1 TRAY2 TRAY3 MANUAL *AUTO
    Duplex/Duplex: DuplexTumble DuplexNoTumble *None
    Resolution/Resolution: 300dpi *600dpi 600x300dpi 2400x600dpi 1200dpi
    TonerSaveMode/Toner Save: *OFF ON
    Sleep/Sleep Time [Min.]: *PrinterDefault 2minutes 10minutes 30minutes

Set the options for the printer using the ``-o`` flag for each option::

    $ lpoptions -p Brother_MFC-8950DW -o PageSize=Letter -o Duplex=DuplexNoTumble -o TonerSaveMode=ON

    $ lpoptions -p Brother_MFC-8950DW -l
    OptionTrays/Number of Input Trays: *1Trays 2Trays 3Trays
    PageSize/Media Size: Custom.WIDTHxHEIGHT *Letter Legal Executive FanFoldGermanLegal A4 A5 A6 Env10 EnvMonarch EnvDL EnvC5 ISOB5 B5 ISOB6 B6 4x6 Postcard DoublePostcardRotated EnvYou4 195x270mm 184x260mm 197x273mm CUSTOM1 CUSTOM2 CUSTOM3
    BrMediaType/MediaType: *PLAIN THIN THICK THICKERPAPER2 BOND ENV ENVTHICK ENVTHIN
    InputSlot/InputSlot: MPTRAY TRAY1 TRAY2 TRAY3 MANUAL *AUTO
    Duplex/Duplex: DuplexTumble *DuplexNoTumble None
    Resolution/Resolution: 300dpi *600dpi 600x300dpi 2400x600dpi 1200dpi
    TonerSaveMode/Toner Save: OFF *ON
    Sleep/Sleep Time [Min.]: *PrinterDefault 2minutes 10minutes 30minutes

For duplex, ``DuplexTumble`` means short-side stapling and ``DuplexNoTumble`` means long-side stapling.

To print a test page from the command line, use::

    $ locate testprint
    /usr/share/cups/data/testprint
    $ lp /usr/share/cups/data/testprint
    request id is Brother_MFC-8950DW-9 (1 file(s))

Brother Printers
===================================

This section explains how I installed the driver for my Brother printer [#brotherprinters]_.

To get the Brother printer drivers, the easiest way is to use the Brother overlay: https://github.com/stefan-langenmaier/brother-overlay/tree/master/. Install the overlay with Layman::

    # layman -o https://raw.github.com/stefan-langenmaier/brother-overlay/master/repositories.xml -f -a brother-overlay

     * Fetching remote list...
     * Fetch Ok

     * Adding overlay...
     * Overlay "brother-overlay" is not official. Continue installing? [y/n]: y
     * Running Git... # ( cd /var/lib/layman  && /usr/bin/git clone git://github.com/stefan-langenmaier/brother-overlay.git /var/lib/layman/brother-overlay )
    Cloning into '/var/lib/layman/brother-overlay'...
    remote: Counting objects: 2077, done.
    remote: Total 2077 (delta 0), reused 0 (delta 0), pack-reused 2077
    Receiving objects: 100% (2077/2077), 386.25 KiB | 166.00 KiB/s, done.
    Resolving deltas: 100% (1018/1018), done.
    Checking connectivity... done.
     * Running Git... # ( cd /var/lib/layman/brother-overlay  && /usr/bin/git config user.name "layman" )
     * Running Git... # ( cd /var/lib/layman/brother-overlay  && /usr/bin/git config user.email "layman@localhost" )
     * Successfully added overlay(s) brother-overlay.

Search for the printer driver::

    # eix *8950*
    * media-gfx/brother-mfc8950dw-bin [1]
         Available versions:  1.0
         Homepage:            http://support.brother.com
         Description:         Scanner driver for Brother MFC-8950DW (brscan4)

    * net-print/brother-mfc8950dw-bin [1]
         Available versions:  1.0
         Installed versions:  1.0(06:37:35 AM 07/19/2016)
         Homepage:            http://support.brother.com
         Description:         Printer driver for Brother MFC-8950DW (brgenml1)

    * net-print/brother-mfc8950dwt-bin [1]
         Available versions:  1.0
         Homepage:            http://support.brother.com
         Description:         Printer driver for Brother MFC-8950DWT (brgenml1)

    [1] "brother-overlay" /usr/local/portage/brother-overlay

    Found 3 matches

The ``net-print`` prefix contains the printer drivers, and the ``media-gfx`` contains the scanner drivers.

************************************
Sensors
************************************

The ``sys-apps/lm_sensors`` allows the computer to detect the processor temperature, fan speed, and other things. I used the ``sensord`` use flag to get a daemon which can log the sensor data, but I never used the daemon. Install the package, and then run ``sensors-detect`` to determine which kernel modules are needed for the sensors. I think this only works properly if all the possible sensor drivers are built as modules already, and then the program determines which ones need to be used. I had to use the following kernel modules::

    # For sensors
    I2C support --->
        -*- I2C support
        <*>	  I2C device interface
    -*- Hardware Monitoring support --->
        <*> Intel Core/Core2/Atom temperature sensor
        <*> Nuvoton NCT6775F and compatibles

I figured them out using a test Ubuntu installation, which had all the modules built. I am not sure if there is an easier way to do it. Once that is done, run ``sensors`` to get the readings::

    $ sensors
    coretemp-isa-0000
    Adapter: ISA adapter
    Physical id 0:  +19.0°C  (high = +80.0°C, crit = +100.0°C)
    Core 0:         +16.0°C  (high = +80.0°C, crit = +100.0°C)
    Core 1:         +17.0°C  (high = +80.0°C, crit = +100.0°C)
    Core 2:         +16.0°C  (high = +80.0°C, crit = +100.0°C)
    Core 3:         +18.0°C  (high = +80.0°C, crit = +100.0°C)

    nct6791-isa-0290
    Adapter: ISA adapter
    in0:                    +0.38 V  (min =  +0.00 V, max =  +1.74 V)
    in1:                    +1.70 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in2:                    +3.41 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in3:                    +3.41 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in4:                    +1.02 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in5:                    +1.02 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in6:                    +1.02 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in7:                    +3.50 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in8:                    +3.22 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in9:                    +1.02 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in10:                   +0.00 V  (min =  +0.00 V, max =  +0.00 V)
    in11:                   +0.97 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in12:                   +1.38 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in13:                   +1.28 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    in14:                   +1.07 V  (min =  +0.00 V, max =  +0.00 V)  ALARM
    fan1:                   903 RPM  (min =    0 RPM)
    fan2:                   738 RPM  (min =    0 RPM)
    fan3:                   549 RPM  (min =    0 RPM)
    fan4:                     0 RPM  (min =    0 RPM)
    fan5:                     0 RPM  (min =    0 RPM)
    fan6:                     0 RPM
    SYSTIN:                 +29.0°C  (high =  +0.0°C, hyst =  +0.0°C)  ALARM  sensor = thermistor
    CPUTIN:                 +24.0°C  (high = +80.0°C, hyst = +75.0°C)  sensor = thermistor
    AUXTIN0:                +25.0°C    sensor = thermistor
    AUXTIN1:               -128.0°C    sensor = thermistor
    AUXTIN2:                +28.0°C    sensor = thermistor
    AUXTIN3:                +22.0°C    sensor = thermistor
    PECI Agent 0:           +18.5°C  (high = +80.0°C, hyst = +75.0°C)
                                     (crit = +100.0°C)
    PCH_CHIP_CPU_MAX_TEMP:   +0.0°C
    PCH_CHIP_TEMP:           +0.0°C
    PCH_CPU_TEMP:            +0.0°C
    intrusion0:            ALARM
    intrusion1:            ALARM
    beep_enable:           disabled

The core temperatures are way too low to be right; 17-19 °C is far below room temperature. I believe they are off by about 20 °C because the UEFI setup tool shows that the processor idles at around 38 °C.

************************************
Locate
************************************

The ``sys-apps/mlocate`` makes it easy to locate files. See more information here: https://wiki.gentoo.org/wiki/Mlocate.

************************************
Desktop environment
************************************

Coming soon!

.. rubric:: Footnotes

.. [#portagehashes] See https://forums-web2.gentoo.org/viewtopic-t-831293-start-0.html.
.. [#portagegpgconf] This is simliar to the Gentoo website (https://wiki.gentoo.org/wiki/Handbook:AMD64/Working/Features#Validated_Portage_tree_snapshots), but I had to modify it to make it work.
.. [#wicd] See https://wiki.gentoo.org/wiki/Wicd.
.. [#alsawiki] See https://wiki.gentoo.org/wiki/ALSA.
.. [#bitwarning] See https://github.com/floere/playa/issues/6.
.. [#layman] See https://wiki.gentoo.org/wiki/Layman.
.. [#cupsprotocol] See http://askubuntu.com/questions/401119/should-i-set-up-my-cups-printing-to-use-ipp-lpd-or-url.
.. [#brotherprinters] For more information about Brother printers, see: https://wiki.gentoo.org/wiki/Brother_networked_printer.
