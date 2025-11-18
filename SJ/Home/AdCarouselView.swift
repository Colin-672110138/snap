//
//  AdCarouselView.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Views/Component/AdCarouselView.swift (New File)

import SwiftUI

struct AdCarouselView: View {
    // Mock Data สำหรับโฆษณา
    let mockAds = ["Ads 1: ปุ๋ยอินทรีย์ลดราคา", "Ads 2: บริการตัดแต่งกิ่ง", "Ads 3: ตลาดกลางผลผลิต"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(mockAds, id: \.self) { ad in
                    VStack {
                        Text(ad)
                            .font(.headline)
                            .padding()
                        Text("คลิกเพื่อดูรายละเอียด")
                            .font(.caption)
                    }
                    .frame(width: 300, height: 150)
                    .background(Color.yellow.opacity(0.3)) // สีโฆษณา
                    .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
    }
}
