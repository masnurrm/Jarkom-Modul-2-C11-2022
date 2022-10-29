echo 'nameserver 192.168.122.1 ' > /etc/resolv.conf

apt-get update
apt-get install bind9 -y

echo 'options {
        directory "/var/cache/bind";
        allow-query{any;};
        auth-nxdomain no;
        listen-on-v6 { any; };
}; ' > /etc/bind/named.conf.options

echo 'zone "wise.c11.com" {
    type slave;
    masters { 10.15.2.2; };
    file "/var/lib/bind/wise.c11.com";
};
zone "operation.wise.c11.com" {
    type master;
    file "/etc/bind/operation/operation.wise.c11.com";
}; ' > /etc/bind/named.conf.local

rm -r /etc/bind/operation
mkdir /etc/bind/operation
cp /etc/bind/db.local /etc/bind/operation/operation.wise.c11.com

echo ';
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA      operation.wise.c11.com. root.operation.wise.c11.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      operation.wise.c11.com.
@       IN      A       10.15.3.3
www     IN      CNAME   operation.wise.c11.com.
strix           IN      A       10.15.3.3
www.strix       IN      A       10.15.3.3 ' > /etc/bind/operation/operation.wise.c11.com

service bind9 restart