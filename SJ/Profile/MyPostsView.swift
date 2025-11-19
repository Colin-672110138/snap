// Views/Profile/MyPostsView.swift

import SwiftUI

struct MyPostsView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var postToDelete: String? = nil
    @State private var showingDeleteAlert = false
    
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
                            ZStack(alignment: .topTrailing) {
                                // ✅ ต้องส่ง viewModel เข้าไปด้วย
                                EmployerPostSummaryCard(
                                    viewModel: viewModel,
                                    post: post,
                                    showFavoriteButton: false
                                ) { post in
                                    viewModel.toggleFavorite(for: post)
                                }
                                
                                // ปุ่มลบ
                                Button(action: {
                                    postToDelete = post.postID
                                    showingDeleteAlert = true
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .buttonStyle(.plain)
                                .padding(8)
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
                            ZStack(alignment: .topTrailing) {
                                JobSeekerPostSummaryCard(
                                    viewModel: viewModel,
                                    post: post,
                                    showFavoriteButton: false
                                ) { post in
                                    viewModel.toggleFavorite(for: post)
                                }
                                
                                // ปุ่มลบ
                                Button(action: {
                                    postToDelete = post.postID
                                    showingDeleteAlert = true
                                }) {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                        .padding(8)
                                        .background(Color.white.opacity(0.9))
                                        .clipShape(Circle())
                                        .shadow(radius: 2)
                                }
                                .buttonStyle(.plain)
                                .padding(8)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("โพสต์ของฉัน")
        .alert("ยืนยันการลบโพสต์", isPresented: $showingDeleteAlert) {
            Button("ลบ", role: .destructive) {
                if let postID = postToDelete {
                    if viewModel.userProfile.role == .employer {
                        viewModel.deleteEmployerPost(postID: postID)
                    } else {
                        viewModel.deleteJobSeekerPost(postID: postID)
                    }
                    postToDelete = nil
                }
            }
            Button("ยกเลิก", role: .cancel) {
                postToDelete = nil
            }
        } message: {
            Text("คุณต้องการลบโพสต์นี้หรือไม่? การกระทำนี้ไม่สามารถยกเลิกได้")
        }
    }
}
