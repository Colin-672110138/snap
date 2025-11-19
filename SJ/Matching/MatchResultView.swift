//
//  MatchResultView.swift
//  SJ
//
//  Created by colin black on 19/11/2568 BE.
//

import SwiftUI

struct MatchResultView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var matchedPosts: [JobSeekerPostCardModel] {
        let province = viewModel.userProfile.province
        return viewModel.getMatchedJobSeekers(forProvince: province)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if matchedPosts.isEmpty {
                    Text("ไม่มีคนหางานในจังหวัดเดียวกับคุณตอนนี้")
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    ForEach(matchedPosts) { post in
                        matchRow(post)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("ผลการจับคู่")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    func matchRow(_ post: JobSeekerPostCardModel) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(post.title)
                .font(.headline)
            
            Text("จังหวัด: \(post.province)")
                .font(.subheadline)
            
            Text("คนงาน: \(post.numberPeople) คน")
                .font(.subheadline)
            
            Text("ค่าแรง: \(post.hourlyRate)")
                .font(.subheadline)
            
            Text("เบอร์ติดต่อ: \(post.contactNumber)")
                .font(.subheadline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}
