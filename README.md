65M這種超小NAT雞，sshd確實是吃RAM大戶，佔 5∼15M。


以下一鍵減少記憶體包會令你連不上SSH
```
bash <(curl -fsSL https://raw.githubusercontent.com/jake712/cssh/main/clearRam.sh)
```

先看你是什麼系統：

```
cat /etc/os-release
ps aux | grep sshd
Debian / Ubuntu 最常見的：
```
Debian / Ubuntu 最常見的：
```
systemctl stop ssh 
systemctl stop sshd 
systemctl disable ssh 
systemctl stop rsyslog 
systemctl disable rsyslog
systemctl stop getty@tty1
systemctl disable getty@tty1
systemctl stop e2scrub_reap.service
systemctl disable e2scrub_reap.service
systemctl stop e2scrub_all.timer
systemctl disable e2scrub_all.timer
```
已隱藏4行
Alpine (65M雞最推薦的系統)：

```
rc-service sshd stop &&
rc-update del sshd &&
apk del openssh &&
```
