//
//  JobSeekerProfileView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/RoleSpecific/JobSeekerProfileView.swift

import SwiftUI

struct JobSeekerProfileView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // ใช้ @State สำหรับข้อมูลในฟอร์ม
    @State private var positionInput: String = ""
    @State private var hasExperience: Bool = false
    @State private var experienceDescription: String = ""
    
    @State private var isProfileCompleted = false
    
    // ตรวจสอบความพร้อมในการบันทึก
    var isReadyToProceed: Bool {
        // ต้องกรอกตำแหน่งที่สนใจ และถ้าเคยมีประสบการณ์ต้องกรอกคำอธิบายด้วย
        return !positionInput.isEmpty && (!hasExperience || !experienceDescription.isEmpty)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("ข้อมูลประสบการณ์ (7/8 - ผู้หางาน)")
                .font(.title2)
                .bold()
            
            Text("กรุณาระบุตำแหน่งและประสบการณ์ของคุณ เพื่อให้ผู้จ้างงานพิจารณา")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Form {
                // MARK: - ตำแหน่งที่สนใจ
                Section(header: Text("ตำแหน่งที่สนใจ")) {
                    TextField("เช่น เก็บเกี่ยว, คัดแยก, ขนส่ง", text: $positionInput)
                }
                
                // MARK: - ประสบการณ์
                Section(header: Text("ประสบการณ์ทำงาน")) {
                    Toggle("เคยมีประสบการณ์เก็บลำไยไหม?", isOn: $hasExperience)
                    
                    if hasExperience {
                        TextEditor(text: $experienceDescription)
                            .frame(height: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 0.5)
                            )
                            .autocorrectionDisabled()
                    }
                }
            }
            
            // ปุ่มเสร็จสิ้น
            Button("ดำเนินการต่อ") {
                viewModel.saveJobSeekerProfile(
                    position: positionInput,
                    hasExp: hasExperience,
                    expDesc: experienceDescription
                )
                isProfileCompleted = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isReadyToProceed ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isReadyToProceed)
        }
        .padding([.horizontal, .bottom])
        //.navigationTitle("ข้อมูลผู้หางาน")
        // ซ่อนปุ่มย้อนกลับเนื่องจากเป็นหน้าสุดท้ายของ Flow Onboarding
        //.navigationBarBackButtonHidden(true)
        
        // MARK: - การนำทางเมื่อเสร็จสิ้น
        .navigationDestination(isPresented: $isProfileCompleted) {
            VerificationSummaryView(viewModel: viewModel) // <-- ชี้ไปหน้า 8
        }
    }
}

#Preview {
    JobSeekerProfileView(viewModel: OnboardingViewModel())
            .environment(\.colorScheme, .light)
}
