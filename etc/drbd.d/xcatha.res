resource xcatha {
   net {
    protocol C;
    sndbuf-size            1024k ;
    rcvbuf-size            2048k;
  }
   disk {
    c-min-rate 80M;
    c-max-rate 720M;
  }
  on shrestha1 {
    device    /dev/drbd0;
    disk      /dev/centos/drbd0;
    address   192.168.1.1:7789;
    meta-disk internal;
  }
  on shrestha {
    device    /dev/drbd0;
    disk      /dev/centos/drbd0;
    address   192.168.1.2:7789;
    meta-disk internal;
  }
}
