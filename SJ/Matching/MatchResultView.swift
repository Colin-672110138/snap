import SwiftUI

struct MatchResultView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var matchedPostIDs: [String] = []
    
    // ดึงโพสต์ที่ match จาก viewModel โดยใช้ postID
    var matchedPosts: [JobSeekerPostCardModel] {
        matchedPostIDs.compactMap { postID in
            viewModel.jobSeekerFeedPosts.first { $0.postID == postID }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {

                // ⭐ รายชื่อผลแมตช์
                if matchedPosts.isEmpty {
                    Text("ไม่มีคนหางานในจังหวัดเดียวกับคุณตอนนี้")
                        .foregroundColor(.secondary)
                        .padding(.top, 20)
                } else {
                    ForEach(matchedPosts) { post in
                        JobSeekerPostSummaryCard(
                            viewModel: viewModel,
                            post: post
                        ) { post in
                            viewModel.toggleFavorite(for: post)
                        }
                    }
                }

                // ⭐ ปุ่มจับคู่ใหม่ (อยู่ล่างสุด)
                Button(action: refreshMatching) {
                    Text("จับคู่ใหม่")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(12)
                        .font(.headline)
                }
                .padding(.top, 10)
            }
            .padding()
        }
        .navigationTitle("ผลการจับคู่")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            refreshMatching()   // โหลดรอบแรก
        }
    }
    
    // MARK: - ฟังก์ชันสุ่มคนใหม่
    func refreshMatching() {
        let province = viewModel.userProfile.province
        let matched = viewModel.getRandomMatchedJobSeekers(forProvince: province)
        matchedPostIDs = matched.map { $0.postID }
    }
}
