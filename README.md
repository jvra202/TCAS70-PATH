# TCAS70 Path

เว็บแอปช่วยวางแผนเส้นทาง TCAS70 แบบ mobile-first สร้างด้วย HTML, CSS และ JavaScript โดยไม่ต้อง build

## เปิดใช้งานในเครื่อง

เปิด `index.html` ในเว็บเบราว์เซอร์ได้โดยตรง ข้อมูล Checklist, เป้าหมายมหาวิทยาลัย, คะแนน และการแจ้งเตือนจะเก็บไว้ใน local storage ของเบราว์เซอร์เครื่องนั้น

## เผยแพร่ด้วย GitHub Pages

1. Push โปรเจกต์ไปยัง branch `main` หรือ `master`
2. ไปที่ repository **Settings → Pages** แล้วเลือก **GitHub Actions** เป็น Build and deployment source
3. Workflow ใน `.github/workflows/pages.yml` จะ deploy เว็บให้อัตโนมัติเมื่อ push หรือสั่งรันจากแท็บ **Actions**

ฟอนต์จาก Google Fonts จะโหลดเมื่อเชื่อมต่ออินเทอร์เน็ต

## ฟีเจอร์

- Dashboard, Roadmap, ปฏิทิน และข่าว TCAS70
- Checklist และ Score Tracker
- หลายเป้าหมายมหาวิทยาลัย พร้อมคณะ สาขา และรอบที่สนใจ
- ศูนย์แจ้งเตือนที่ปัดซ้ายเพื่อลบรายการได้
- ธีมสว่าง/มืด สี accent และลดการเคลื่อนไหว
- Chakra Petch สำหรับภาษาไทย และ Silkscreen สำหรับตัวอักษรสไตล์เกมย้อนยุค

## ตั้งค่า Push Notification ด้วย OneSignal

1. สร้าง OneSignal App แล้วเปิดแพลตฟอร์ม Web Push โดยระบุ URL ต้นทางของ GitHub Pages หลัง deploy (เช่น `https://username.github.io`)
2. เลือก integration แบบ Custom Code; โค้ดจะคำนวณ service worker path และ scope ให้ตาม path ของ GitHub Pages project โดยใช้ไฟล์ `push/onesignal/OneSignalSDKWorker.js`
3. คัดลอก **App ID** (เป็นค่าฝั่งเว็บที่เปิดเผยได้) ใส่ใน `onesignal-config.js` แล้ว push ขึ้น GitHub อีกครั้ง ห้ามใส่ REST API Key หรือ Secret ใน repository
4. บน iPhone/iPad ต้องใช้ iOS/iPadOS 16.4 ขึ้นไป เปิดเว็บผ่าน HTTPS เพิ่มไปยังหน้าจอโฮม แล้วเปิดจากไอคอนก่อนกด “เปิดการแจ้งเตือน”
5. ทดสอบส่ง notification จาก OneSignal Dashboard ไปยัง subscription ของอุปกรณ์

OneSignal Web Push ใช้ได้หลังผู้ใช้สมัครรับแจ้งเตือนแล้ว การส่งเตือนเฉพาะวัน/เหตุการณ์จากข้อมูลในเครื่องต้องมี backend ที่เก็บ subscription และเวลาส่งอย่างปลอดภัย; อย่าเรียก OneSignal REST API จากหน้าเว็บหรือใส่ REST API Key ใน GitHub.
