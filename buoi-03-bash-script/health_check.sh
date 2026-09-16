#!/bin/bash
# =============================================================
# health_check.sh
# Kiểm tra trạng thái các dịch vụ Nginx và SSH bằng systemctl.
# Dịch vụ nào không chạy sẽ được in cảnh báo màu đỏ.
# =============================================================

# --- Mã màu ANSI dùng để in chữ có màu ra terminal ---
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'   # No Color: trả về màu mặc định

# --- Mảng chứa tên các dịch vụ cần kiểm tra ---
services=("nginx" "ssh")

# Đếm số dịch vụ bị lỗi
failed=0

echo "===== Health check lúc $(date '+%Y-%m-%d %H:%M:%S') ====="

# --- Vòng lặp: duyệt qua từng phần tử trong mảng ---
for service in "${services[@]}"; do
    # Lấy trạng thái dịch vụ: active / inactive / failed / ...
    status=$(systemctl is-active "$service" 2>/dev/null)

    # Nếu không lấy được trạng thái thì ghi là "unknown"
    status=${status:-unknown}

    # --- If/Else: dịch vụ chạy hay không ---
    if [ "$status" = "active" ]; then
        echo -e "${GREEN}[OK]${NC} $service đang chạy (trạng thái: $status)"
    else
        echo -e "${RED}[CẢNH BÁO] $service KHÔNG hoạt động (trạng thái: $status)${NC}"
        failed=$((failed + 1))
    fi
done

echo "===== Kết quả: $failed dịch vụ gặp sự cố ====="

# Mã thoát: 0 = tất cả đều chạy, 1 = có dịch vụ lỗi
if [ "$failed" -gt 0 ]; then
    exit 1
fi
exit 0
