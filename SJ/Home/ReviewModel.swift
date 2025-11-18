//
//  ReviewModel.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

import Foundation

// ข้อมูลรีวิว (สำหรับแสดงใน Post Detail View)
struct ReviewModel: Identifiable {
    let id = UUID()
    let reviewerName: String
    let rating: Int // 1 ถึง 5 ดาว
}
