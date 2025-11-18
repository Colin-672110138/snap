//
//  RoleSpecificHomeView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/RoleSpecific/RoleSpecificHomeView.swift

import SwiftUI

struct RoleSpecificHomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var searchText: String = ""
    
    // Mock Data สำหรับฟีด (Job Seeker Posts - เห็นโดย Employer)
    let mockJobSeekerPosts: [JobSeekerPostCardModel] = [
        JobSeekerPostCardModel(
            userName: "สมหญิง ชอบเก็บ", postTime: "2 ชม.ที่แล้ว",
            hourlyRate: "450/วัน", currentRating: 4.8, reviewCount: 15, isFavorite: true,
            postImage: UIImage(systemName: "hand.raised.fill")!, title: "รับเก็บลำไยด่วน 5 คน",
            province: "เชียงใหม่", numberPeople: 5, contactNumber: "081-xxx-xxxx", startDate: "15 พ.ย."
        ),
        JobSeekerPostCardModel(
            userName: "นาย A", postTime: "1 วันที่แล้ว",
            hourlyRate: "300/วัน", currentRating: 4.1, reviewCount: 8, isFavorite: false,
            postImage: UIImage(systemName: "hammer.fill")!, title: "รับคัดแยกผลผลิต/ขนส่ง",
            province: "ลำพูน", numberPeople: 2, contactNumber: "099-xxx-xxxx", startDate: "20 พ.ย."
        )
    ]
    // Mock Data สำหรับฟีด (Employer Posts - เห็นโดย Job Seeker)
    let mockEmployerPosts: [EmployerPostCardModel] = [
        EmployerPostCardModel(
            farmName: "สวนลำไยคุณชาย", postTime: "1 ชม.ที่แล้ว",
            letCompensation: "500/วัน", currentRating: 4.5, reviewCount: 22, isFavorite: false,
            postImage: UIImage(systemName: "tree.fill")!, title: "ด่วน! หาคนงาน 10 คน เก็บต.อ.",
            province: "ลำพูน", areaSize: "15 ไร่", welfare: "มีข้าวฟรี/น้ำดื่ม", startDate: "16 พ.ย.", contactNumber: "089-xxx-xxxx"
        ),
        EmployerPostCardModel(
            farmName: "ไร่ลุงดำ", postTime: "5 ชม.ที่แล้ว",
            letCompensation: "400/วัน", currentRating: 4.0, reviewCount: 10, isFavorite: true,
            postImage: UIImage(systemName: "leaf.fill")!, title: "เก็บคัดแยกผลผลิต 3 ตัน",
            province: "เชียงราย", areaSize: "5 ไร่", welfare: "ที่พักฟรี", startDate: "25 พ.ย.", contactNumber: "066-xxx-xxxx"
        )
    ]

    var body: some View {
        // ใช้ ScrollView เพื่อให้ฟีดทั้งหมดเลื่อนได้
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header และ Title
                HStack(alignment: .center) {
                    Spacer()
                    Text("Suk")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.yellow)
                    + Text("Job")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.green)
                    
                    Spacer()
                    
                    // Icon กระดิ่ง (Placeholder)
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // MARK: - Search Bar
                HStack {
                    // 1. ช่อง TextField
                    TextField("ค้นหา โพสต์หางาน...", text: $searchText)
                        .padding(.leading, 10)
                    
                    // 2. Icon แว่นขยาย (อยู่ขวามือ)
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // MARK: - โฆษณา (Ads Carousel)
                AdCarouselView() // Component แยก
                    .frame(height: 150)
                    .padding(.bottom, 20)
                
                // MARK: - ส่วนฟีด: หัวข้อและปุ่มทั้งหมด (Logic เริ่มตรงนี้)
                HStack {
                    // Title เปลี่ยนไปตาม Role
                    Text(viewModel.userProfile.role == .employer ? "โพสต์หางาน" : "โพสต์จ้างงาน")
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    
                    Button("ทั้งหมด") {
                        // TODO: นำทางไปหน้าดูโพสต์ทั้งหมด
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Feed List (แยกตาม Role)
                VStack(spacing: 15) {
                    if viewModel.userProfile.role == .employer {
                        // ผู้จ้างงานเห็นโพสต์หางาน (Job Seeker Posts)
                        ForEach(mockJobSeekerPosts) { post in
                            JobSeekerPostSummaryCard(post: post)
                        }
                    } else {
                        // ผู้หางานเห็นโพสต์จ้างงาน (Employer Posts)
                        ForEach(mockEmployerPosts) { post in
                            EmployerPostSummaryCard(post: post) // <<< ใช้ Card ของ Employer
                        }
                    }
                }
                .padding()
            }
        }
    }
}
