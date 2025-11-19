import SwiftUI

struct MatchingButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "bolt.fill")        // ⚡ เปลี่ยนเป็นสายฟ้า
                .font(.system(size: 24))
                .foregroundColor(.white)
                .padding(20)
                .background(Color.green)
                .clipShape(Circle())
                .shadow(radius: 5)
        }
    }
}
