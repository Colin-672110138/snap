import SwiftUI

struct StarRatingPicker: View {
    @Binding var rating: Int
    let max: Int = 5
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(1...max, id: \.self) { i in
                Image(systemName: i <= rating ? "star.fill" : "star")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.yellow)
                    .onTapGesture { rating = i }
            }
        }
    }
}
