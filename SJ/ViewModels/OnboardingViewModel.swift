//
//  OnboardingViewModel.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// ViewModels/OnboardingViewModel.swift

import Foundation   
import SwiftUI // <--- ต้องมี
import Combine // <--- ต้องมี
import UIKit

class OnboardingViewModel: ObservableObject {
    // เก็บข้อมูลผู้ใช้ทั้งหมดในระหว่างขั้นตอน Onboarding
    @Published var userProfile: UserProfile = UserProfile()
    
    
    // สถานะสำหรับควบคุมการนำทาง (Navigation)
    @Published var isAuthenticated: Bool = false // หน้า 1
    @Published var hasSelectedRole: Bool = false // หน้า 2
    
    @Published var idCardFrontImage: UIImage?
    @Published var idCardBackImage: UIImage?
    @Published var selfieWithIDImage: UIImage?
    @Published var isProfileFullyVerified: Bool = false
    
    @Published var isLoggedOut: Bool = false
    @Published var isCurrentAddressSameAsIDCard: Bool = false // <<< สถานะ Checkbox
    @Published var currentTabIndex: Int = 0
    
    @Published var employerFeedPosts: [EmployerPostCardModel] = []
    @Published var jobSeekerFeedPosts: [JobSeekerPostCardModel] = []

    @Published var myEmployerPosts: [EmployerPostCardModel] = []
    @Published var myJobSeekerPosts: [JobSeekerPostCardModel] = []

    @Published var favoriteEmployerPosts: [EmployerPostCardModel] = []
    @Published var favoriteJobSeekerPosts: [JobSeekerPostCardModel] = []
    
    @Published var employerReviewsByPostID: [String: [ReviewModel]] = [:]
    @Published var jobSeekerReviewsByPostID: [String: [ReviewModel]] = [:]
    
    
    
    @Published var ocrData: IDCardData = IDCardData()
    
    // MARK: - Helper: Generate Random Phone Number
    // สุ่มเบอร์โทรศัพท์ไทย (10 หลัก)
    private func generateRandomPhoneNumber() -> String {
        let prefixes = ["081", "082", "083", "084", "085", "086", "087", "088", "089", "090", "091", "092", "093", "094", "095", "096", "097", "098", "099"]
        let prefix = prefixes.randomElement() ?? "081"
        let number1 = Int.random(in: 100...999)
        let number2 = Int.random(in: 1000...9999)
        return "\(prefix)-\(number1)-\(number2)"
    }
    
    // MARK: - Mock Login (จำลองการทำงานของ LINE Login)
    func performLineLogin() {
        // --- จำลองการทำงานของ LineLoginService ---
        // ในโปรเจกต์จริงจะมีการเรียกใช้ SDK ของ LINE ที่นี่
        
        // Mock Data: สมมติว่าดึงชื่อมาได้
        userProfile.lineID = "UDl97943DWfsePV34p890"
        userProfile.name = "Rachanon" // ชื่อที่ดึงมาจาก LINE
        
        // หากสำเร็จ
        isAuthenticated = true
    }
    
    // MARK: - Role Selection
    func selectRole(_ role: UserRole) {
        userProfile.role = role
        hasSelectedRole = true
        print("User selected role: \(userProfile.role.rawValue)")
    }
    
