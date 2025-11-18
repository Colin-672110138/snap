//
//  EmployerPostSummaryCard.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Views/Component/EmployerPostSummaryCard.swift (New File)

import SwiftUI

struct EmployerPostSummaryCard: View {
    let post: EmployerPostCardModel
    @State private var isFavorite: Bool = false

    var body: some View {
        // ใช้ NavigationLink เพื่อนำไปสู่หน้า Detail View
        NavigationLink(destination: EmployerPostDetailView(post: post)) {
            VStack(alignment: .leading, spacing: 10) {
                // MARK: - Card Header (Profile Info, Rate, Favorite)
                HStack(alignment: .top) {
                    Image(uiImage: post.profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.farmName).font(.subheadline).bold()
                        Text(post.postTime).font(.caption).foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    // ราคาค่าแรง + ปุ่มรายการโปรด
                    VStack(alignment: .trailing) {
                        Text("\(post.letCompensation)") // 500/วัน
                            .font(.headline).foregroundColor(.green)
                        
                        // ปุ่มรายการโปรด
                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .foregroundColor(isFavorite ? .yellow : .gray)
                        }
                        .onAppear { self.isFavorite = post.isFavorite }
                    }
                }
                
                Divider()
                
                // MARK: - Card Body (Image, Title, Details)
                HStack(spacing: 15) {
                    // รูปภาพโพสต์
                    Image(uiImage: post.postImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .clipped()
                    
                    VStack(alignment: .leading) {
                        // หัวข้อ
                        Text(post.title).font(.headline).lineLimit(1)
                        
                        // รายละเอียด
                        Text("จังหวัด: \(post.province)").font(.caption)
                        Text("พื้นที่: \(post.areaSize) | สวัสดิการ: \(post.welfare)").font(.caption)
                        Text("เริ่มงาน: \(post.startDate)").font(.caption)
                    }
                }
                
                Divider()
                
                // MARK: - Card Footer (Rating)
                HStack {
                    // Rating Star
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(post.currentRating, specifier: "%.1f")").bold()
                    Text("(\(post.reviewCount) รีวิว)").font(.caption).foregroundColor(.secondary)
                }
                .padding(.bottom, 5)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
        .buttonStyle(.plain)
    }
}
