import SwiftUI

struct JobSeekerPostDetailView: View {
    let post: JobSeekerPostCardModel
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var showingRatingSheet = false
    
    // รีวิวจริงของโพสต์หางานนี้
    var reviews: [ReviewModel] {
        viewModel.jobSeekerReviewsByPostID[post.postID] ?? []
    }
    
    // ตรวจสอบว่าเป็นโพสต์ของตัวเองหรือไม่
    var isMyPost: Bool {
        viewModel.myJobSeekerPosts.contains { $0.postID == post.postID }
    }
    
    // ตรวจสอบว่าเคยให้คะแนนไปแล้วหรือยัง
    var hasAlreadyRated: Bool {
        let currentUserID = viewModel.userProfile.lineID
        return reviews.contains { $0.reviewerID == currentUserID }
    }
    
    // ตรวจสอบว่าสามารถให้คะแนนได้หรือไม่
    var canRate: Bool {
        !isMyPost && !hasAlreadyRated
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 1. รูปหลัก
                Image(uiImage: post.postImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .clipped()
                
                // 2. Card รายละเอียด
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("รายละเอียด")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 5)
                    
                    HStack(alignment: .top) {
                        Image(uiImage: post.profileImage)
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading) {
                            Text(post.userName).font(.headline)
                            Text(post.postTime).font(.caption).foregroundColor(.secondary)
                        }
                        Spacer()
                        Text(post.hourlyRate)
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    
                    Divider()
                    
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
                
                // 3. รีวิว/ให้คะแนน
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text("รีวิว/ให้คะแนน").font(.title3).bold()
                        Spacer()
                        if canRate {
                            Button("ให้คะแนน") {
                                showingRatingSheet = true
                            }
                        } else if isMyPost {
                            Text("ไม่สามารถให้คะแนนโพสต์ของตัวเองได้")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        } else if hasAlreadyRated {
                            Text("คุณได้ให้คะแนนแล้ว")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    if reviews.isEmpty {
                        Text("ยังไม่มีการให้คะแนน")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", post.currentRating))
                                .bold()
                            Text("จาก \(reviews.count) คน")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(reviews) { review in
                                HStack {
                                    HStack(spacing: 2) {
                                        ForEach(0..<review.rating, id: \.self) { _ in
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                                .font(.caption)
                                        }
                                    }
                                    Spacer()
                                    Text(review.reviewerName)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.top, 6)
                    }
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(post.title)
        .sheet(isPresented: $showingRatingSheet) {
            ReviewInputSheet(title: "ให้คะแนนผู้หางาน") { rating in
                viewModel.addReview(forJobSeekerPost: post, rating: rating)
            }
        }
    }
    
    struct DetailRow: View {
        let label: String
        let value: String

        var body: some View {
            HStack {
                Text("\(label):")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                Text(value)
                Spacer()
            }
            .font(.subheadline)
        }
    }
}
