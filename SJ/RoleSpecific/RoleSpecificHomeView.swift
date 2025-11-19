import SwiftUI

struct RoleSpecificHomeView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var searchText: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MARK: - Header
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
                    
                    Button(action: {}) {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                // MARK: - Search
                HStack {
                    TextField(
                        viewModel.userProfile.role == .employer
                        ? "ค้นหา..."
                        : "ค้นหา...",
                        text: $searchText
                    )
                    .padding(.leading, 10)
                    
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }

                .padding(.vertical, 5)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                // MARK: - Ads
                AdCarouselView()
                    .frame(height: 150)
                    .padding(.bottom, 20)
                
                // MARK: - Section Header
                HStack {
                    Text(viewModel.userProfile.role == .employer ? "โพสต์หางาน" : "โพสต์จ้างงาน")
                        .font(.title3)
                        .bold()
                    
                    Spacer()
                    
                    if viewModel.userProfile.role == .employer {
                        NavigationLink(destination: AllJobSeekerPostsView(
                            viewModel: viewModel,
                            posts: filteredJobSeekerFeed
                        )) {
                            Text("ทั้งหมด")
                                .font(.subheadline)
                        }
                    } else {
                        NavigationLink(destination: AllEmployerPostsView(
                            viewModel: viewModel,          // ✅ ส่ง viewModel เข้าไป
                            posts: filteredEmployerFeed
                        )) {
                            Text("ทั้งหมด")
                                .font(.subheadline)
                        }
                    }


                }
                .padding(.horizontal)
                
                // MARK: - Feed
                VStack(spacing: 15) {
                    if viewModel.userProfile.role == .employer {
                        ForEach(filteredJobSeekerFeed) { post in
                            JobSeekerPostSummaryCard(viewModel: viewModel, post: post) { post in
                                    viewModel.toggleFavorite(for: post)
                                }
                        }
                    } else {
                        ForEach(filteredEmployerFeed) { post in
                            EmployerPostSummaryCard(viewModel: viewModel, post: post) { post in
                                viewModel.toggleFavorite(for: post)
                            }

                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            viewModel.loadMockPostsIfNeeded()
        }
    }
    
    // MARK: - Filter ด้วย searchText: จังหวัด หรือ ค่าแรง/วัน

    var filteredJobSeekerFeed: [JobSeekerPostCardModel] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return viewModel.jobSeekerFeedPosts }
        
        // ถ้าพิมพ์เป็นตัวเลข → ให้มองว่าเป็น "ค่าแรง/วัน"
        if let wage = Int(text) {
            return viewModel.jobSeekerFeedPosts.filter { post in
                extractWage(from: post.hourlyRate) == wage
            }
        } else {
            // ไม่ใช่ตัวเลข → ให้ค้นหาจากจังหวัด + หัวข้อ
            return viewModel.jobSeekerFeedPosts.filter { post in
                post.province.localizedCaseInsensitiveContains(text) ||
                post.title.localizedCaseInsensitiveContains(text)
            }
        }
    }

    var filteredEmployerFeed: [EmployerPostCardModel] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if text.isEmpty { return viewModel.employerFeedPosts }
        
        if let wage = Int(text) {
            return viewModel.employerFeedPosts.filter { post in
                extractWage(from: post.letCompensation) == wage
            }
        } else {
            return viewModel.employerFeedPosts.filter { post in
                post.province.localizedCaseInsensitiveContains(text) ||
                post.title.localizedCaseInsensitiveContains(text)
            }
        }
    }

}

// MARK: - All Posts

struct AllJobSeekerPostsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let posts: [JobSeekerPostCardModel]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(posts) { post in
                    JobSeekerPostSummaryCard(viewModel: viewModel, post: post) { _ in }
                }
            }
            .padding()
        }
        .navigationTitle("โพสต์หางานทั้งหมด")
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct AllEmployerPostsView: View {
    @ObservedObject var viewModel: OnboardingViewModel   // ✅ เพิ่มบรรทัดนี้
    let posts: [EmployerPostCardModel]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(posts) { post in
                    EmployerPostSummaryCard(viewModel: viewModel, post: post) { post in
                        viewModel.toggleFavorite(for: post)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("โพสต์จ้างงานทั้งหมด")
        .navigationBarTitleDisplayMode(.inline)
    }
}

func extractWage(from text: String) -> Int {
    let digits = text.prefix { $0.isNumber }
    return Int(digits) ?? 0
}
