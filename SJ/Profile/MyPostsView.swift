// Views/Profile/MyPostsView.swift

import SwiftUI

struct MyPostsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                
                if viewModel.userProfile.role == .employer {
                    
                    if viewModel.myEmployerPosts.isEmpty {
                        Text("คุณยังไม่ได้สร้างโพสต์จ้างงาน")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(viewModel.myEmployerPosts) { post in
                            
                            // ✅ ต้องส่ง viewModel เข้าไปด้วย
                            EmployerPostSummaryCard(
                                viewModel: viewModel,
                                post: post
                            ) { post in
                                viewModel.toggleFavorite(for: post)
                            }
                        }
                    }
                    
                } else {
                    
                    if viewModel.myJobSeekerPosts.isEmpty {
                        Text("คุณยังไม่ได้สร้างโพสต์หางาน")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(viewModel.myJobSeekerPosts) { post in
                            JobSeekerPostSummaryCard(
                                viewModel: viewModel,
                                post: post
                            ) { post in
                                viewModel.toggleFavorite(for: post)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("โพสต์ของฉัน")
    }
}
