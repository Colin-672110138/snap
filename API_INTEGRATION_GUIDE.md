# คู่มือการเชื่อมต่อ API - SukJob

## ภาพรวม

แอป SJ (SukJob) ได้เชื่อมต่อกับ SukJob Backend API แล้ว โดยใช้:
- **Base URL**: `http://localhost:4567` (Development)
- **Port**: 4567 (ตาม SukJob-backend)

## ไฟล์ที่เกี่ยวข้อง

1. **Constants.swift** - กำหนด base URL และ endpoints
2. **APIService.swift** - Service สำหรับเรียก API
3. **APIResponse.swift** - Models สำหรับ response จาก API

## API Endpoints ที่รองรับ

### 1. Authentication
```swift
// Login with LINE access token
APIService.shared.mobileLogin(accessToken: "LINE_ACCESS_TOKEN") { result in
    switch result {
    case .success(let response):
        print("Token: \(response.token)")
        print("User ID: \(response.profile.userId)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### 2. Profile Management

#### สร้างโปรไฟล์เกษตรกร (Farmer)
```swift
APIService.shared.createFarmerProfile(
    userId: "U1234567890...",
    idCard: "1234567890123",
    firstName: "สมชาย",
    lastName: "เกษตรกร",
    dateOfBirth: "1990-01-01",
    addressFromIdCard: "123 ถนนเกษตร",
    address: "456 ไร่เกษตร",
    phone: "0812345678",
    farmCount: 5,
    workCount: 10,
    squareMeter: 1000,
    NOLT: 2,
    idcardFront: frontImage,
    idcardBack: backImage,
    idcardWithPerson: personImage
) { result in
    // Handle result
}
```

#### สร้างโปรไฟล์แรงงาน (Worker)
```swift
APIService.shared.createWorkerProfile(
    userId: "U1234567890...",
    idCard: "1234567890123",
    firstName: "สมหญิง",
    lastName: "แรงงาน",
    dateOfBirth: "1995-05-15",
    addressFromIdCard: "789 ถนนแรงงาน",
    address: "321 บ้านแรงงาน",
    phone: "0898765432",
    jobInterest: "งานเกษตรกรรม",
    previousExperience: "มีประสบการณ์ 5 ปี",
    description: "พร้อมทำงานหนัก",
    idcardFront: frontImage,
    idcardBack: backImage,
    idcardWithPerson: personImage
) { result in
    // Handle result
}
```

#### อัปเดตที่อยู่
```swift
APIService.shared.updateProfileAddress(
    userId: "U1234567890...",
    address: "ที่อยู่ใหม่"
) { result in
    // Handle result
}
```

### 3. OCR (ID Card Recognition)
```swift
APIService.shared.processOCR(image: idCardImage) { result in
    switch result {
    case .success(let response):
        print("ID Card: \(response.ocrResult.idCard ?? "")")
        print("Name: \(response.ocrResult.firstName ?? "") \(response.ocrResult.lastName ?? "")")
        print("Date of Birth: \(response.ocrResult.dateOfBirth ?? "")")
        print("Address: \(response.ocrResult.address ?? "")")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### 4. Posts

#### ดึงโพสต์หน้าแรก
```swift
// สำหรับ Worker ดูโพสต์จ้างงาน
APIService.shared.getHomePosts(type: "worker") { result in
    // Handle result
}

// สำหรับ Farmer ดูโพสต์รับงาน
APIService.shared.getHomePosts(type: "farmer") { result in
    // Handle result
}
```

#### ดึงโพสต์ทั้งหมด (พร้อม Pagination)
```swift
APIService.shared.getPosts(type: "worker", page: 1) { result in
    // Handle result
}
```

#### ค้นหาโพสต์
```swift
APIService.shared.searchPosts(type: "worker", query: "เก็บเกี่ยว", page: 1) { result in
    // Handle result
}
```

#### Match โพสต์
```swift
APIService.shared.matchPosts(
    province: "กรุงเทพมหานคร",
    rai: 10,
    workAmount: 5,
    squareMeters: 3200,
    longanTrees: 100
) { result in
    switch result {
    case .success(let response):
        print("Required Workers: \(response.requiredWorkers ?? 0)")
        print("Matched Posts: \(response.matchedPosts.count)")
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### 5. Favorites

#### เพิ่ม Favorite
```swift
APIService.shared.addFavorite(postId: 1, postType: "JobPost") { result in
    // Handle result
}
```

#### ลบ Favorite
```swift
APIService.shared.removeFavorite(postId: 1, postType: "JobPost") { result in
    // Handle result
}
```

#### ดึงรายการ Favorites
```swift
APIService.shared.getFavorites { result in
    switch result {
    case .success(let favorites):
        for favorite in favorites {
            print("Post ID: \(favorite.postId)")
            print("Type: \(favorite.postType)")
        }
    case .failure(let error):
        print("Error: \(error)")
    }
}
```

### 6. Ads (โฆษณา)

```swift
// ดึงโฆษณาทั้งหมด
APIService.shared.getAds { result in
    // Handle result
}

// ดึงโฆษณาตามประเภท
APIService.shared.getAds(type: "worker") { result in
    // Handle result
}
```

## การใช้งานใน ViewModel

### ตัวอย่าง: Login และสร้างโปรไฟล์

```swift
class OnboardingViewModel: ObservableObject {
    func performLogin() {
        // 1. Login with LINE
        LineLoginService.shared.login { result in
            switch result {
            case .success(let lineProfile):
                // 2. Login to backend
                self.loginToBackend(lineProfile: lineProfile)
            case .failure(let error):
                print("LINE Login failed: \(error)")
            }
        }
    }
    
    private func loginToBackend(lineProfile: LineUserProfile) {
        // Get LINE access token
        guard let accessToken = AccessTokenStore.shared.current?.value else {
            print("No access token")
            return
        }
        
        // Login to backend
        APIService.shared.mobileLogin(accessToken: accessToken) { result in
            switch result {
            case .success(let response):
                // Save JWT token (already saved in APIService)
                print("Backend login success")
                
                // Check if user has profile
                if let dbProfile = response.dbProfile {
                    // User has profile, load it
                    self.loadProfile(dbProfile: dbProfile)
                } else {
                    // User needs to create profile
                    self.isAuthenticated = true
                    self.hasSelectedRole = false
                }
            case .failure(let error):
                print("Backend login failed: \(error)")
            }
        }
    }
    
    func createProfile() {
        let userId = self.userProfile.lineID
        
        if self.userProfile.role == .employer {
            // Create Farmer Profile
            APIService.shared.createFarmerProfile(
                userId: userId,
                idCard: self.userProfile.idCardNumber,
                firstName: extractFirstName(from: self.userProfile.name),
                lastName: extractLastName(from: self.userProfile.name),
                dateOfBirth: "1990-01-01", // จาก OCR หรือ user input
                addressFromIdCard: self.ocrData.address,
                address: self.userProfile.currentAddress,
                phone: self.userProfile.phoneNumber,
                farmCount: Int(self.userProfile.farmArea) ?? 0,
                workCount: 0,
                squareMeter: 0,
                NOLT: Int(self.userProfile.longanTrees) ?? 0,
                idcardFront: self.idCardFrontImage,
                idcardBack: self.idCardBackImage,
                idcardWithPerson: self.selfieWithIDImage
            ) { result in
                switch result {
                case .success(let profile):
                    print("Profile created: \(profile)")
                    self.isProfileFullyVerified = true
                case .failure(let error):
                    print("Failed to create profile: \(error)")
                }
            }
        } else {
            // Create Worker Profile
            APIService.shared.createWorkerProfile(
                userId: userId,
                idCard: self.userProfile.idCardNumber,
                firstName: extractFirstName(from: self.userProfile.name),
                lastName: extractLastName(from: self.userProfile.name),
                dateOfBirth: "1990-01-01",
                addressFromIdCard: self.ocrData.address,
                address: self.userProfile.currentAddress,
                phone: self.userProfile.phoneNumber,
                jobInterest: self.userProfile.workType,
                previousExperience: "มีประสบการณ์",
                description: "พร้อมทำงาน",
                idcardFront: self.idCardFrontImage,
                idcardBack: self.idCardBackImage,
                idcardWithPerson: self.selfieWithIDImage
            ) { result in
                switch result {
                case .success(let profile):
                    print("Profile created: \(profile)")
                    self.isProfileFullyVerified = true
                case .failure(let error):
                    print("Failed to create profile: \(error)")
                }
            }
        }
    }
}
```

## การทดสอบ API

### 1. ตรวจสอบว่า backend กำลังรันอยู่

```bash
curl http://localhost:4567/docs
```

ถ้าเปิดได้จะเห็น Swagger documentation

### 2. ทดสอบ Login

```bash
curl -X POST http://localhost:4567/auth/mobile-login \
  -H "Content-Type: application/json" \
  -d '{"accessToken": "YOUR_LINE_ACCESS_TOKEN"}'
```

### 3. เปิด Simulator และทดสอบแอป

```bash
# รันแอปบน simulator
./run_app.sh
```

## หมายเหตุสำคัญ

1. **Base URL**: ต้องแก้ไขใน `Constants.swift` ถ้า backend รันบน IP อื่น
2. **JWT Token**: จะถูกเก็บอัตโนมัติหลัง login สำเร็จ
3. **LINE Access Token**: ต้องได้จาก LINE SDK หลัง login
4. **Image Upload**: ใช้ multipart/form-data สำหรับอัปโหลดรูป
5. **Role Mapping**:
   - `employer` (แอป) = `farmer` (backend)
   - `jobSeeker` (แอป) = `worker` (backend)

## การ Debug

### เปิด Debug Logs

APIService จะพิมพ์ log อัตโนมัติ:
```
🌐 API Request: POST http://localhost:4567/auth/mobile-login
📡 Response Status: 200
📄 Response data: {...}
```

### ตรวจสอบ Network Traffic

ใช้ Charles Proxy หรือ Proxyman เพื่อดู request/response

## Next Steps

1. เชื่อมต่อ `OnboardingViewModel` กับ API จริง
2. เพิ่มการจัดการ error ที่ดีขึ้น
3. เพิ่ม loading states
4. เพิ่ม retry mechanism สำหรับ network errors
5. ใช้ Keychain แทน UserDefaults สำหรับ token

## ตัวอย่างการใช้งานเต็มรูปแบบ

ดูได้ที่ `OnboardingViewModel.swift` และ `LoginViewModel.swift`

