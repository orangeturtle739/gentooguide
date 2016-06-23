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

********************************
Configuring WiFi using ``wicd``
********************************

********************************
Sound
********************************

************************************
Common Unix Printing System (CUPS)
************************************

************************************
Desktop environment
************************************

.. rubric:: Footnotes

.. [#portagehashes] See https://forums-web2.gentoo.org/viewtopic-t-831293-start-0.html.