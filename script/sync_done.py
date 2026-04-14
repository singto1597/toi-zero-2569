import re
import os
import shutil

# -----------------------------------------------------
# ตั้งค่า Path ต่างๆ (อิงจากการรันที่โฟลเดอร์ root ของโปรเจกต์)
# -----------------------------------------------------
score_path = 'script/score.txt'
readme_path = 'readme.md'
target_dir = 'src'
done_dir = os.path.join(target_dir, '__DONE__')

# 1. อ่านไฟล์ score.txt ที่ก๊อปมาจาก Grader
try:
    with open(score_path, 'r', encoding='utf-8') as f:
        text = f.read()
except FileNotFoundError:
    print(f"❌ หาไฟล์ไม่เจอ: เช็คให้ชัวร์ว่าเอาตารางคะแนนไปแปะไว้ใน '{score_path}' แล้ว")
    exit()

# ใช้ Regex จับคู่เฉพาะข้อที่ได้ "100 / 100" (ดึงมาแค่ ID โจทย์)
matches = re.findall(r'100\s*/\s*100\s*(A[1-3]-\d{3})', text)

# สร้างโฟลเดอร์ __DONE__ รอไว้เลยถ้ายังไม่มี
if not os.path.exists(done_dir):
    os.makedirs(done_dir)

moved_count = 0
updated_readme_count = 0

# 2. อ่านไฟล์ readme.md เพื่อเตรียมอัปเดตตาราง
try:
    with open(readme_path, 'r', encoding='utf-8') as f:
        readme_content = f.read()
except FileNotFoundError:
    print(f"⚠️ หาไฟล์ '{readme_path}' ไม่เจอ ข้ามสเต็ปการอัปเดต Readme ไปนะ")
    readme_content = ""

# 3. ลุยงาน! (ย้ายโฟลเดอร์ + อัปเดต Readme)
for task in matches:
    # --- ส่วนที่ 1: ย้ายโฟลเดอร์ ---
    task_path = os.path.join(target_dir, task)
    
    # ถ้าเจอโฟลเดอร์งานอยู่ข้างนอก และยังไม่ได้อยู่ใน __DONE__ ให้ย้ายซะ
    if os.path.exists(task_path) and not os.path.isdir(os.path.join(done_dir, task)):
        shutil.move(task_path, done_dir)
        print(f"📦 ย้ายโฟลเดอร์: {task} -> __DONE__")
        moved_count += 1
    
    # --- ส่วนที่ 2: อัปเดตตารางใน Readme ---
    if readme_content:
        # ใช้ Regex หาบรรทัดทั้งแถวที่มี **TASK_ID** (เพื่อให้จับได้ทั้งแถวของตาราง)
        row_pattern = re.compile(rf"^\|.*?\|\s*\*\*{task}\*\*\s*\|.*?\|.*?\|.*?\|$", re.MULTILINE)
        match = row_pattern.search(readme_content)
        
        if match:
            old_row = match.group(0)
            
            # เช็คว่าถ้ายังไม่ได้เป็น 🟢 แสดงว่าเพิ่งได้ 100 เต็ม ต้องอัปเดต!
            if '🟢' not in old_row:
                
                # 3.1 ลบบรรทัดเดิมออกจากไฟล์ก่อน (เช็คด้วยว่ามี \n ต่อท้ายมั้ย จะได้ไม่เหลือบรรทัดว่าง)
                if old_row + '\n' in readme_content:
                    readme_content = readme_content.replace(old_row + '\n', '')
                else:
                    readme_content = readme_content.replace(old_row, '')
                
                # 3.2 แปลงร่างตาราง (เปลี่ยนสีไฟ และคะแนน)
                new_row = re.sub(r'\|\s*[🔴🟡]\s*\|', '| 🟢 |', old_row)
                new_row = re.sub(r'\|\s*\d+\s*/\s*\d+\s*\|', '| 100 / 100 |', new_row)
                
                # 3.3 เปลี่ยน Path ให้ชี้เข้าไปใน __DONE__ (ถ้ายังไม่มีคำนี้)
                if '__DONE__' not in new_row:
                    new_row = new_row.replace(f'1_cmu-grader/{task}', f'1_cmu-grader/__DONE__/{task}')
                
                # 3.4 ย้ายไปต่อท้ายตารางคนเก่ง (หาแท็ก </details> แล้วแทรกไว้ข้างบนมัน)
                if '</details>' in readme_content:
                    readme_content = readme_content.replace('</details>', f"{new_row}\n</details>")
                else:
                    # Fallback เผื่อหา </details> ไม่เจอ ก็แปะต่อท้ายไฟล์ไปเลย
                    readme_content += f"\n{new_row}"

                print(f"📝 อัปเดตตาราง: {task} ย้ายเข้าโซน 100 เต็มแล้ว!")
                updated_readme_count += 1

# 4. เขียนข้อมูลใหม่ทับไฟล์ readme.md
if readme_content:
    with open(readme_path, 'w', encoding='utf-8') as f:
        f.write(readme_content)

print("-" * 40)
if moved_count == 0 and updated_readme_count == 0:
    print("😎 ไม่มีอะไรให้อัปเดต งานปัจจุบันเคลียร์หมดแล้ว!")
else:
    print(f"🎉 สรุป: ย้ายไฟล์ไป {moved_count} ข้อ | อัปเดตตารางคะแนนไป {updated_readme_count} ข้อ")