# Buổi 2 – Thực hành các lệnh Linux cơ bản

> [← Về mục lục](../README.md)

**File bài làm:** [`hello_world.txt`](./hello_world.txt)

> Đề yêu cầu làm trong thư mục `~/devops/lesson1`. Trong repo này, kết quả được lưu ở folder `buoi-02-linux-co-ban`.

## Yêu cầu

1. Tạo thư mục `~/devops/lesson1`.
2. Di chuyển vào thư mục vừa tạo.
3. Tạo file `hello_world.txt`.
4. Mở file `hello_world.txt` bằng trình soạn thảo `nano` và viết vài dòng nội dung vào file.
5. Dùng lệnh `cat` để hiển thị nội dung file ra terminal.

## Các lệnh đã thực hiện

### 1. Tạo thư mục `~/devops/lesson1`

```bash
mkdir -p ~/devops/lesson1
```

- `mkdir`: tạo thư mục mới.
- `-p`: tạo luôn thư mục cha (`~/devops`) nếu chưa tồn tại, không báo lỗi nếu thư mục đã có.

Kiểm tra:

```bash
ls -ld ~/devops/lesson1
```

### 2. Di chuyển vào thư mục vừa tạo

```bash
cd ~/devops/lesson1
pwd
```

- `cd`: chuyển thư mục làm việc.
- `pwd`: in ra đường dẫn thư mục hiện tại để xác nhận đã vào đúng thư mục.

Kết quả (đường dẫn đầy đủ của `~/devops/lesson1`, ví dụ trên macOS):

```text
/Users/<username>/devops/lesson1
```

### 3. Tạo file `hello_world.txt`

```bash
touch hello_world.txt
ls -l
```

- `touch`: tạo file rỗng (nếu file chưa tồn tại).
- `ls -l`: liệt kê file trong thư mục để kiểm tra file đã được tạo.

### 4. Mở file bằng `nano` và viết nội dung

```bash
nano hello_world.txt
```

Trong `nano`:

1. Gõ nội dung, ví dụ: `hello im Honag`
2. Nhấn `Ctrl + O` rồi `Enter` để lưu file.
3. Nhấn `Ctrl + X` để thoát khỏi `nano`.

### 5. Hiển thị nội dung file bằng `cat`

```bash
cat hello_world.txt
```

Kết quả:

```text
hello im Honag
```

## Tóm tắt toàn bộ lệnh

```bash
mkdir -p ~/devops/lesson1     # 1. Tạo thư mục
cd ~/devops/lesson1           # 2. Di chuyển vào thư mục
touch hello_world.txt         # 3. Tạo file
nano hello_world.txt          # 4. Mở file bằng nano, viết nội dung, Ctrl+O -> Enter -> Ctrl+X
cat hello_world.txt           # 5. Hiển thị nội dung file
```
