#!/bin/bash

# สคริปต์สำหรับเพิ่มรูปภาพเข้าไปใน Photos ของ iPhone 17 Pro Max Simulator
# วิธีใช้: ./add_photo_to_simulator.sh <path_to_image>

SIMULATOR_NAME="iPhone 17 Pro Max"
SIMULATOR_ID="A6240254-5A30-48C8-A38F-DB6A3B82DDD8"

# ตรวจสอบว่ามี argument หรือไม่
if [ $# -eq 0 ]; then
    echo "❌ กรุณาระบุ path ของรูปภาพ"
    echo "วิธีใช้: $0 <path_to_image>"
    echo "ตัวอย่าง: $0 ~/Pictures/image.jpg"
    echo ""
    echo "หรือเพิ่มหลายรูปพร้อมกัน:"
    echo "$0 image1.jpg image2.jpg image3.jpg"
    exit 1
fi

# ตรวจสอบว่า simulator เปิดอยู่หรือไม่
BOOTED=$(xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -c "Booted")
if [ "$BOOTED" -eq 0 ]; then
    echo "⚠️  Simulator $SIMULATOR_NAME ยังไม่ได้เปิด กำลังเปิดให้..."
    xcrun simctl boot "$SIMULATOR_ID" 2>/dev/null || {
        echo "❌ ไม่สามารถเปิด simulator ได้"
        exit 1
    }
    sleep 2
fi

# เพิ่มรูปภาพทีละรูป
SUCCESS_COUNT=0
FAIL_COUNT=0

for IMAGE_PATH in "$@"; do
    # ตรวจสอบว่าไฟล์มีอยู่จริง
    if [ ! -f "$IMAGE_PATH" ]; then
        echo "❌ ไม่พบไฟล์: $IMAGE_PATH"
        ((FAIL_COUNT++))
        continue
    fi
    
    # เพิ่มรูปเข้าไปใน Photos
    echo "📸 กำลังเพิ่มรูป: $(basename "$IMAGE_PATH")"
    if xcrun simctl addphoto "$SIMULATOR_ID" "$IMAGE_PATH" 2>/dev/null; then
        echo "✅ เพิ่มรูปสำเร็จ: $(basename "$IMAGE_PATH")"
        ((SUCCESS_COUNT++))
    else
        echo "❌ ไม่สามารถเพิ่มรูปได้: $(basename "$IMAGE_PATH")"
        ((FAIL_COUNT++))
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ สำเร็จ: $SUCCESS_COUNT รูป"
if [ $FAIL_COUNT -gt 0 ]; then
    echo "❌ ล้มเหลว: $FAIL_COUNT รูป"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

