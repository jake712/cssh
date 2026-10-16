#!/bin/bash
# clear-ram.sh - 一键运行包 (高危操作警告)
# 警告: 此脚本会停止并禁用 SSH, rsyslog, getty，执行后你将立即失联且无法远程登录
# 仅在本地物理机 + 有 IPMI/KVM 保底时使用

set -e

# 必须 root 权限
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] 请用 root 权限运行: sudo bash clear-ram.sh"
  exit 1
fi

echo "=== clear-ram.sh 开始执行 ==="
echo "将在 5 秒后停止 ssh/sshd, rsyslog, getty@tty1, e2scrub 相关服务"
echo "按 Ctrl+C 取消..."
sleep 5

# 为了防止执行一半断联，先把所有 disable 操作执行完再 stop? 但用户要求顺序是 stop -> disable
# 这里严格按你给的顺序执行
echo "[1/10] systemctl stop ssh"
systemctl stop ssh || echo "  -> ssh 未运行或停止失败，跳过"

echo "[2/10] systemctl stop sshd"
systemctl stop sshd || echo "  -> sshd 未运行或停止失败，跳过"

echo "[3/10] systemctl disable ssh"
systemctl disable ssh || true

echo "[4/10] systemctl disable sshd (兼容 Debian/Ubuntu 同时禁用 sshd)"
systemctl disable sshd || true

echo "[5/10] systemctl stop rsyslog"
systemctl stop rsyslog || true

echo "[6/10] systemctl disable rsyslog"
systemctl disable rsyslog || true

echo "[7/10] systemctl stop getty@tty1"
systemctl stop getty@tty1 || true

echo "[8/10] systemctl disable getty@tty1"
systemctl disable getty@tty1 || true

echo "[9/10] systemctl stop e2scrub_reap.service"
systemctl stop e2scrub_reap.service || true

echo "[10/10] systemctl disable e2scrub_reap.service"
systemctl disable e2scrub_reap.service || true

echo "[11/12] systemctl stop e2scrub_all.timer"
systemctl stop e2scrub_all.timer || true

echo "[12/12] systemctl disable e2scrub_all.timer"
systemctl disable e2scrub_all.timer || true

echo "=== 执行完成 ==="
echo "注意: SSH 已禁用，下次重启后也无法远程连接。如需恢复需通过本地控制台执行:"
echo "systemctl enable ssh sshd getty@tty1 rsyslog && systemctl start ssh sshd getty@tty1 rsyslog"
echo ""
echo "如果想真正释放内存，请另执行: sync; echo 3 > /proc/sys/vm/drop_caches"
