#!/bin/bash

# สคริปต์สำหรับรันแอป SJ บน iOS Simulator
# วิธีใช้: ./run_app.sh [simulator_name]

BUNDLE_ID="colin.black.SJ"

# ตรวจสอบ argument
if [ $# -eq 0 ]; then
    # ถ้าไม่ระบุ simulator จะรันบนทั้งสองตัว
    echo "🚀 กำลังรันแอปบน iPhone 17 Pro และ iPhone 17 Pro Max..."
    
    # ตรวจสอบว่า simulator เปิดอยู่หรือไม่
    xcrun simctl list devices | grep "iPhone 17 Pro" | grep -q "Booted" || {
        echo "⚠️  กำลังเปิด simulator..."
        xcrun simctl boot "iPhone 17 Pro" 2>/dev/null
        xcrun simctl boot "iPhone 17 Pro Max" 2>/dev/null
        sleep 2
    }
    
    # รันแอปบนทั้งสองตัว
    echo "📱 กำลังรันแอปบน iPhone 17 Pro..."
    xcrun simctl launch "iPhone 17 Pro" "$BUNDLE_ID" 2>/dev/null && echo "✅ รันแอปบน iPhone 17 Pro สำเร็จ"
    
    echo "📱 กำลังรันแอปบน iPhone 17 Pro Max..."
    xcrun simctl launch "iPhone 17 Pro Max" "$BUNDLE_ID" 2>/dev/null && echo "✅ รันแอปบน iPhone 17 Pro Max สำเร็จ"
    
else
    # รันบน simulator ที่ระบุ
    SIMULATOR_NAME="$1"
    echo "🚀 กำลังรันแอปบน $SIMULATOR_NAME..."
    
    # ตรวจสอบว่า simulator เปิดอยู่หรือไม่
    xcrun simctl list devices | grep "$SIMULATOR_NAME" | grep -q "Booted" || {
        echo "⚠️  กำลังเปิด $SIMULATOR_NAME..."
        xcrun simctl boot "$SIMULATOR_NAME" 2>/dev/null || {
            echo "❌ ไม่สามารถเปิด $SIMULATOR_NAME ได้"
            exit 1
        }
        sleep 2
    }
    
    xcrun simctl launch "$SIMULATOR_NAME" "$BUNDLE_ID" 2>/dev/null && echo "✅ รันแอปบน $SIMULATOR_NAME สำเร็จ" || {
        echo "❌ ไม่สามารถรันแอปได้"
        echo "💡 ลอง build แอปก่อน: xcodebuild -project SJ.xcodeproj -scheme SJ -destination 'platform=iOS Simulator,name=$SIMULATOR_NAME' build"
        exit 1
    }
fi

