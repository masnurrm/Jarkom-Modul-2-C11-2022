echo 'nameserver 192.168.122.1
nameserver 8.8.8.8 ' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

echo 'nameserver 192.168.122.1
nameserver 8.8.8.8 ' > /etc/resolv.conf

echo 'zone "wise.c11.com" {
        type master;
        notify yes;
        also-notify { 10.15.3.2; };
        allow-transfer { 10.15.3.2; };
        file "/etc/bind/jarkom/wise.c11.com";
};
zone "2.15.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.15.10.in-addr.arpa";
}; ' > /etc/bind/named.conf.local

rm -r /etc/bind/jarkom
mkdir /etc/bind/jarkom

rm -r /etc/bind/operation
mkdir /etc/bind/operation

cp /etc/bind/db.local /etc/bind/jarkom/wise.c11.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.c11.com. root.wise.c11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      wise.c11.com.
@       IN      A       10.15.2.2
@       IN      AAAA    ::1 
www      IN      CNAME   wise.c11.com.
eden     IN      A       10.15.3.3
www.eden IN      CNAME      eden.wise.c11.com.
ns1     IN      A       10.15.3.3
operation       IN      NS      ns1 ' > /etc/bind/jarkom/wise.c11.com

echo 'options {
        directory "/var/cache/bind";
        allow-query{any;};
        auth-nxdomain no;
        listen-on-v6 { any; };
}; ' > /etc/bind/named.conf.options


cp /etc/bind/db.local /etc/bind/jarkom/2.15.10.in-addr.arpa

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.c11.com. root.wise.c11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
2.15.10.in-addr.arpa.   IN      NS      wise.c11.com.
2       IN      PTR     wise.c11.com. ' > /etc/bind/jarkom/2.15.10.in-addr.arpa

service bind9 restart