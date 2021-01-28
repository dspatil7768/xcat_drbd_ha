#!/usr/bin/sh
# sequence generated on 2021-01-28 14:43:08 with: clufter 0.77.1
# invoked as: ['/usr/sbin/pcs', 'config', 'export', 'pcs-commands']
# targeting system: ('linux', 'centos', '7.4.1708', 'Core')
# using interpreter: CPython 2.7.5
pcs cluster auth shrestha1 shrestha <> /dev/tty
pcs cluster setup --name xCAT_Shreshta shrestha1 shrestha --transport udpu
pcs cluster start --all --wait=60
pcs cluster cib tmp-cib.xml
cp tmp-cib.xml tmp-cib.xml.deltasrc
pcs -f tmp-cib.xml property set stonith-enabled=false
pcs -f tmp-cib.xml property set no-quorum-policy=freeze
pcs -f tmp-cib.xml resource create vip_xCAT ocf:heartbeat:IPaddr2 cidr_netmask=24 ip=172.10.1.170 nic=em2:0 op monitor interval=10s timeout=20s start interval=0s timeout=20s stop interval=0s timeout=20s
pcs -f tmp-cib.xml resource create drbd_fs ocf:linbit:drbd drbd_resource=xcatha op demote interval=0s timeout=90 monitor interval=60s notify interval=0s timeout=90 promote interval=0s timeout=90 reload interval=0s timeout=30 start interval=0s timeout=240 stop interval=0s timeout=100
pcs -f tmp-cib.xml resource create xcatfs ocf:heartbeat:Filesystem device=/dev/drbd0 directory=/xCATdrbd fstype=xfs op monitor interval=20s timeout=40s notify interval=0s timeout=60s start interval=0s timeout=60s stop interval=0s timeout=60s
pcs -f tmp-cib.xml resource create tftpboot_symlink ocf:heartbeat:symlink link=/tftpboot target=/xCATdrbd/xcat_tftpboot op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create etc_dhcp_symlink ocf:heartbeat:symlink link=/etc/dhcp target=/xCATdrbd/etc_dhcp op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create etc_xcat_symlink ocf:heartbeat:symlink link=/etc/xcat target=/xCATdrbd/etc_xcat op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create install_xcat_symlink ocf:heartbeat:symlink link=/install target=/xCATdrbd/install_xcat op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create keys_xcat_symlink ocf:heartbeat:symlink link=/root/.xcat target=/xCATdrbd/keys_xcat op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create opt_xcat_symlink ocf:heartbeat:symlink  link=/opt/xcat target=/xCATdrbd/opt_xcat op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create var_lib_dhcpd_symlink ocf:heartbeat:symlink link=/var/lib/dhcpd target=/xCATdrbd/var_lib_dhcpd op monitor interval=60s timeout=15 start interval=0s timeout=15s stop interval=0s timeout=15s
pcs -f tmp-cib.xml resource create ser_dhcp systemd:dhcpd op monitor interval=60 timeout=100 start interval=0s timeout=100 stop interval=0s timeout=100
pcs -f tmp-cib.xml resource create ser_xCAT systemd:xcatd op monitor interval=60 timeout=100 start interval=0s timeout=100 stop interval=0s timeout=100
pcs -f tmp-cib.xml resource group add symblinks tftpboot_symlink etc_dhcp_symlink etc_xcat_symlink install_xcat_symlink keys_xcat_symlink opt_xcat_symlink var_lib_dhcpd_symlink
pcs -f tmp-cib.xml resource group add Service ser_dhcp ser_xCAT
pcs -f tmp-cib.xml resource master drbd_fsClone drbd_fs master-node-max=1 clone-max=2 notify=true master-max=1 clone-node-max=1
pcs -f tmp-cib.xml constraint colocation add xcatfs with master drbd_fsClone id=colocation-xcatfs-drbd_fsClone-INFINITY
pcs -f tmp-cib.xml constraint order promote drbd_fsClone then xcatfs id=order-drbd_fsClone-xcatfs-mandatory
pcs -f tmp-cib.xml constraint location drbd_fsClone prefers shrestha1
pcs -f tmp-cib.xml constraint colocation add symblinks with xcatfs id=colocation-symblinks-xcatfs-INFINITY
pcs -f tmp-cib.xml constraint location vip_xCAT prefers shrestha1=100
pcs -f tmp-cib.xml constraint location vip_xCAT prefers shrestha=50
pcs -f tmp-cib.xml constraint colocation add master drbd_fsClone with vip_xCAT id=colocation-drbd_fsClone-vip_xCAT-INFINITY-1
pcs -f tmp-cib.xml constraint colocation add Service with symblinks id=colocation-Service-symblinks-INFINITY
pcs -f tmp-cib.xml constraint order set vip_xCAT drbd_fsClone xcatfs symblinks Service setoptions id=pcs_rsc_order_set_vip_xCAT_drbd_fsClone_xcatfs_symblinks_Service
pcs -f tmp-cib.xml alert create path=/var/lib/pacemaker/alert_file.sh id=alert_file 'description=Log events to a file.'
pcs -f tmp-cib.xml alert recipient add alert_file value=/var/log/pcmk_alert_file.log id=my-alert_logfile
pcs cluster cib-push tmp-cib.xml diff-against=tmp-cib.xml.deltasrc
