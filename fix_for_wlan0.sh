#!/bin/bash
echo "[*] Fixing Wisec for wlan0 (no rename)"

# 1. Xóa dòng đổi tên interface
sed -i '/ip link set.*name.*wlan0mon/d' Wisec.sh

# 2. Thêm option -o vào airmon-ng để giữ tên gốc
sed -i 's/airmon-ng start \$networkCard/airmon-ng start \$networkCard -o/g' Wisec.sh

# 3. Thay thế wlan0mon bằng $networkCard
sed -i 's/wlan0mon/\$networkCard/g' Wisec.sh

# 4. Sửa dòng kiểm tra monitor mode
sed -i 's/iwconfig wlan0mon > iface.txt/iwconfig \$networkCard > iface.txt 2>\/dev\/null/g' Wisec.sh

echo "[✓] Fixed! Now run: sudo ./Wisec.sh -n wlan0"
