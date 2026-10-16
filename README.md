65M這種超小NAT雞，sshd確實是吃RAM大戶，佔 5∼15M。


方案1：徹底刪除，永遠不讓人SSH進來，最省RAM
這就是你問的「刪除功能」。

先看你是什麼系統：

```
cat /etc/os-release
ps aux | grep sshd
Debian / Ubuntu 最常見的：

```
systemctl stop ssh &&
systemctl stop sshd &&
systemctl disable ssh
""
```
已隱藏4行
Alpine (65M雞最推薦的系統)：

```
rc-service sshd stop &&
rc-update del sshd &&
apk del openssh &&
```
