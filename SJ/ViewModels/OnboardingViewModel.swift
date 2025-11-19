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
    // MARK: - Mock Login (จำลองการทำงานของ LINE Login)
    func performLineLogin() {
        // --- จำลองการทำงานของ LineLoginService ---
        // ในโปรเจกต์จริงจะมีการเรียกใช้ SDK ของ LINE ที่นี่
        
        // Mock Data: สมมติว่าดึงชื่อมาได้
        userProfile.lineID = "U1234567890"
        userProfile.name = "สมหมาย เกษตรดี" // ชื่อที่ดึงมาจาก LINE
        
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
            ocrData.idCardNumber = "1-1205-10123-45-7"
            ocrData.title = "นาย"
            ocrData.firstName = "สมหมาย"
            ocrData.lastName = "เกษตรดี"
            ocrData.dateOfBirth = "01/01/2530"
            ocrData.address = "99 หมู่ 5 ต.ลำไย อ.เมือง จ.เชียงใหม่ 50000"
            
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
        
        let defaultProfileImage = UIImage(systemName: "person.circle.fill") ?? UIImage()
        let defaultPostImage = UIImage(systemName: "photo") ?? UIImage()
        
        // ผู้หางาน (ให้ผู้จ้างงานเห็น)
        jobSeekerFeedPosts = [
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: defaultProfileImage,
                userName: "สมหญิง ชอบเก็บ",
                postTime: "2 ชม.ที่แล้ว",
                hourlyRate: "450/วัน",
                currentRating: 4.8,
                reviewCount: 15,
                isFavorite: true,
                postImage: defaultPostImage,
                title: "รับเก็บลำไยด่วน 5 คน",
                province: "เชียงใหม่",
                numberPeople: 5,
                contactNumber: "081-xxx-xxxx",
                startDate: "15 พ.ย."
            ),
            JobSeekerPostCardModel(
                postID: UUID().uuidString,
                profileImage: defaultProfileImage,
                userName: "นาย A",
                postTime: "1 วันที่แล้ว",
                hourlyRate: "300/วัน",
                currentRating: 4.1,
                reviewCount: 8,
                isFavorite: false,
                postImage: defaultPostImage,
                title: "รับคัดแยกผลผลิต/ขนส่ง",
                province: "ลำพูน",
                numberPeople: 2,
                contactNumber: "099-xxx-xxxx",
                startDate: "20 พ.ย."
            )
        ]
        
        // ผู้จ้างงาน (ให้ผู้หางานเห็น)
        employerFeedPosts = [
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: defaultProfileImage,
                farmName: "สวนลำไยคุณชาย",
                postTime: "1 ชม.ที่แล้ว",
                letCompensation: "500/วัน",
                currentRating: 4.5,
                reviewCount: 22,
                isFavorite: false,
                postImage: defaultPostImage,
                title: "ด่วน! หาคนงาน 10 คน เก็บต.อ.",
                province: "ลำพูน",
                areaSize: "15 ไร่",
                welfare: "มีข้าวฟรี/น้ำดื่ม",
                startDate: "16 พ.ย.",
                contactNumber: "089-xxx-xxxx"
            ),
            EmployerPostCardModel(
                postID: UUID().uuidString,
                profileImage: defaultProfileImage,
                farmName: "ไร่ลุงดำ",
                postTime: "5 ชม.ที่แล้ว",
                letCompensation: "400/วัน",
                currentRating: 4.0,
                reviewCount: 10,
                isFavorite: true,
                postImage: defaultPostImage,
                title: "เก็บคัดแยกผลผลิต 3 ตัน",
                province: "เชียงราย",
                areaSize: "5 ไร่",
                welfare: "ที่พักฟรี",
                startDate: "25 พ.ย.",
                contactNumber: "066-xxx-xxxx"
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
    
    // ให้ดาวโพสต์ “จ้างงาน”
    func addReview(forEmployerPost post: EmployerPostCardModel, rating: Int) {
        let reviewerID = userProfile.lineID
        let reviewerName = userProfile.name.isEmpty ? "ผู้ใช้" : userProfile.name
        
        let review = ReviewModel(
            reviewerID: reviewerID,
            reviewerName: reviewerName,
            rating: rating,
            createdAt: Date()
        )
        
        // 1) เก็บลง dictionary
        var list = employerReviewsByPostID[post.postID] ?? []
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

    // ให้ดาวโพสต์ “หางาน”
    func addReview(forJobSeekerPost post: JobSeekerPostCardModel, rating: Int) {
        let reviewerID = userProfile.lineID
        let reviewerName = userProfile.name.isEmpty ? "ผู้ใช้" : userProfile.name
        
        let review = ReviewModel(
            reviewerID: reviewerID,
            reviewerName: reviewerName,
            rating: rating,
            createdAt: Date()
        )
        
        // 1) เก็บลง dictionary
        var list = jobSeekerReviewsByPostID[post.postID] ?? []
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
    
    
    
    
    
}


