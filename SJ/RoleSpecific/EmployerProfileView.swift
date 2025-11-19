//
//  EmployerProfileView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/RoleSpecific/EmployerProfileView.swift

import SwiftUI

struct EmployerProfileView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // ใช้ @State สำหรับข้อมูลในฟอร์ม
    @State private var raiInput: String = ""
    @State private var nganInput: String = ""
    @State private var sqMeterInput: String = ""
    @State private var treeCountInput: String = ""
    
    @State private var isProfileCompleted = false
    
    // ตรวจสอบความพร้อมในการบันทึก: ต้องกรอกอย่างน้อยหนึ่งช่องข้อมูลพื้นที่ + จำนวนต้น
    var isReadyToProceed: Bool {
        let isAreaFilled = !raiInput.isEmpty || !nganInput.isEmpty || !sqMeterInput.isEmpty
        let isTreeCountFilled = !treeCountInput.isEmpty
        return isAreaFilled && isTreeCountFilled
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("ข้อมูลไร่ลำไย (7/8 - ผู้จ้างงาน)")
                .font(.title2)
                .bold()
            
            Text("กรุณาระบุขนาดพื้นที่และจำนวนต้นลำไย เพื่อให้ผู้หางานประเมินงานได้")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Form {
                Section(header: Text("ขนาดพื้นที่ (เลือกกรอกอย่างน้อย 1 หน่วย)")) {
                    
                    AreaInputRow(label: "ไร่", value: $raiInput)
                    AreaInputRow(label: "งาน", value: $nganInput)
                    AreaInputRow(label: "ตารางเมตร", value: $sqMeterInput)
                }
                
                Section(header: Text("จำนวนต้น")) {
                    TextField("จำนวนต้นลำไยทั้งหมด", text: $treeCountInput)
                        .keyboardType(.numberPad)
                }
            }
            
            // ปุ่มเสร็จสิ้น
            Button("ดำเนินการต่อ") {
                // แปลง String เป็น Int
                let rai = Int(raiInput)
                let ngan = Int(nganInput)
                let sqMeters = Int(sqMeterInput)
                let treeCount = Int(treeCountInput)
                
                viewModel.saveEmployerProfile(rai: rai, ngan: ngan, sqMeters: sqMeters, treeCount: treeCount)
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
        //.navigationTitle("ข้อมูลผู้จ้างงาน")
        // ซ่อนปุ่มย้อนกลับเนื่องจากเป็นหน้าสุดท้ายของ Flow Onboarding
        //.navigationBarBackButtonHidden(true)
        
        // MARK: - การนำทางเมื่อเสร็จสิ้น
        .navigationDestination(isPresented: $isProfileCompleted) {
            VerificationSummaryView(viewModel: viewModel) // <-- ชี้ไปหน้า 8
        }
    }
}

// MARK: - Component สำหรับช่องกรอกข้อมูลพื้นที่
struct AreaInputRow: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.gray)
            TextField("จำนวน \(label)", text: $value)
                .keyboardType(.numberPad)
        }
    }
}
