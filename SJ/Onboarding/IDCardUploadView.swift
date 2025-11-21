// Views/Onboarding/IDCardUploadView.swift

import SwiftUI
import PhotosUI
import UIKit // *** ต้อง import UIKit สำหรับ UIImage ***

struct IDCardUploadView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var goToNextStep = false
    
    // สถานะสำหรับ PhotosPicker (ใช้ Item)
    @State private var frontPhotoItem: PhotosPickerItem?
    @State private var backPhotoItem: PhotosPickerItem?

    // สถานะสำหรับแสดงรูปภาพที่เลือก (SwiftUI.Image)
    @State private var frontImage: Image?
    @State private var backImage: Image?
    
    // สถานะสำหรับ error message
    @State private var frontError: String?
    
    var isReadyToProceed: Bool {
        // ตรวจสอบจาก UIImage ใน ViewModel เพื่อความแน่ใจ
        return viewModel.idCardFrontImage != nil && viewModel.idCardBackImage != nil
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("ยืนยันตัวตน (4/8)") // อัปเดตเลขหน้า
                .font(.title2)
                .bold()
            
            Text("กรุณาอัปโหลดรูปบัตรประชาชนด้านหน้าและด้านหลัง")
                .font(.subheadline)

            // MARK: - อัปโหลดรูปด้านหน้า
            UploadArea(title: "1. ด้านหน้าบัตรประชาชน", image: $frontImage, item: $frontPhotoItem)
                .onChange(of: frontPhotoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {

                            // ผ่านการตรวจสอบ → เซตรูป
                            self.viewModel.idCardFrontImage = uiImage
                            self.frontImage = Image(uiImage: uiImage)
                        }
                    }
                }

            if let error = frontError {
                    Text(error)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
            // MARK: - อัปโหลดรูปด้านหลัง
            UploadArea(title: "2. ด้านหลังบัตรประชาชน", image: $backImage, item: $backPhotoItem)
            .onChange(of: backPhotoItem) { newItem in
                Task {
                    // โหลดและบันทึก UIImage
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        
                        self.viewModel.idCardBackImage = uiImage // <<< บันทึก UIImage
                        self.backImage = Image(uiImage: uiImage)  // แสดงผล
                    }
                }
            }
            
            Spacer()
            
            // ปุ่มดำเนินการต่อ
            Button("ดำเนินการต่อ") {
                if isReadyToProceed {
                    goToNextStep = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isReadyToProceed ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isReadyToProceed)
        }
        .padding()
        //.navigationTitle("อัปโหลดบัตร")
        
        // MARK: - การนำทางไปหน้า 5
        .navigationDestination(isPresented: $goToNextStep) {
            SelfieWithIDView(viewModel: viewModel)
        }
    }
}

// MARK: - Component: พื้นที่สำหรับ PhotosPicker (เพื่อความเป็นระเบียบ)
struct UploadArea: View {
    let title: String
    @Binding var image: Image?
    @Binding var item: PhotosPickerItem?
    
    var body: some View {
        PhotosPicker(selection: $item, matching: .images) {
            VStack(spacing: 8) {
                if let image = image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                        .cornerRadius(8)
                } else {
                    Image(systemName: "camera.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                    Text(title)
                        .foregroundColor(.primary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 150)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}
