//
//  SelfieWithIDView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/Onboarding/SelfieWithIDView.swift

import SwiftUI
import PhotosUI
import UIKit

struct SelfieWithIDView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var goToNextStep = false
    @State private var selfieItem: PhotosPickerItem?
    @State private var selfieImage: Image?
    
    // NEW: สถานะสำหรับ Checkbox นโยบาย
    @State private var hasAgreedToPolicy: Bool = false

    var isReadyToProceed: Bool {
        // ต้องอัปโหลดรูปภาพ (viewModel.selfieWithIDImage != nil) และต้องยอมรับนโยบาย
        return viewModel.selfieWithIDImage != nil && hasAgreedToPolicy
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("ยืนยันตัวตน (5/8)")
                .font(.title2)
                .bold()
            
            Text("ขั้นตอนสุดท้าย! กรุณาถ่ายรูปใบหน้าคู่กับบัตรประชาชน เพื่อยืนยันว่าเป็นบุคคลเดียวกัน")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            // MARK: - อัปโหลดรูปเซลฟี่ (PhotosPicker)
            PhotosPicker(selection: $selfieItem, matching: .images) {
                VStack(spacing: 8) {
                    if let image = selfieImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(8)
                    } else {
                        VStack {
                            Image(systemName: "person.badge.key.fill")
                                .font(.largeTitle)
                                .foregroundColor(.orange)
                            Text("แตะเพื่ออัปโหลดรูปถ่ายคู่บัตร")
                                .foregroundColor(.primary)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 250)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )
            }
            
            // MARK: - Logic บันทึกรูปภาพ (UIImage)
            .onChange(of: selfieItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        
                        selfieImage = Image(uiImage: uiImage)
                        self.viewModel.selfieWithIDImage = uiImage
                    }
                }
            }
            Spacer()

            // 🆕 ย้ายส่วน Checkbox มาตรงนี้ (เหนือปุ่มดำเนินการต่อ)
                    PolicyCheckboxView(hasAgreed: $hasAgreedToPolicy)
                        .padding(.horizontal, 5)
            
                    // MARK: - ปุ่มดำเนินการต่อ
                    Button("ดำเนินการต่อ") {
                        if isReadyToProceed {
                            goToNextStep = true
                        }
                    }
            .frame(maxWidth: .infinity)
            .padding()
            // ปุ่มจะเปิดใช้งานเมื่อ isReadyToProceed เป็น true (คือรูปภาพถูกอัปโหลดและยอมรับนโยบายแล้ว)
            .background(isReadyToProceed ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isReadyToProceed)
        }
        .padding()
        
        // MARK: - การนำทางไปหน้า 6
        .navigationDestination(isPresented: $goToNextStep) {
            AccountReviewView(viewModel: viewModel)
        }
    }
}

// MARK: - Component ใหม่: Policy Checkbox
struct PolicyCheckboxView: View {
    @Binding var hasAgreed: Bool
    
    var body: some View {
        HStack {
            // Checkbox (ใช้ Button สำหรับการควบคุม)
            Button(action: {
                hasAgreed.toggle()
            }) {
                Image(systemName: hasAgreed ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(hasAgreed ? .green : .gray) // เปลี่ยนสีเมื่อถูกเลือก
            }
            
            // ข้อความ "นโยบายความเป็นส่วนตัว" + ลิงก์ "เพิ่มเติม"
            Text("นโยบายความเป็นส่วนตัว")
                .foregroundColor(.primary)
            
            Button("เพิ่มเติม") {
                // TODO: โค้ดสำหรับเปิดหน้าเว็บ/Sheet แสดงนโยบาย
                print("เปิดหน้า นโยบายความเป็นส่วนตัว")
            }
            .foregroundColor(.blue)
            
            Spacer()
        }
    }
}


#Preview {
    SelfieWithIDView(viewModel: OnboardingViewModel())
            .environment(\.colorScheme, .light)
}
