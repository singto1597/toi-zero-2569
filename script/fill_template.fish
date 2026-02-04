#!/usr/bin/env fish

# เช็คก่อนว่ามีไฟล์ต้นแบบมั้ย
if not test -f template
    echo "❌ หาไฟล์ 'template' ไม่เจอ! เช็คก่อนว่าวางไว้หน้าโฟลเดอร์ยัง?"
    exit 1
end

echo "🔥 กำลังไล่อัดโค้ดจาก template ลงทุกไฟล์ .cpp..."

# วนลูปหาไฟล์ .cpp ทุกไฟล์ในโฟลเดอร์ย่อยของ src
for file in src/*/*.cpp
    # ก๊อปไฟล์ template ไปทับเลย
    cp template "$file"
    echo "✅ อัปเดต: $file"
end

echo "🎉 เสร็จ! ลองเปิดดูไฟล์ไหนก็ได้ ตอนนี้มีโค้ดแล้วแน่นอน"
