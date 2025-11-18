//
//  JobSeekerPostStep2View.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//

// Views/Posting/JobSeekerPostStep2View.swift

import SwiftUI

struct JobSeekerPostStep2View: View {
    @Binding var postData: JobSeekerPostData
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingSuccessAlert = false
    
    var isStep2Ready: Bool {
        return !postData.province.isEmpty && !postData.compensation.isEmpty
    }
    
    var body: some View {
        VStack {
            Text("โพสต์หางาน (2/2)")
                .font(.title2).bold()
            
            Form {
                Section(header: Text("ข้อมูลเพิ่มเติม")) {
                    TextField("1. ระบุจังหวัดที่จะให้ทำงาน", text: $postData.province)
                    TextField("2. ระบุค่าตอบแทน", text: $postData.compensation)
                }
            }
            
            Spacer()
            
            Button("สร้างโพสต์") {
                // Logic: บันทึก postData และนำทางกลับไปยัง Tab Home
                print("--- โพสต์ของผู้หางานถูกสร้างแล้ว ---")
                showingSuccessAlert = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isStep2Ready ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(!isStep2Ready)
            .padding(.horizontal)
        }
        .navigationTitle("")
        // ปุ่มย้อนกลับ (Back Button) ทำงานโดยอัตโนมัติ
        // MARK: - Alert ยืนยันการโพสต์สำเร็จ
        .alert("โพสต์สำเร็จ!", isPresented: $showingSuccessAlert) {
                    Button("ตกลง", role: .cancel) {
                        // 1. เปลี่ยนไป Tab Home (Index 0)
                        viewModel.currentTabIndex = 0
                        // 1. รีเซ็ตข้อมูลที่กรอกทั้งหมด
                        postData = JobSeekerPostData()
                        
                        // 2. ปิดหน้าจอ Navigation Stack
                        dismiss()
                    }
                } message: {
                    Text("โพสต์หางานของคุณถูกสร้างเรียบร้อยแล้ว")
                }
    }
}
