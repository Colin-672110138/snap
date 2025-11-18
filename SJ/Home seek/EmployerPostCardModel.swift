//
//  EmployerPostCardModel.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Models/EmployerPostCardModel.swift

import Foundation
import UIKit

// ข้อมูลโพสต์ที่ผู้จ้างงานสร้าง (ที่ผู้หางานเห็น)
struct EmployerPostCardModel: Identifiable {
    let id = UUID()
    let postID: String = UUID().uuidString
    
    // Header/Profile Data
    let profileImage: UIImage = UIImage(systemName: "person.circle.fill")!
    let farmName: String // ชื่อสวน/ผู้จ้างงาน
    let postTime: String
    let letCompensation: String // ค่าตอบแทน (e.g., "500/วัน")
    let currentRating: Double
    let reviewCount: Int
    var isFavorite: Bool
    
    // Body Data
    let postImage: UIImage
    let title: String // หัวข้อ (e.g., หาคนเก็บลำไย)
    let province: String
    let areaSize: String // ปริมาณ/ไร่
    let welfare: String // สวัสดิการ
    let startDate: String // วันที่เริ่มงาน
    let contactNumber: String
}
