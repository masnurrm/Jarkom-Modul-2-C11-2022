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


</br>

### **Soal 3**


</br>

### **Soal 4**


</br>

### **Soal 5**


</br>

### **Soal 6**


</br>

### **Soal 7**


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