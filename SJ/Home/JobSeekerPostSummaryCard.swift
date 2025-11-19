import SwiftUI

struct JobSeekerPostSummaryCard: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let post: JobSeekerPostCardModel
    let onToggleFavorite: (JobSeekerPostCardModel) -> Void
    var showFavoriteButton: Bool = true  // กำหนดค่า default เป็น true

    var body: some View {
        NavigationLink(destination: JobSeekerPostDetailView(post: post, viewModel: viewModel)) {
            VStack(alignment: .leading, spacing: 10) {
                // Header
                HStack(alignment: .top) {
                    Image(uiImage: post.profileImage)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(post.userName).font(.subheadline).bold()
                        Text(post.postTime).font(.caption).foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(post.hourlyRate)
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
                
                // Body
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
                        Text("คนงาน: \(post.numberPeople) คน | ติดต่อ: \(post.contactNumber)").font(.caption)
                        Text("เริ่มงาน: \(post.startDate)").font(.caption)
                    }
                }
                
                Divider()
                
                // Rating
                HStack {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(post.currentRating, specifier: "%.1f")").bold()
                    Text("(\(post.reviewCount) จำนวนคน)")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