    func performMockOCR() {
            // --- จำลองการเรียกใช้ OCRService ---
            // เมื่อรูปถ่ายคู่บัตร (หน้า 5) ถูกอัปโหลด
            
            // Mock Data: สมมติว่า OCR อ่านข้อมูลได้
            ocrData.idCardNumber = "1-51010-10492-71-9"
            ocrData.title = "นาย"
            ocrData.firstName = "รชานนท์"
            ocrData.lastName = "อินต๊ะมี"
            ocrData.dateOfBirth = "15/07/2006"
            ocrData.address = "ที่อยู่ 46/2 หมู่ที่ 13  ต.ทาปลาดุก"
            
            // อัปเดตชื่อใน UserProfile ด้วยชื่อจากบัตร (ถ้ามีการแก้ไขในขั้นตอนก่อนหน้า)
            userProfile.name = "\(ocrData.title) \(ocrData.firstName) \(ocrData.lastName)"
        }
    func savePersonalInfo(phoneNumber: String) {
            // อัปเดตข้อมูลผู้ใช้หลักด้วยข้อมูลที่ OCR อ่านได้และเบอร์โทรที่กรอก
            userProfile.idCardNumber = ocrData.idCardNumber
            // ... (นำข้อมูลอื่นๆ ที่ OCR อ่านได้ไปเก็บใน userProfile ตามความเหมาะสม)
            userProfile.phoneNumber = phoneNumber // ต้องเพิ่ม phoneNumber ใน UserProfile ด้วย
            
            print("Personal Info Saved: \(userProfile.name), Tel: \(phoneNumber)")
        }
    
    
        // ... (Existing Published variables)
        
        // MARK: - New: ข้อมูลเฉพาะบทบาท
        @Published var employerProfile = EmployerProfile()
        @Published var jobSeekerProfile = JobSeekerProfile() // จะใช้ในขั้นตอน 7B
        
        // ... (Existing functions)
        
        // MARK: - New: ฟังก์ชันบันทึกข้อมูลผู้จ้างงาน
        func saveEmployerProfile(rai: Int?, ngan: Int?, sqMeters: Int?, treeCount: Int?) {
            employerProfile.rai = rai
            employerProfile.ngan = ngan
            employerProfile.squareMeters = sqMeters
            employerProfile.longanTreeCount = treeCount
            
            
            print("Employer Profile Saved.")
        }
        
        // MARK: - New: ฟังก์ชันบันทึกข้อมูลผู้หางาน
        func saveJobSeekerProfile(position: String, hasExp: Bool, expDesc: String) {
                jobSeekerProfile.interestedPosition = position
                jobSeekerProfile.hasExperience = hasExp
                jobSeekerProfile.experienceDescription = expDesc
                
                print("Job Seeker Profile Saved.")
            }
    
