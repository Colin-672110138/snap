//
//  EmployerPostDetailView.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Views/Posting/EmployerPostDetailView.swift (New File)

import SwiftUI

struct EmployerPostDetailView: View {
    let post: EmployerPostCardModel
    
    // Mock Review Data (ReviewModel ถูกสร้างไว้แล้วในขั้นตอนก่อนหน้า)
    let mockReviews: [ReviewModel] = [
        ReviewModel(reviewerName: "คุณสมหญิง", rating: 5),
        ReviewModel(reviewerName: "คุณ A", rating: 4),
        ReviewModel(reviewerName: "คุณ B", rating: 5)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - 1. รูปภาพหลัก (Center Top)
                Image(uiImage: post.postImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipped()
                
                // MARK: - 2. Card โพสต์ที่ไม่มีรูป (Details Card)
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("รายละเอียดงาน")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    
                    // --- Header ---
                    HStack(alignment: .top) {
                        Image(uiImage: post.profileImage)
                            .resizable().frame(width: 40, height: 40).clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(post.farmName).font(.headline)
                            Text(post.postTime).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(post.letCompensation)").font(.headline).foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    // --- Body Details ---
                    VStack(alignment: .leading, spacing: 5) {
                        Text(post.title).font(.title2).bold()
                        DetailRow(label: "จังหวัด", value: post.province)
                        DetailRow(label: "พื้นที่", value: post.areaSize)
                        DetailRow(label: "สวัสดิการ", value: post.welfare)
                        DetailRow(label: "เริ่มงาน", value: post.startDate)
                        DetailRow(label: "เบอร์ติดต่อ", value: post.contactNumber)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 3)
                .padding(.horizontal)
                
                // MARK: - 3. ส่วนรีวิว/ให้คะแนน
                VStack(alignment: .leading) {
                    HStack {
                        Text("รีวิว/ให้คะแนน").font(.title3).bold()
                        Spacer()
                        Button("รีวิว/ให้คะแนน") {
                            // TODO: Show Review Modal
                        }
                    }
                    .padding(.bottom, 10)
                    
                    // Feed รีวิว
                    VStack(spacing: 15) {
                        ForEach(mockReviews) { review in
                            ReviewRow(review: review)
                        }
                    }
                }
                .padding(.horizontal)
                
            }
        }
        .navigationTitle(post.title)
    }
}

// Note: DetailRow และ ReviewRow structs ถูกสร้างไว้ในขั้นตอนก่อนหน้า
// ReviewModel ถูกสร้างไว้แล้วในขั้นตอนก่อนหน้า
