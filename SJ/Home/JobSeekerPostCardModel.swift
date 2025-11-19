// Models/JobSeekerPostCardModel.swift

import Foundation
import UIKit // สำหรับ UIImage

// ข้อมูลโพสต์ที่ผู้หางานสร้าง (ที่ผู้จ้างงานเห็น)
struct JobSeekerPostCardModel: Identifiable, Equatable {
    let id = UUID()
    let postID: String
    
    // Header/Profile Data
    let profileImage: UIImage
    let userName: String
    let postTime: String
    let hourlyRate: String // ค่าแรงต่อวัน/ชั่วโมง (เช่น "300/วัน")
    var currentRating: Double // 4.5
    var reviewCount: Int // (10 จำนวนคน)
    var isFavorite: Bool
    
    // Body Data
    let postImage: UIImage
    let title: String // หัวข้อ (เช่น รับเก็บลำไย)
    let province: String
    let numberPeople: Int
    let contactNumber: String
    let startDate: String // วันที่เริ่มงาน
    
    // เทียบความเท่ากันจาก postID
    static func == (lhs: JobSeekerPostCardModel, rhs: JobSeekerPostCardModel) -> Bool {
        lhs.postID == rhs.postID
    }
}
