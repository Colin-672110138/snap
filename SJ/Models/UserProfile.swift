//
//  UserProfile.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Models/UserProfile.swift

import Foundation
import Combine

enum UserRole: String, Codable {
    case employer = "ผู้จ้างงาน"
    case jobSeeker = "ผู้หางาน"
    case none // ยังไม่ได้เลือก
}

struct UserProfile: Codable {
    // ข้อมูลจาก LINE Login (หน้า 1 และ 2)
    var lineID: String = ""
    var name: String = ""
    
    // บทบาทที่เลือก (หน้า 2)
    var role: UserRole = .none
    
    // ข้อมูลที่กรอกในขั้นตอนต่อๆ ไป
    var gender: String = ""
    var idCardNumber: String = "" // จาก OCR
    var currentAddress: String = ""
    var phoneNumber: String = ""
    
    var farmArea: String = ""          // จำนวนไร่
    var longanTrees: String = ""       // จำนวนต้นลำไย
    var workType: String = ""          // ประเภทงานที่ต้องการ
    var province: String = ""

    // ... อื่นๆ
}
