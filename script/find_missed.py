import re
import os

score_path = 'script/score.txt'
target_dir = 'src'
done_dir = os.path.join(target_dir, '__DONE__')

try:
    with open(score_path, 'r', encoding='utf-8') as f:
        text = f.read()
except FileNotFoundError:
    print(f"❌ หาไฟล์ {score_path} ไม่เจอ")
    exit()

# 💡 แก้ตรงนี้: ใส่ \s* เข้าไปเพื่อบอกว่า "จะมีหรือไม่มี Space/Tab คั่นก็ได้"
all_tasks = re.findall(r'\d+\s*/\s*100\s*([A-Za-z0-9_]+)', text)

missing = []

for task in all_tasks:
    path_out = os.path.join(target_dir, task)
    path_in = os.path.join(done_dir, task)
    
    if not os.path.exists(path_out) and not os.path.exists(path_in):
        missing.append(task)

print("🔍 สรุปโจทย์ที่ยังไม่ได้โหลดมาใส่โฟลเดอร์:")
print("-" * 40)
if not missing:
    print("✨ ครบถ้วน! โหลดมาครบทุกข้อแล้ว ลุยเขียน C++ ต่อได้เลย!")
else:
    for t in missing:
        print(f"⚠️ หายไป: {t}")
    print("-" * 40)
    print(f"รวมโจทย์ที่ยังไม่มีโฟลเดอร์ทั้งหมด {len(missing)} ข้อ")