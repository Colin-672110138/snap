//
//  RoleSpecificPostingView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/RoleSpecific/RoleSpecificPostingView.swift

import SwiftUI
import PhotosUI
import UIKit // สำหรับ UIImage

struct RoleSpecificPostingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        // ใช้ NavigationStack ครอบเพื่อให้การนำทางภายใน Tab ทำงานได้
        NavigationStack {
            Group {
                if viewModel.userProfile.role == .employer {
                    // Flow ผู้จ้างงาน
                    EmployerPostingFlowView(viewModel: viewModel)
                } else {
                    // Flow ผู้หางาน
                    JobSeekerPostingFlowView(viewModel: viewModel)
                }
            }
        }
    }
}

// MARK: - Component ที่ใช้ร่วมกัน: ImageUploader
struct ImageUploader: View {
    // NEW: ทำให้ selectedImageItem เป็น @State ภายใน
    @State private var selectedImageItem: PhotosPickerItem?
    // Binding สำหรับ UIImage ที่จะถูกเก็บใน Model ของโพสต์
    @Binding var image: UIImage?
    
    var body: some View {
        PhotosPicker(selection: $selectedImageItem, matching: .images) {
            VStack {
                if let uiImage = image {
                    // แสดงรูปภาพที่ถูกเลือก
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .cornerRadius(8)
                } else {
                    // Placeholder เมื่อยังไม่มีรูป
                    Image(systemName: "photo.badge.plus")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("แตะเพื่อเพิ่มรูปภาพ")
                }
            }
            .frame(maxWidth: .infinity, minHeight: 100)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        // Logic สำหรับโหลดรูปภาพเมื่อมีการเลือกใหม่
        .onChange(of: selectedImageItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    image = uiImage // บันทึก UIImage ลงใน Model ผ่าน Binding
                }
            }
        }
    }
}
