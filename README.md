# **Jarkom-Modul-2-C11-2022**

*Repository* ini berisi laporan resmi dari praktikum modul 2 dari mata kuliah Jaringan Komputer tahun 2022.


## **Data Diri**
| Nama | Kelas-Kelompok | NRP |
| ------------- | ------------- |
| Nur Muhammad Ainul Yaqin | C-11 | 5025201011 |

## **Laporan Pengerjaan**

Laporan ini berisi penjelasan dari soal-soal yang dikerjakan pada modul 2 hingga masa revisi selesai.

### **Soal 1**
**WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet.**

- **Konfigurasi IP Address**

    Konfigurasi Ostania

    ```bash
    auto eth0
        iface eth0 inet dhcp

    auto eth1
        iface eth1 inet static
        address 10.15.1.1
        netmask 255.255.255.0

    auto eth2
        iface eth2 inet static
        address 10.15.2.1
        netmask 255.255.255.0

    auto eth3
        iface eth3 inet static
        address 10.15.3.1
        netmask 255.255.255.0
    ```

    Konfigurasi SSS

    ```bash
    auto eth0
        iface eth0 inet static
        address 10.15.1.2
        netmask 255.255.255.0
        gateway 10.15.1.1
    ```

    Konfigurasi Garden

    ```bash
    auto eth0
        iface eth0 inet static
        address 10.15.1.3
        netmask 255.255.255.0
        gateway 10.15.1.1
    ```

    Konfigurasi Wise

    ```bash
    auto eth0
        iface eth0 inet static
        address 10.15.2.2
        netmask 255.255.255.0
        gateway 10.15.2.1
    ```

    Konfigurasi Berlint

    ```bash
    auto eth0
        iface eth0 inet static
        address 10.15.3.2
        netmask 255.255.255.0
        gateway 10.15.3.1
    ```

    Konfigurasi Eden

    ```bash
    auto eth0
        iface eth0 inet static
        address 10.15.3.3
        netmask 255.255.255.0
        gateway 10.15.3.1
    ```

- Konfigurasi Router (Ostania)

    Agar client bisa terhubung ke internet, perlu dilakukan konfigurasi iptables pada router (Ostania). Kemudian, simpan kedalam file `.bashrc`.

    ```bash
    echo 'iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.15.0.0/16 ' >> .bashrc
    ```

</br>

### **Soal 2**
**Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.yyy.com dengan alias www.wise.yyy.com pada folder wise.**

Pada console Wise dilakukan konfigurasi sebagai berikut untuk menjadi DNS Master.

```bash
apt-get update
apt-get install bind9 -y

echo ’zone "wise.c11.com" {
	type master;
	file "/etc/bind/jarkom/wise.c11.com";
}; ’ > /etc/bind/named.conf.local

rm -r /etc/bind/jarkom
mkdir /etc/bind/jarkom

cp /etc/bind/db.local /etc/bind/jarkom/wise.c11.com

echo ‘;
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
www      IN      CNAME   wise.c11.com.’ > /etc/bind/jarkom/wise.c11.com

service bind9 restart
```

</br>

### **Soal 3**
**Setelah itu ia juga ingin membuat subdomain eden.wise.yyy.com dengan alias www.eden.wise.yyy.com yang diatur DNS-nya di WISE dan mengarah ke Eden.**

Pada console Wise dilakukan konfigurasi sebagai berikut.

```bash
echo ‘;
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
www.eden IN      A      10.15.3.3’ > /etc/bind/jarkom/wise.c11.com

service bind9 restart
```

</br>

### **Soal 4**
**Buat juga reverse domain untuk domain utama.**

Pada console Wise dilakukan konfigurasi sebagai berikut.

```bash
#10.15.2

echo ‘zone "2.15.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.15.10.in-addr.arpa";
}; ‘ > nano /etc/bind/named.conf.local

cp /etc/bind/db.local /etc/bind/jarkom/2.15.10.in-addr.arpa

echo ‘;
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
2.15.10.in-addr.arpa.	IN	NS	wise.c11.com.
2	IN	PTR	wise.c11.com. ‘ > /etc/bind/jarkom/2.15.10.in-addr.arpa


service bind9 restart
```

</br>

### **Soal 5**
**Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama.**

Pada console Wise dilakukan konfigurasi sebagai berikut.

```bash
echo ’zone "wise.c11.com" {
type master;
notify yes;
also-notify { 10.15.3.2; }; 
allow-transfer { 10.15.3.2; }; 
	file "/etc/bind/jarkom/wise.c11.com";
}; 
zone "2.15.10.in-addr.arpa" {
    type master;
    file "/etc/bind/jarkom/2.15.10.in-addr.arpa";
}; ‘ > nano /etc/bind/named.conf.local
```

Pada console Berlint dilakukan konfigurasi sebagai berikut.

```bash
apt-get update
apt-get install bind9 -y

echo ‘zone "wise.c11.com" {
    type slave;
    masters { 10.15.2.2; }; 
    file "/var/lib/bind/wise.c11.com";
}; ‘ > /etc/bind/named.conf.local

service bind9 restart
```

</br>

### **Soal 6**
**Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation.**

Pada console Wise dilakukan konfigurasi sebagai berikut.

```bash
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
www     IN      CNAME   operation.wise.c11.com. ' > /etc/bind/operation/operation.wise.c11.com

service bind9 restart
```

Pada console Berlint dilakukan konfigurasi sebagai berikut.

```bash
echo ‘zone "wise.c11.com" {
    type slave;
    masters { 10.15.2.2; };
    file "/var/lib/bind/wise.c11.com";
};
zone "operation.wise.c11.com" {
    type master;
    file "/etc/bind/operation/operation.wise.c11.com";
}; ’ > /etc/bind/named.conf.local

echo ‘options {
        directory "/var/cache/bind";
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
}; ’ > /etc/bind/named.conf.options

rm -r /etc/bind/operation
mkdir /etc/bind/operation
cp /etc/bind/db.local /etc/bind/operation/wise.c11.com

echo ‘;
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
@       IN      NS     operation.wise.c11.com.
@       IN      A       10.15.3.3
www	IN	CNAME	operation.wise.c11.com.
strix	IN	A	 10.15.3.3
www.strix	IN	CNAME	10.15.3.3 ‘ > /etc/bind/operation/operation.wise.c11.com

service bind9 restart
```

</br>

### **Soal 7**
**Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden.**

Pada console Berlint dilakukan konfigurasi sebagai berikut.

```bash
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
```

</br>

### **Soal 8**


</br>

### **Soal 9**


</br>

### **Soal 10**


</br>

## **Kendala yang Dihadapi**
Terdapat beberapa kendala saat pengerjaan praktikum, antara lain sebagai berikut.

1. Tantangan dalam manajemen pekerjaan dan waktu, karena dikerjakan sendiri tanpa adanya pembagian task.
2. Masalah pada VirtualBox, yang akhirnya harus pindah VM ke VMWare dan mengulang lagi.
3. *Stuck* dalam pengerjaan nomor 6 dan memakan banyak waktu. Ternyata, setelah direfleksi dan ditelusuri, *node* `Wise` juga perlu dikonfigurasi. 