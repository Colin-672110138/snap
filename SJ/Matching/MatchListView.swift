//
//  MatchingManager.swift
//  SJ
//
//  Created by colin black on 19/11/2568 BE.
//

import SwiftUI

struct MatchView: View {
    @ObservedObject var onboardingVM: OnboardingViewModel
    let allPosts: [JobSeekerPostCardModel]

    var matched: [JobSeekerPostCardModel] {
        onboardingVM.matchedPosts(from: allPosts)
    }

    var body: some View {
        VStack(alignment: .leading) {

            Text("งานที่เหมาะกับคุณ")
                .font(.title2)
                .bold()
                .padding()

            if matched.isEmpty {
                Text("ไม่พบงานในจังหวัดของคุณ")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(matched, id: \.postID) { post in
                    VStack(alignment: .leading, spacing: 6) {

                        Text(post.title)
                            .font(.headline)

                        Text("จังหวัด: \(post.province)")
                        Text("จำนวน: \(post.numberPeople) คน")
                        Text("ค่าแรง: \(post.hourlyRate)")
                        Text("ติดต่อ: \(post.contactNumber)")
                        Text("เริ่มงาน: \(post.startDate)")
                    }
                    .padding(.vertical, 6)
                }
                .listStyle(.plain)
            }
        }
    }
}


struct MatchPostRow: View {
    let post: JobSeekerPostCardModel

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {

            Text(post.title)
                .font(.headline)

            Text("จังหวัด: \(post.province)")
                .foregroundColor(.gray)

            Text("จำนวนที่ต้องการ: \(post.numberPeople) คน")
                .foregroundColor(.gray)

            Text("ค่าแรง: \(post.hourlyRate)")
                .foregroundColor(.blue)

            Text("ติดต่อ: \(post.contactNumber)")
                .foregroundColor(.gray)

            Text("วันที่เริ่ม: \(post.startDate)")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
