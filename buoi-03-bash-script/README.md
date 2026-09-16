# Buổi 3 – Bash script kiểm tra dịch vụ (`health_check.sh`)

> [← Về mục lục](../README.md)

**File bài làm:** [`health_check.sh`](./health_check.sh)

## Đề bài

1. Viết một Bash script tên `health_check.sh`.
2. Khai báo mảng chứa tên 2 dịch vụ: Nginx và SSH.
3. Dùng vòng lặp kiểm tra trạng thái (`systemctl is-active`).
4. Nếu dịch vụ chết (If/Else), tự động in ra màn hình cảnh báo đỏ.

## Môi trường cần có

- Linux dùng **systemd**, ví dụ Ubuntu hoặc Debian (máy ảo, server hoặc EC2 đều được).
- **macOS không có `systemctl`**, nên script không chạy đúng trên Mac. Hãy chạy trong máy ảo Ubuntu hoặc trên server.
- (Tuỳ chọn) Cài Nginx và SSH để có dịch vụ thật để kiểm tra:

```bash
sudo apt update
sudo apt install -y nginx openssh-server
```

## Cách chạy

```bash
# 1. Tải repo về
git clone https://github.com/ghdvhoang/devops.git
cd devops/buoi-03-bash-script

# 2. Cấp quyền thực thi cho script (chỉ cần làm 1 lần)
chmod +x health_check.sh

# 3. Chạy script
./health_check.sh

# 4. (Tuỳ chọn) Xem mã thoát: 0 = tất cả OK, 1 = có dịch vụ lỗi
echo $?
```

Có thể chạy mà không cần `chmod +x` bằng lệnh `bash health_check.sh`.

## Kết quả mẫu

Khi cả 2 dịch vụ đều chạy (dòng `[OK]` có màu xanh):

```text
===== Health check lúc 2026-09-16 08:38:39 =====
[OK] nginx đang chạy (trạng thái: active)
[OK] ssh đang chạy (trạng thái: active)
===== Kết quả: 0 dịch vụ gặp sự cố =====
```

Khi Nginx bị dừng (dòng cảnh báo có **màu đỏ**):

```text
===== Health check lúc 2026-09-16 08:38:39 =====
[CẢNH BÁO] nginx KHÔNG hoạt động (trạng thái: inactive)
[OK] ssh đang chạy (trạng thái: active)
===== Kết quả: 1 dịch vụ gặp sự cố =====
```

## Thử tạo tình huống dịch vụ "chết"

```bash
sudo systemctl stop nginx      # Dừng Nginx
./health_check.sh              # Sẽ thấy cảnh báo đỏ cho nginx
sudo systemctl start nginx     # Bật lại Nginx
./health_check.sh              # nginx trở lại [OK]
```

## Giải thích code

### 1. Shebang

```bash
#!/bin/bash
```

Dòng đầu tiên cho hệ điều hành biết dùng chương trình `bash` để chạy file này.

### 2. Mã màu

```bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
```

Đây là **mã màu ANSI**. Khi in chuỗi `\033[0;31m` ra terminal, chữ phía sau sẽ thành màu đỏ, còn `\033[0m` đưa màu về mặc định. Cần dùng `echo -e` thì `echo` mới hiểu các ký tự `\033`.

### 3. Mảng (Array)

```bash
services=("nginx" "ssh")
```

- Mảng khai báo bằng dấu ngoặc tròn, các phần tử cách nhau bởi dấu cách. Không có dấu cách quanh dấu `=`.
- `${services[0]}` là `nginx`, `${services[1]}` là `ssh`.
- `${services[@]}` là toàn bộ phần tử của mảng.

### 4. Vòng lặp `for`

```bash
for service in "${services[@]}"; do
    ...
done
```

Mỗi vòng lặp, biến `service` lần lượt nhận giá trị `nginx`, rồi `ssh`. Đặt `"${services[@]}"` trong dấu nháy kép để tên có dấu cách (nếu có) không bị tách sai.

### 5. Lấy trạng thái dịch vụ

```bash
status=$(systemctl is-active "$service" 2>/dev/null)
status=${status:-unknown}
```

- `systemctl is-active nginx` in ra `active` nếu dịch vụ đang chạy, ngược lại in `inactive`, `failed`, v.v.
- `$( ... )` (command substitution) chạy lệnh bên trong rồi lấy kết quả in ra để gán vào biến `status`.
- `2>/dev/null` bỏ đi thông báo lỗi (stderr) để màn hình gọn hơn.
- `${status:-unknown}`: nếu `status` rỗng (ví dụ máy không có systemd) thì dùng giá trị `unknown`.

### 6. If/Else

```bash
if [ "$status" = "active" ]; then
    echo -e "${GREEN}[OK]${NC} ..."
else
    echo -e "${RED}[CẢNH BÁO] ...${NC}"
    failed=$((failed + 1))
fi
```

- `[ "$status" = "active" ]` so sánh hai chuỗi. Bắt buộc có **dấu cách** sau `[` và trước `]`.
- Trạng thái là `active` thì in `[OK]` màu xanh. Các trường hợp còn lại in cảnh báo màu đỏ.
- `$((failed + 1))` là phép tính số học trong Bash, dùng để tăng biến đếm số dịch vụ lỗi.

### 7. Mã thoát (exit code)

```bash
if [ "$failed" -gt 0 ]; then
    exit 1
fi
exit 0
```

- `-gt` nghĩa là "lớn hơn" (greater than), dùng để so sánh số.
- Theo quy ước Linux, `exit 0` là thành công, còn số khác 0 là có lỗi. Nhờ vậy các công cụ khác (cron, CI/CD, hệ thống giám sát) biết được script phát hiện sự cố hay không.

## Lưu ý

- Trên CentOS/RHEL, dịch vụ SSH tên là `sshd` thay vì `ssh`. Khi đó sửa mảng thành `services=("nginx" "sshd")`.
- Trên Ubuntu 22.10 trở lên, SSH có thể được khởi động theo kiểu *socket activation*: `ssh` chỉ chuyển sang `active` sau lần kết nối SSH đầu tiên. Nếu thấy `ssh` báo `inactive` dù đã cài, hãy chạy `sudo systemctl start ssh`.
