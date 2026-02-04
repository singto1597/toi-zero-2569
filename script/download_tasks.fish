#!/usr/bin/env fish

# ==========================================
# 🍪 เอา COOKIE มาใส่ในบรรทัดข้างล่างนี้! (สำคัญมาก)
# ==========================================
if test -f script/secrets.fish
    source script/secrets.fish
else
    echo "❌ ไม่เจอไฟล์ secrets.fish! มึงลืมสร้างป่าว?"
    exit 1
end

# เช็คว่าใส่ Cookie หรือยัง
if test "$USER_COOKIE" = "วาง_COOKIE_ยาวๆ_จาก_BROWSER_ตรงนี้"
    echo "❌ มึงยังไม่ได้ใส่ Cookie! ไปก๊อปจาก F12 มาใส่ในไฟล์สคริปต์ก่อน!"
    exit 1
end

# สร้างโฟลเดอร์เก็บ PDF ถ้ายังไม่มี
mkdir -p pdf_downloads

# ฟังก์ชั่นโหลดไฟล์
function download_task
    set id $argv[1]
    set url "https://toi-coding.informatics.buu.ac.th/00-pre-toi/tasks/$id/statements/TH"
    set output_file "src/$id/$id.pdf"

    echo "⬇️  กำลังโหลด: $id ..."

    # เพิ่ม --user-agent เพื่อปลอมตัวว่าเป็น Chrome
    aria2c -c -x 16 -s 16 \
        --header="Cookie: $USER_COOKIE" \
        --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
        -o "$output_file" \
        "$url"
    
    # เช็คว่าโหลดได้จริงมั้ย (ถ้าไฟล์เล็กเกิน < 5KB แปลว่าอาจจะติดหน้า Login)
    set filesize (du -k "$output_file" | cut -f1)
    if test "$filesize" -lt 5
        echo "⚠️  ไฟล์ $id เล็กผิดปกติ ($filesize KB) เช็ค Cookie ด่วน! หรือโจทย์ขอนี้อาจจะไม่มี"
        # rm "$output_file" # ลบไฟล์ทิ้งถ้าอยาก
    else
        echo "✅ โหลด $id เสร็จแล้ว!"
    end
end

# ==========================================
# 🔄 ลูปโหลดรัวๆ (แก้เลขตรงนี้ได้)
# ==========================================

# ตัวอย่าง: โหลด A1-001 ถึง A1-070
for i in (seq -f "%03g" 1 70)
    download_task "A1-$i"
end

# ตัวอย่าง: โหลด A2-001 ถึง A2-060
# for i in (seq -w 1 60)
#     download_task "A2-$i"
# end

echo "🎉 จบงาน! ไปเช็คไฟล์ใน src/ ได้เลย"
