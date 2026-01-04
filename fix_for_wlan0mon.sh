#!/bin/bash
echo "[*] Fixing Wisec for wlan0mon (no rename)"

# 1. Xóa dòng đổi tên interface
sed -i '/ip link set.*name.*wlan0mon/d' Wisec.sh

# 2. Thêm option -o vào airmon-ng để giữ tên gốc (nếu cần tạo wlan0mon)
sed -i 's/airmon-ng start \$networkCard/airmon-ng start \$networkCard -o/g' Wisec.sh

# 3. Thay thế wlan0mon bằng $networkCard (giữ nguyên vì bạn muốn dùng wlan0mon)
#    Nhưng phải thay thế tất cả wlan0mon cố định thành biến $networkCard
sed -i 's/"wlan0mon"/"\$networkCard"/g' Wisec.sh
sed -i "s/'wlan0mon'/'\$networkCard'/g" Wisec.sh
sed -i 's/\bwlan0mon\b/\$networkCard/g' Wisec.sh

# 4. Sửa dòng kiểm tra monitor mode
sed -i 's/iwconfig wlan0mon > iface.txt/iwconfig \$networkCard > iface.txt 2>\/dev\/null/g' Wisec.sh

# 5. Bỏ phần tạo monitor mode nếu đã là wlan0mon
sed -i '/if \[ \$(iwconfig.*grep.*Monitor.*echo \$?) -ne 0 \];then/,/^fi/s/airmon-ng start/# airmon-ng start/g' Wisec.sh

echo "[✓] Fixed! Now run: sudo ./Wisec.sh -n wlan0mon"
echo "[*] Note: wlan0mon must already exist in monitor mode"
