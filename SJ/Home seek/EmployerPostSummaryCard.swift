// Views/Component/EmployerPostSummaryCard.swift

import SwiftUI

struct EmployerPostSummaryCard: View {
    @ObservedObject var viewModel: OnboardingViewModel   // ✅ เพิ่มบรรทัดนี้
    let post: EmployerPostCardModel
    let onToggleFavorite: (EmployerPostCardModel) -> Void
    var showFavoriteButton: Bool = true  // กำหนดค่า default เป็น true

    var body: some View {
        // ✅ ส่ง viewModel เข้าไปในหน้า Detail ด้วย
        NavigationLink(destination: EmployerPostDetailView(post: post, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 10) {
                // MARK: - Card Header
                HStack(alignment: .top) {
                    Image(uiImage: post.profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.farmName).font(.subheadline).bold()
                        Text(post.postTime).font(.caption).foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(post.letCompensation)")
                            .font(.headline)
                            .foregroundColor(.green)
                        
                        if showFavoriteButton {
                            Button(action: {
                                onToggleFavorite(post)
                            }) {
                                Image(systemName: post.isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(post.isFavorite ? .red : .gray)
                            }
                        }
                    }
                }
                
                Divider()
                
                // MARK: - Card Body
                HStack(spacing: 15) {
                    Image(uiImage: post.postImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                        .clipped()
                    
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text("จังหวัด: \(post.province)").font(.caption)
                        Text("พื้นที่: \(post.areaSize) | สวัสดิการ: \(post.welfare)").font(.caption)
                        Text("เริ่มงาน: \(post.startDate)").font(.caption)
                    }
                }
                
                Divider()
                
                // MARK: - Rating
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(post.currentRating, specifier: "%.1f")").bold()
                    Text("(\(post.reviewCount) รีวิว)").font(.caption).foregroundColor(.secondary)
                }
                .padding(.bottom, 5)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 3)
        }
        .buttonStyle(.plain)
    }
}
