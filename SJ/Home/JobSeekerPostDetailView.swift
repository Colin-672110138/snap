//
//  JobSeekerPostDetailView.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Views/Posting/JobSeekerPostDetailView.swift (New File)

import SwiftUI

struct JobSeekerPostDetailView: View {
    let post: JobSeekerPostCardModel
    
    // Mock Review Data
    let mockReviews: [ReviewModel] = [
        ReviewModel(reviewerName: "สวนลุงสมบัติ", rating: 5),
        ReviewModel(reviewerName: "สวน A", rating: 4),
        ReviewModel(reviewerName: "สวน B", rating: 5)
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
                    
                    Text("รายละเอียด")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    
                    // --- Header ---
                    HStack(alignment: .top) {
                        Image(uiImage: post.profileImage)
                            .resizable().frame(width: 40, height: 40).clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(post.userName).font(.headline)
                            Text(post.postTime).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text("\(post.hourlyRate)").font(.headline).foregroundColor(.green)
                    }
                    
                    Divider()
                    
                    // --- Body Details ---
                    VStack(alignment: .leading, spacing: 5) {
                        Text(post.title).font(.title2).bold()
                        DetailRow(label: "จังหวัด", value: post.province)
                        DetailRow(label: "คนงาน", value: "\(post.numberPeople) คน")
                        DetailRow(label: "เบอร์ติดต่อ", value: post.contactNumber)
                        DetailRow(label: "เริ่มงาน", value: post.startDate)
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
                
            } // End VStack
        } // End ScrollView
        .navigationTitle(post.title)
    }
}

// Component สำหรับแสดงรายละเอียดเป็นแถว
struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text("\(label):").bold().frame(width: 80, alignment: .leading)
            Text(value)
            Spacer()
        }
        .font(.subheadline)
    }
}

// Component สำหรับแสดงแถวรีวิว
struct ReviewRow: View {
    let review: ReviewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(review.reviewerName).bold()
                Spacer()
                // แสดงดาว
                HStack(spacing: 2) {
                    ForEach(0..<5) { index in
                        Image(systemName: index < review.rating ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                            .font(.caption)
                    }
                }
            }
            Divider()
        }
    }
}
