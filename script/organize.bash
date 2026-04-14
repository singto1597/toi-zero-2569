#!/usr/bin/env bash

# เปิด shopt nullglob ป้องกันกรณีรันแล้วหาไฟล์ .pdf ไม่เจอจะได้ไม่พัง
shopt -s nullglob

# เช็คแค่ว่ามีโฟลเดอร์ src มั้ย จะได้ไม่ต้องผูกติดกับชื่อโปรเจกต์เดิม
if [ ! -d "src" ]; then
    echo "❌ Error: กรุณารันสคริปต์จากหน้า folder หลักที่มีโฟลเดอร์ 'src'"
    exit 1
fi

echo "🚀 เริ่มจัดระเบียบไฟล์โจทย์..."

# วนลูปหาไฟล์ PDF ในโฟลเดอร์ย่อย 1 ชั้น (เช่น src/1_precamp/*.pdf)
for file in src/*/*.pdf; do
    # 1. ดึงชื่อไฟล์แบบไม่เอา .pdf ออกมา
    basename_no_ext=$(basename "$file" .pdf)
    
    # 2. ตัดวงเล็บและข้อความข้างในทิ้ง รวมถึง Space ข้างหน้าวงเล็บ (ถ้ามี)
    # และเปลี่ยนเว้นวรรคที่เหลือให้เป็น _ (เช่น "01 Squid (thai)" -> "01_Squid")
    id=$(echo "$basename_no_ext" | sed -E 's/ *\([^)]*\)//g' | tr ' ' '_')
    
    # 3. ดึงชื่อโฟลเดอร์แม่มันมา (เช่น "src/1_precamp")
    parent_dir=$(dirname "$file")
    
    # กำหนด path ปลายทาง (เช่น "src/1_precamp/c2p005")
    target_dir="$parent_dir/$id"
    
    # สร้างโฟลเดอร์
    mkdir -p "$target_dir"
    
    # ย้ายไฟล์ PDF เข้าไปเก็บ (และ Rename ไฟล์ PDF ให้ชื่อคลีนเหมือนโฟลเดอร์ด้วยเลย)
    new_pdf_file="$target_dir/$id.pdf"
    mv "$file" "$new_pdf_file"
    
    # สร้างไฟล์ .cpp โดยใช้ชื่อใหม่ที่ไม่มีเว้นวรรค/วงเล็บ
    cpp_file="$target_dir/$id.cpp"
    
    if [ ! -e "$cpp_file" ]; then
        if [ -f "template" ]; then
            cp template "$cpp_file"
            echo "✅ $id: สร้างโฟลเดอร์ & ดึงโค้ดจาก Template"
        else
            touch "$cpp_file"
            echo "⚠️ $id: สร้างโฟลเดอร์ & .cpp (ไฟล์เปล่า เพราะไม่เจอ template หน้าสุด)"
        fi
    else
        echo "ℹ️  $id: จัดระเบียบ PDF แล้ว (.cpp มีอยู่แล้ว)"
    fi
done

echo "🎉 เสร็จเรียบร้อย! พร้อมลุย สอวน. ค่าย 2!"