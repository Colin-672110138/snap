import SwiftUI

struct ReviewInputSheet: View {
    @Environment(\.dismiss) var dismiss
    
    let title: String
    let onSubmit: (Int) -> Void
    
    @State private var rating: Int = 5
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Text(title)
                    .font(.title3)
                    .bold()
                
                StarRatingPicker(rating: $rating)
                
                Spacer()
            }
            .padding()
            .navigationTitle("ให้คะแนน")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("ยกเลิก") { dismiss() }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("ส่ง") {
                        onSubmit(rating)
                        dismiss()
                    }
                }
            }
        }
    }
}
