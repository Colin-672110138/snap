// Views/Profile/FavoritesView.swift

import SwiftUI

struct FavoritesView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                
                if viewModel.userProfile.role == .employer {
                    
                    // ผู้จ้างงาน → Favorite ของโพสต์หางาน
                    if viewModel.favoriteJobSeekerPosts.isEmpty {
                        Text("ยังไม่มีโพสต์ที่คุณกดถูกใจ")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(viewModel.favoriteJobSeekerPosts) { post in
                            JobSeekerPostSummaryCard(viewModel: viewModel, post: post) { post in
                                viewModel.toggleFavorite(for: post)
                            }
                        }
                    }
                    
                } else {
                    
                    // ผู้หางาน → Favorite ของโพสต์จ้างงาน
                    if viewModel.favoriteEmployerPosts.isEmpty {
                        Text("ยังไม่มีโพสต์ที่คุณกดถูกใจ")
                            .foregroundColor(.secondary)
                            .padding()
                    } else {
                        ForEach(viewModel.favoriteEmployerPosts) { post in
                            
                            // ✅ ต้องส่ง viewModel เข้าไปด้วย
                            EmployerPostSummaryCard(
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
        .navigationTitle("รายการโปรด")
    }
}
