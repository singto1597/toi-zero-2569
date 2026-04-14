#!/bin/bash

echo "🚨 เริ่มมหกรรมกวาดล้างและจัดบ้านใหม่..."

# 1. ฆ่าไฟล์ขยะทิ้งก่อนเลย
echo "🧹 กำลังลบไฟล์ .1 และไฟล์รันขยะ..."
find src -type f -name "*.1.*" -delete
# ลบไฟล์ที่ไม่มีนามสกุล (Executable) ยกเว้นโฟลเดอร์
find src -type f ! -name "*.*" -delete

# 2. ค้นหาไฟล์ .pdf และ .cpp ทั้งหมดเพื่อเอามาจัดเรียงใหม่
echo "📦 กำลังจัดหมวดหมู่ A1, A2, A3..."
find src -type f \( -name "*.pdf" -o -name "*.cpp" \) | while read file; do
    filename=$(basename "$file")
    
    # ใช้ Regex เช็คว่าชื่อไฟล์ตรงกับแพทเทิร์น A1-001.pdf หรือ A2-050.cpp มั้ย
    if [[ "$filename" =~ ^(A[1-3])-([0-9]{3})\.(pdf|cpp)$ ]]; then
        category="${BASH_REMATCH[1]}"         # ได้ค่า A1, A2 หรือ A3
        task="${BASH_REMATCH[1]}-${BASH_REMATCH[2]}" # ได้ค่า A1-001
        
        # ถ้านี่เป็นข้อ A1-001 ที่อยู่ใน __DONE__ ก็จัดให้อยู่ใน __DONE__/A1/A1-001
        if [[ "$file" == *"__DONE__"* ]]; then
            target_dir="src/__DONE__/$category/$task"
        else
            target_dir="src/$category/$task"
        fi
        
        mkdir -p "$target_dir"
        
        # ย้ายไฟล์ไปที่ใหม่ (ถ้ามันยังไม่ได้อยู่ตรงนั้น)
        if [ "$file" != "$target_dir/$filename" ]; then
            mv "$file" "$target_dir/"
        fi
    fi
done

# 3. เคลียร์โฟลเดอร์ซอมบี้ (โฟลเดอร์เปล่าๆ ที่โดนดูดไฟล์ออกไปหมดแล้ว)
echo "🗑️ กำลังลบโฟลเดอร์เปล่า..."
# รันหาโฟลเดอร์เปล่าลบทิ้ง (สั่ง 2-3 รอบเผื่อมันซ้อนกันลึก)
find src -type d -empty -delete 2>/dev/null
find src -type d -empty -delete 2>/dev/null
find src -type d -empty -delete 2>/dev/null

echo "✨ จัดบ้านเสร็จเรียบร้อย! ลองใช้คำสั่ง tree src ดูใหม่ได้เลย!"
