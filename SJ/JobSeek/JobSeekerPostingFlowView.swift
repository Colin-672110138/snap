//
//  JobSeekerPostingFlowView.swift
//  SJ
//
//  Created by colin black on 13/11/2568 BE.
//
// Views/Posting/JobSeekerPostingFlowView.swift

import SwiftUI
import PhotosUI
import UIKit

// Model ชั่วคราวสำหรับเก็บข้อมูลโพสต์ของผู้หางาน
struct JobSeekerPostData {
    var image: UIImage?
    var title: String = "" // หัวข้อ (เช่น รับเก็บลำไย)
    var numberPeople: String = "" // จำนวนคน
    var startDate: Date = Date()
    var contactNumber: String = ""
    var province: String = ""
    var compensation: String = "" // ค่าตอบแทน
}

struct JobSeekerPostingFlowView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var postData = JobSeekerPostData()

    var isStep1Ready: Bool {
        return postData.image != nil && !postData.title.isEmpty && !postData.numberPeople.isEmpty && !postData.contactNumber.isEmpty
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("โพสต์หางาน (ผู้หางาน)")
                .font(.title2).bold()
            
            Form {
                // MARK: - 1. รูปภาพ
                Section(header: Text("รูปภาพประกอบ (แสดงในโพสต์)")) {
                    ImageUploader(image: $postData.image) // <<< ใช้ ImageUploader ที่แก้ไขแล้ว
                }
                
                // MARK: - 2-5. ข้อมูลหลัก
                Section(header: Text("รายละเอียดงาน")) {
                    TextField("2. ระบุหัวข้อ เช่น รับเก็บลำไย", text: $postData.title)
                    TextField("3. จำนวนคน", text: $postData.numberPeople)
                        .keyboardType(.numberPad)
                    
                    DatePicker("4. วันที่ต้องการเริ่มงาน", selection: $postData.startDate, displayedComponents: .date)
                        .environment(\.locale, Locale(identifier: "th_TH"))
                    
                    TextField("5. เบอร์ติดต่อ", text: $postData.contactNumber)
                        .keyboardType(.phonePad)
                }
            }
            
            Spacer()
            
            // MARK: - ปุ่มถัดไป (ไป Step 2)
            NavigationLink(destination: JobSeekerPostStep2View(postData: $postData, viewModel: viewModel)) {
                Text("ถัดไป")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isStep1Ready ? Color.green : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(!isStep1Ready)
            .padding(.horizontal)
        }
        .padding(.top)
        .navigationTitle("")
    }
}
