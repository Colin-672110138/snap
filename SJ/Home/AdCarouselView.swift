//
//  AdCarouselView.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Views/Component/AdCarouselView.swift (New File)

import SwiftUI
import UIKit

struct AdCarouselView: View {
    // รูปโฆษณา - เพิ่มรูปใน Assets.xcassets และอ้างอิงชื่อที่นี่
    // ตัวอย่าง: ["Ad1", "Ad2", "Ad3"]
    // ถ้ายังไม่มีรูป ให้ใช้ placeholder
    var adImages: [UIImage] {
        let adNames = ["Ad1", "Ad2", "Ad3"] // เปลี่ยนชื่อตามรูปที่เพิ่มใน Assets.xcassets
        
        return adNames.map { name in
            if let image = UIImage(named: name) {
                return image
            } else {
                // Placeholder ถ้ายังไม่มีรูป
                return UIImage(systemName: "photo") ?? UIImage()
            }
        }
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(Array(adImages.enumerated()), id: \.offset) { index, image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 150)
                        .clipped()
                        .cornerRadius(12)
                }
            }
            .padding(.horizontal)
        }
    }
}
