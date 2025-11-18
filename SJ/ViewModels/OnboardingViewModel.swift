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
    
}


