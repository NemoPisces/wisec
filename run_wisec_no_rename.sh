#!/bin/bash
# run_wisec_no_rename.sh - Chạy Wisec không đổi tên interface

# Interface của bạn (sửa nếu cần)
INTERFACE="iw_wisecom"

echo "=========================================="
echo "  WISEC - NO INTERFACE RENAME MODE"
echo "=========================================="
echo "[*] Interface: $INTERFACE"
echo "[*] Đảm bảo giữ nguyên tên interface..."

# Tạo bản sao tạm thời
TEMP_FILE="/tmp/wisec_no_rename_$$.sh"
cp Wisec.sh "$TEMP_FILE"

# Sửa bản tạm thời để không đổi tên
sed -i '/ip link set \$networkCard name wlan0mon/d' "$TEMP_FILE"
sed -i '/ifconfig wlan0mon/d' "$TEMP_FILE"
sed -i 's/wlan0mon/\$networkCard/g' "$TEMP_FILE"
sed -i 's/airmon-ng stop \$networkCard/airmon-ng stop \$networkCard 2>\/dev\/null/g' "$TEMP_FILE"

# Thêm dòng vào đầu script để luôn dùng interface chỉ định
sed -i "2i\\
# Auto-set interface\\
networkCard=\"$INTERFACE\"" "$TEMP_FILE"

# Chạy
echo "[+] Đang chạy Wisec với interface $INTERFACE..."
echo "[!] Interface sẽ KHÔNG bị đổi tên!"
echo "=========================================="

sudo bash "$TEMP_FILE"

# Dọn dẹp
rm -f "$TEMP_FILE"
echo "[✓] Hoàn tất. Interface vẫn là: $INTERFACE"
