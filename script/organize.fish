#!/usr/bin/env fish

# ตรวจสอบว่ารันถูกที่มั้ย (ต้องรันจากหน้า toi-zero-2569)
if not test -d src
    echo "❌ Error: กรุณารันสคริปต์จากหน้า folder 'toi-zero-2569'"
    exit 1
end

echo "🚀 เริ่มจัดระเบียบไฟล์ใน src/..."

# วนลูปหาไฟล์ PDF ทั้งหมดใน src
for file in src/*.pdf
    # ดึงชื่อไฟล์ออกมา (เช่น A1-001 (TH).pdf)
    set filename (basename "$file")
    
    # ตัดเอาแค่รหัสโจทย์คำแรก (เอาแค่ A1-001)
    set id (string split " " $filename)[1]
    
    # กำหนด path ปลายทาง
    set target_dir "src/$id"
    
    # 1. สร้างโฟลเดอร์
    mkdir -p "$target_dir"
    
    # 2. ย้ายไฟล์ PDF เข้าไป
    mv "$file" "$target_dir/"
    
    # 3. สร้างไฟล์ .cpp (ชื่อเดียวกับโจทย์)
    set cpp_file "$target_dir/$id.cpp"
    
    # ถ้ายังไม่มีไฟล์ .cpp ให้สร้างใหม่
    if not test -e "$cpp_file"
        # เช็คว่ามีไฟล์ template ที่หน้าหลักมั้ย ถ้ามีให้ก๊อปมา
        if test -f template
            cp template "$cpp_file"
            echo "✅ $id: Moved PDF & Created .cpp (from Template)"
        else
            # ถ้าไม่มี template ก็สร้างไฟล์เปล่า
            touch "$cpp_file"
            echo "✅ $id: Moved PDF & Created .cpp (Empty)"
        end
    else
        echo "ℹ️  $id: Moved PDF (CPP file already exists)"
    end
end

echo "🎉 เสร็จเรียบร้อย! พร้อมลุย!"