    func logout() {
            // รีเซ็ตข้อมูลผู้ใช้ทั้งหมด (ถ้าต้องการ)
            userProfile = UserProfile()
            ocrData = IDCardData()
            
            // กำหนดให้ isLoggedOut เป็น true เพื่อ Trigger การเปลี่ยนหน้า
            isLoggedOut = true
            
            // กำหนดให้ isAuthenticated เป็น false ด้วย (ถ้าคุณใช้ Logic นี้ใน ContentView)
            isAuthenticated = false
        }
    
    
    
    
    func loadMockPostsIfNeeded() {
        if !employerFeedPosts.isEmpty || !jobSeekerFeedPosts.isEmpty {
            return
        }
        
        // ใช้ system icon เป็น default (สามารถเพิ่มรูปใน Assets.xcassets ได้ภายหลัง)
        let defaultProfileImage = UIImage(systemName: "person.circle.fill") ?? UIImage()
        let defaultPostImage = UIImage(systemName: "photo") ?? UIImage()
        
        let profile1 = defaultProfileImage
        let profile2 = defaultProfileImage
        let profile3 = defaultProfileImage
        let profile4 = defaultProfileImage
        let profile5 = defaultProfileImage
        
        let post1 = defaultPostImage
        let post2 = defaultPostImage
        let post3 = defaultPostImage
        let post4 = defaultPostImage
        let post5 = defaultPostImage
        
        // ผู้หางาน (ให้ผู้จ้างงานเห็น) - เฉพาะโพสต์เกี่ยวกับลำไย
        jobSeekerFeedPosts = [
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: profile1,
                userName: "สมหญิง ชอบเก็บ",
                postTime: "2 ชม.ที่แล้ว",
                hourlyRate: "450/วัน",
                currentRating: 4.8,
                reviewCount: 15,
                isFavorite: false,
                postImage: post1,
                title: "รับเก็บลำไยด่วน",
                province: "เชียงใหม่",
                numberPeople: 5,
                contactNumber: generateRandomPhoneNumber(),
                startDate: "15 พ.ย."
            ),
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: profile2,
                userName: "นายสมชาย ขยันงาน",
                postTime: "6 ชม.ที่แล้ว",
                hourlyRate: "400/วัน",
                currentRating: 4.6,
                reviewCount: 12,
                isFavorite: false,
                postImage: post2,
                title: "รับลงลำไย",
                province: "เชียงใหม่",
                numberPeople: 4,
                contactNumber: generateRandomPhoneNumber(),
                startDate: "18 พ.ย."
            ),
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: profile3,
                userName: "นางสาวบัว ใจดี",
                postTime: "3 ชม.ที่แล้ว",
                hourlyRate: "420/วัน",
                currentRating: 4.7,
                reviewCount: 18,
                isFavorite: false,
                postImage: post3,
                title: "รับเก็บลำไย",
                province: "ลำพูน",
                numberPeople: 6,
                contactNumber: generateRandomPhoneNumber(),
                startDate: "20 พ.ย."
            ),
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: profile4,
                userName: "นายประเสริฐ ทำงานดี",
                postTime: "5 ชม.ที่แล้ว",
                hourlyRate: "380/วัน",
                currentRating: 4.4,
                reviewCount: 14,
                isFavorite: false,
                postImage: post4,
                title: "รับลงลำไย",
                province: "เชียงราย",
                numberPeople: 3,
                contactNumber: generateRandomPhoneNumber(),
                startDate: "22 พ.ย."
            ),
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: profile5,
                userName: "นางมาลี มีประสบการณ์",
                postTime: "1 วันที่แล้ว",
                hourlyRate: "470/วัน",
                currentRating: 4.9,
                reviewCount: 25,
                isFavorite: false,
                postImage: post5,
                title: "รับเก็บลำไยด่วน",
                province: "เชียงใหม่",
                numberPeople: 8,
                contactNumber: generateRandomPhoneNumber(),
                startDate: "19 พ.ย."
            )
        ]
        
        // ใช้ system icon เป็น default สำหรับผู้จ้างงาน
        let employerProfile1 = defaultProfileImage
        let employerProfile2 = defaultProfileImage
        let employerProfile3 = defaultProfileImage
        let employerProfile4 = defaultProfileImage
        let employerProfile5 = defaultProfileImage
        
        let employerPost1 = defaultPostImage
        let employerPost2 = defaultPostImage
        let employerPost3 = defaultPostImage
        let employerPost4 = defaultPostImage
        let employerPost5 = defaultPostImage
        
        // ผู้จ้างงาน (ให้ผู้หางานเห็น) - เฉพาะโพสต์เกี่ยวกับลำไย
        employerFeedPosts = [
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: employerProfile1,
                farmName: "สวนลำไยคุณชาย",
                postTime: "1 ชม.ที่แล้ว",
                letCompensation: "500/วัน",
                currentRating: 4.5,
                reviewCount: 22,
                isFavorite: false,
                postImage: employerPost1,
                title: "ด่วน! หาคนงานเก็บลำไย",
                province: "ลำพูน",
                areaSize: "15 ไร่",
                welfare: "มีข้าวฟรี/น้ำดื่ม",
                startDate: "16 พ.ย.",
                contactNumber: generateRandomPhoneNumber()
            ),
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: employerProfile2,
                farmName: "สวนลำไยคุณแม่",
                postTime: "2 ชม.ที่แล้ว",
                letCompensation: "450/วัน",
                currentRating: 4.6,
                reviewCount: 16,
                isFavorite: false,
                postImage: employerPost2,
                title: "หาคนงานลงลำไย",
                province: "เชียงใหม่",
                areaSize: "12 ไร่",
                welfare: "อาหารกลางวันฟรี",
                startDate: "17 พ.ย.",
                contactNumber: generateRandomPhoneNumber()
            ),
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: employerProfile3,
                farmName: "ไร่ลุงดำ",
                postTime: "4 ชม.ที่แล้ว",
                letCompensation: "480/วัน",
                currentRating: 4.4,
                reviewCount: 18,
                isFavorite: false,
                postImage: employerPost3,
                title: "หาคนงานเก็บลำไย",
                province: "เชียงราย",
                areaSize: "20 ไร่",
                welfare: "ที่พักฟรี",
                startDate: "21 พ.ย.",
                contactNumber: generateRandomPhoneNumber()
            ),
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: employerProfile4,
                farmName: "สวนผลไม้คุณป้า",
                postTime: "3 ชม.ที่แล้ว",
                letCompensation: "420/วัน",
                currentRating: 4.3,
                reviewCount: 13,
                isFavorite: false,
                postImage: employerPost4,
                title: "ต้องการคนงานลงลำไย",
                province: "ลำปาง",
                areaSize: "10 ไร่",
                welfare: "รถรับส่งฟรี",
                startDate: "23 พ.ย.",
                contactNumber: generateRandomPhoneNumber()
            ),
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: employerProfile5,
                farmName: "สวนลำไยคุณตา",
                postTime: "7 ชม.ที่แล้ว",
                letCompensation: "460/วัน",
                currentRating: 4.7,
                reviewCount: 20,
                isFavorite: false,
                postImage: employerPost5,
                title: "ด่วน! หาคนงานเก็บลำไย",
                province: "เชียงใหม่",
                areaSize: "30 ไร่",
                welfare: "อาหารครบ 3 มื้อ",
                startDate: "24 พ.ย.",
                contactNumber: generateRandomPhoneNumber()
            )
        ]
        
        // sync favorite เริ่มต้น
        favoriteJobSeekerPosts = jobSeekerFeedPosts.filter { $0.isFavorite }
        favoriteEmployerPosts = employerFeedPosts.filter { $0.isFavorite }
    }

    // MARK: - Add Post from Posting Flow

    func addEmployerPost(from data: EmployerPostData) {
        let defaultProfileImage = UIImage(systemName: "person.circle.fill") ?? UIImage()
        let postImage = data.image ?? (UIImage(systemName: "photo") ?? UIImage())
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th_TH")
        formatter.dateFormat = "d MMM"
        
        let newPost = EmployerPostCardModel(
            postID: UUID().uuidString,
            profileImage: defaultProfileImage,
            farmName: userProfile.name.isEmpty ? "สวนของฉัน" : userProfile.name,
            postTime: "เพิ่งโพสต์",
            letCompensation: data.compensation,
            currentRating: 0,
            reviewCount: 0,
            isFavorite: false,
            postImage: postImage,
            title: data.title,
            province: data.province,
            areaSize: data.quantityRai,
            welfare: data.welfare.isEmpty ? "-" : data.welfare,
            startDate: formatter.string(from: data.startDate),
            contactNumber: data.contactNumber
        )
        
        employerFeedPosts.insert(newPost, at: 0)
        myEmployerPosts.insert(newPost, at: 0)
    }

    func addJobSeekerPost(from data: JobSeekerPostData) {
        let defaultProfileImage = UIImage(systemName: "person.circle.fill") ?? UIImage()
        let postImage = data.image ?? (UIImage(systemName: "photo") ?? UIImage())
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "th_TH")
        formatter.dateFormat = "d MMM"
        
        let newPost = JobSeekerPostCardModel(
            postID: UUID().uuidString,
            profileImage: defaultProfileImage,
            userName: userProfile.name.isEmpty ? "ฉันเอง" : userProfile.name,
            postTime: "เพิ่งโพสต์",
            hourlyRate: data.compensation,
            currentRating: 0,
            reviewCount: 0,
            isFavorite: false,
            postImage: postImage,
            title: data.title,
            province: data.province,
            numberPeople: Int(data.numberPeople) ?? 1,
            contactNumber: data.contactNumber,
            startDate: formatter.string(from: data.startDate)
        )
        
        jobSeekerFeedPosts.insert(newPost, at: 0)
        myJobSeekerPosts.insert(newPost, at: 0)
    }

    // MARK: - Toggle Favorite

    func toggleFavorite(for post: EmployerPostCardModel) {
        // อัปเดตใน feed
        if let index = employerFeedPosts.firstIndex(of: post) {
            employerFeedPosts[index].isFavorite.toggle()
            let updated = employerFeedPosts[index]
            
            if updated.isFavorite {
                if !favoriteEmployerPosts.contains(updated) {
                    favoriteEmployerPosts.append(updated)
                }
            } else {
                favoriteEmployerPosts.removeAll { $0.postID == updated.postID }
            }
        }
        
        // sync กับ myEmployerPosts ถ้ามี
        if let myIndex = myEmployerPosts.firstIndex(of: post) {
            myEmployerPosts[myIndex].isFavorite.toggle()
        }
    }

    func toggleFavorite(for post: JobSeekerPostCardModel) {
        if let index = jobSeekerFeedPosts.firstIndex(of: post) {
            jobSeekerFeedPosts[index].isFavorite.toggle()
            let updated = jobSeekerFeedPosts[index]
            
            if updated.isFavorite {
                if !favoriteJobSeekerPosts.contains(updated) {
                    favoriteJobSeekerPosts.append(updated)
                }
            } else {
                favoriteJobSeekerPosts.removeAll { $0.postID == updated.postID }
            }
        }
        
        if let myIndex = myJobSeekerPosts.firstIndex(of: post) {
            myJobSeekerPosts[myIndex].isFavorite.toggle()
        }
    }
    
    // MARK: - Delete Post
    
    func deleteEmployerPost(postID: String) {
        // ลบจาก myEmployerPosts
        myEmployerPosts.removeAll { $0.postID == postID }
        
        // ลบจาก employerFeedPosts
        employerFeedPosts.removeAll { $0.postID == postID }
        
        // ลบจาก favoriteEmployerPosts ถ้ามี
        favoriteEmployerPosts.removeAll { $0.postID == postID }
        
        // ลบ reviews ที่เกี่ยวข้อง
        employerReviewsByPostID.removeValue(forKey: postID)
    }
    
    func deleteJobSeekerPost(postID: String) {
        // ลบจาก myJobSeekerPosts
        myJobSeekerPosts.removeAll { $0.postID == postID }
        
        // ลบจาก jobSeekerFeedPosts
        jobSeekerFeedPosts.removeAll { $0.postID == postID }
        
        // ลบจาก favoriteJobSeekerPosts ถ้ามี
        favoriteJobSeekerPosts.removeAll { $0.postID == postID }
        
        // ลบ reviews ที่เกี่ยวข้อง
        jobSeekerReviewsByPostID.removeValue(forKey: postID)
    }
    
    // ให้ดาวโพสต์ "จ้างงาน"
    func addReview(forEmployerPost post: EmployerPostCardModel, rating: Int) {
        let reviewerID = userProfile.lineID
        let reviewerName = userProfile.name.isEmpty ? "ผู้ใช้" : userProfile.name
        
        // ตรวจสอบว่าเป็นโพสต์ของตัวเองหรือไม่
        let isMyPost = myEmployerPosts.contains { $0.postID == post.postID }
        if isMyPost {
            print("ไม่สามารถให้คะแนนโพสต์ของตัวเองได้")
            return
        }
        
        // ตรวจสอบว่าเคยให้คะแนนไปแล้วหรือยัง
        var list = employerReviewsByPostID[post.postID] ?? []
        let hasAlreadyRated = list.contains { $0.reviewerID == reviewerID }
        if hasAlreadyRated {
            print("คุณได้ให้คะแนนโพสต์นี้แล้ว")
            return
        }
        
        let review = ReviewModel(
            reviewerID: reviewerID,
            reviewerName: reviewerName,
            rating: rating,
            createdAt: Date()
        )
        
        // 1) เก็บลง dictionary
        list.append(review)
        employerReviewsByPostID[post.postID] = list
        
        // 2) คำนวณค่าเฉลี่ยใหม่
        let total = list.reduce(0) { $0 + $1.rating }
        let avg = Double(total) / Double(list.count)
        
        // 3) อัปเดตใน feed หลัก
        if let idx = employerFeedPosts.firstIndex(where: { $0.postID == post.postID }) {
            employerFeedPosts[idx].currentRating = avg
            employerFeedPosts[idx].reviewCount = list.count
        }
        
        // 4) sync ในโพสต์ของฉัน
        if let idx = myEmployerPosts.firstIndex(where: { $0.postID == post.postID }) {
            myEmployerPosts[idx].currentRating = avg
            myEmployerPosts[idx].reviewCount = list.count
        }
    }

    // ให้ดาวโพสต์ "หางาน"
    func addReview(forJobSeekerPost post: JobSeekerPostCardModel, rating: Int) {
        let reviewerID = userProfile.lineID
        let reviewerName = userProfile.name.isEmpty ? "ผู้ใช้" : userProfile.name
        
        // ตรวจสอบว่าเป็นโพสต์ของตัวเองหรือไม่
        let isMyPost = myJobSeekerPosts.contains { $0.postID == post.postID }
        if isMyPost {
            print("ไม่สามารถให้คะแนนโพสต์ของตัวเองได้")
            return
        }
        
        // ตรวจสอบว่าเคยให้คะแนนไปแล้วหรือยัง
        var list = jobSeekerReviewsByPostID[post.postID] ?? []
        let hasAlreadyRated = list.contains { $0.reviewerID == reviewerID }
        if hasAlreadyRated {
            print("คุณได้ให้คะแนนโพสต์นี้แล้ว")
            return
        }
        
        let review = ReviewModel(
            reviewerID: reviewerID,
            reviewerName: reviewerName,
            rating: rating,
            createdAt: Date()
        )
        
        // 1) เก็บลง dictionary
        list.append(review)
        jobSeekerReviewsByPostID[post.postID] = list
        
        // 2) คำนวณค่าเฉลี่ยใหม่
        let total = list.reduce(0) { $0 + $1.rating }
        let avg = Double(total) / Double(list.count)
        
        // 3) อัปเดตใน feed หลัก
        if let idx = jobSeekerFeedPosts.firstIndex(where: { $0.postID == post.postID }) {
            jobSeekerFeedPosts[idx].currentRating = avg
            jobSeekerFeedPosts[idx].reviewCount = list.count
        }
        
        // 4) sync ในโพสต์ของฉัน
        if let idx = myJobSeekerPosts.firstIndex(where: { $0.postID == post.postID }) {
            myJobSeekerPosts[idx].currentRating = avg
            myJobSeekerPosts[idx].reviewCount = list.count
        }
    }
    
    func getMatchedJobSeekers(forProvince province: String) -> [JobSeekerPostCardModel] {
        let filtered = jobSeekerFeedPosts.filter { $0.province == province }
        return Array(filtered.prefix(5))
    }

    func getMatchedEmployerPosts(forProvince province: String) -> [EmployerPostCardModel] {
        let filtered = employerFeedPosts.filter { $0.province == province }
        return Array(filtered.prefix(5))
    }

    
    func getRandomMatchedJobSeekers(forProvince province: String) -> [JobSeekerPostCardModel] {
        let filtered = jobSeekerFeedPosts.filter { $0.province == province }
        return Array(filtered.shuffled().prefix(5))
    }

    func getRandomMatchedEmployerPosts(forProvince province: String) -> [EmployerPostCardModel] {
        let filtered = employerFeedPosts.filter { $0.province == province }
        return Array(filtered.shuffled().prefix(5))
    }

    
    
    
    
    
}


