import Foundation

struct ReviewModel: Identifiable {
    let id = UUID()
    
    let reviewerID: String        // lineID ของคนรีวิว
    let reviewerName: String      // ชื่อผู้รีวิว
    let rating: Int               // จำนวนดาว (1–5)
    let createdAt: Date           // เวลารีวิว
}
