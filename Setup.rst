.. highlight:: console

#########
Setup
#########

This section covers setting up useful things on Gentoo.

********************************
GPG signed portage snapshots
********************************
Setting up portage to verify the tree with GPG signatures ensures that the tree is authentic and has not been changed by anyone other than the Gentoo developers. While portage does checks the hashes of source code it downloads against those in the portage tree [#portagehashes]_, it does not by default verify that the tree (and the hashes in it) are authentic. Thus, an attacker could launch a man in the middle attack and change the manifests and source code location in the tree. Then, when you installed the package the hacker changed, you would get a malicious version. To solve this problem, configure portage to verify the tree. First, get the Gentoo GPG keys::

   # emerge app-crypt/gentoo-keys

.. highlight:: shell

Then, add ``webrsync-gpg`` to the ``FEATURES`` variable in ``/etc/portage/make.conf``, and also configure the ``PORTAGE_GPG_DIR``::

    # Enabled GPG support in Portage
    FEATURES="webrsync-gpg"
    PORTAGE_GPG_DIR="/var/lib/gentoo/gkeys/keyrings/gentoo/release"

Edit the gentoo section of `/etc/portage/repos.conf/gentoo.conf`::

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

Verify the fingerprints printed with those on Gentoo's website: https://wiki.gentoo.org/wiki/Project:RelEng#Keys. Of course, this verification is only as trustworthy as the HTTPS connection, but it is the best you can do. To test it, run ``emerge --sync``. It should output something like this::

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

While it verified the signature, it prints warnings because the key is not signed by a trusted key. Since there is no easy way to verify the fingerprints without relaying on HTTPS, you should not sign the key, but can now be pretty confident that the portage tree is valid.

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

The Wireless Interface Connection Daemon (``wicd``) is a lightweight daemon for managing wired and wireless connections. It can automatically switch to a wired connection if one becomes available, and also switch to a wireless connection if there is no wired connection. It also has a ncurses user interface. To emerge it, first set the ``ncurses`` use flag::

    # echo "net-misc/wicd ncurses" > /etc/portage/package.use/wicd

Then emerge it::

    # emerge net-misc/wicd

Make it start on boot:

    # rc-update add wicd default

Also, make sure no other network scripts run at boot. For example, to remove the standard netifrc ethernet script, run::

    rc-update del net.enp0s31f6

Then, run the `wicd` configuration program::

    # wicd-curses

My computer had a `BCM4352` chip, so I had to emerge the ``net-wireless/broadcom-sta`` package. The package requires the following settings::

    B43: If you insist on building this, you must blacklist it!
    BCMA: If you insist on building this, you must blacklist it!
    SSB: If you insist on building this, you must blacklist it!
    LIB80211: Please enable it. If you can't find it: enabling the driver for "Intel PRO/Wireless 2100" or "Intel PRO/Wireless 2200BG" (IPW2100 or IPW2200) should suffice.
    MAC80211: If you insist on building this, you must blacklist it!
    LIB80211_CRYPT_TKIP: You will need this for WPA.

********************************
Sound
********************************

ALSA Setup
==============

The sound might just work. But, if it does not or you want to change the sound output, first list the sound devices::

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

However, with my manually-configured kernel, sound works find without the `.asoundrc`. For more information about the `.asoundrc` file, see: http://www.alsa-project.org/main/index.php/Asoundrc.

Playing Music
==============

The simplest way to play music from the command line is with `media-sound/sox`: https://packages.gentoo.org/packages/media-sound/sox. Install it with the following ``USE`` flags:

* ``amr``: adds support for Adaptive Multi-Rate Audio support
* ``flac``: adds support for the Free Lossless Audio Codec
* ``mad``: adds support for MP3
* ``ogg``: adds support for for ogg files
* ``wavpack``: adds support for wav files
* ``encode``: adds support for encoding

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

For some reason, adding the flag `-t alsa` prevents the `can't encode 0-bit` warning.

************************************
GRUB Default Boot Choice
************************************

.. highlight:: shell

In order to set the default boot choice in GRUB, edit the ``GRUB_DEFAULT`` variable in ``/etc/default/grub``. It identifies the kernel to start counting from 0. For example, to boot the 5\ :sup:`th` kernel on the menu, use::

    GRUB_DEFAULT=4

In order for this to work, I had to disable the GRUB submenus::

    GRUB_DISABLE_SUBMENU=y

.. highlight:: console

************************************
Common Unix Printing System (CUPS)
************************************

Coming soon!

************************************
Desktop environment
************************************

Coming soon!

.. rubric:: Footnotes

.. [#portagehashes] See https://forums-web2.gentoo.org/viewtopic-t-831293-start-0.html.