import SwiftUI

struct MatchResultView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var matchedPosts: [JobSeekerPostCardModel] = []
    
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
                        matchRow(post)
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
        matchedPosts = viewModel.getRandomMatchedJobSeekers(forProvince: province)
    }
    
    // MARK: - แถวโชว์ข้อมูลผลแมตช์
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
