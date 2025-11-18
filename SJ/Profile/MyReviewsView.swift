//
//  MyReviewsView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/Profile/MyReviewsView.swift

import SwiftUI

struct MyReviewsView: View {
    // Mock Data สำหรับรีวิว (ดาว)
    let mockReviews = [
        ("ลุงสมบัติ", 5),
        ("คุณบี", 4),
        ("anonymous", 5)
    ]
    
    var body: some View {
        List {
            ForEach(mockReviews, id: \.0) { (name, rating) in
                HStack {
                    VStack(alignment: .leading) {
                        Text(name).bold()
                        HStack {
                            // แสดงดาว
                            ForEach(0..<5) { index in
                                Image(systemName: index < rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("รีวิวของฉัน")
    }
}
