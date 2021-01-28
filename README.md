# xcat_drbd_ha
xCAT high availability configuration in PCS using DRBD as a shared storage

We will need one separate LVM on both nodes:

NAME             MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda                8:0    0 558.4G  0 disk
├─sda1             8:1    0   500M  0 part /boot
└─sda2             8:2    0 557.9G  0 part
  ├─centos-swap  253:1    0    75G  0 lvm  [SWAP]
  └─centos-home  253:2    0   500G  0 lvm  /home
sdb                8:16   0   1.7T  0 disk
└─sdb1             8:17   0   1.7T  0 part
  ├─centos-root  253:0    0   558G  0 lvm  /
  ├─centos-swap  253:1    0    75G  0 lvm  [SWAP]
  ├─centos-var   253:3    0   200G  0 lvm  /var
  ├─centos-opt   253:4    0   600G  0 lvm  /opt
  └─centos-drbd0 253:5    0   300G  0 lvm
    └─drbd0      147:0    0   300G  0 disk /xCATdrbd
sr0               11:0    1  1024M  0 rom
You have new mail in /var/spool/mail/root

