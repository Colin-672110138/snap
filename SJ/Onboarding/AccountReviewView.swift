//
//  AccountReviewView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/Onboarding/AccountReviewView.swift

// Views/Onboarding/AccountReviewView.swift

// Views/Onboarding/AccountReviewView.swift

import SwiftUI

struct AccountReviewView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var goToNextStep = false
    @State private var phoneNumber: String
    @State private var currentAddress: String
    @State private var isSameAddressChecked: Bool
    
    init(viewModel: OnboardingViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        
        self._phoneNumber = State(initialValue: viewModel.userProfile.phoneNumber)
        self._currentAddress = State(initialValue: viewModel.userProfile.currentAddress)
        self._isSameAddressChecked = State(initialValue: viewModel.isCurrentAddressSameAsIDCard)
    }

    var body: some View {
        VStack(spacing: 20) {
            Text("ตรวจสอบข้อมูลบัญชี (6/8)")
                .font(.title2)
                .bold()
            
            Text("กรุณาตรวจสอบและแก้ไขข้อมูลที่อ่านจากบัตรประชาชนให้ถูกต้อง")
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            // <<< ลบ HSTACK ที่มี PolicyToggle ด้านบนออกไป >>>
            
            Form {
                // ส่วนข้อมูลที่มาจาก OCR
                Section(header: Text("ข้อมูลที่อ่านจากบัตรประชาชน")) {
                    InfoRow(label: "เลขบัตรประชาชน", value: $viewModel.ocrData.idCardNumber)
                    InfoRow(label: "ชื่อ-นามสกุล", value: .constant("\(viewModel.ocrData.title) \(viewModel.ocrData.firstName) \(viewModel.ocrData.lastName)"))
                    InfoRow(label: "วัน/เดือน/ปีเกิด", value: $viewModel.ocrData.dateOfBirth)
                    InfoRow(label: "ที่อยู่ตามบัตร", value: $viewModel.ocrData.address)
                }
                
                // MARK: - ข้อมูลติดต่อและที่อยู่ปัจจุบัน (ย้าย Checkbox เข้ามา)
                Section(header: Text("ข้อมูลติดต่อและที่อยู่ปัจจุบัน")) {
                    
                    // 1. เบอร์โทรศัพท์
                    HStack {
                            Text("เบอร์โทรติดต่อ") // <<< เพิ่ม Label นำหน้า
                                .foregroundColor(.gray)
                                .frame(width: 120, alignment: .leading) // จัดความกว้างให้ตรงกับ InfoRow
                            
                            TextField("กรอกเบอร์โทรศัพท์ (จำเป็น)", text: $phoneNumber)
                                .keyboardType(.phonePad)
                        }
                        
                    // 2. ที่อยู่ปัจจุบัน
                    HStack {
                            Text("ที่อยู่ปัจจุบัน")
                            .foregroundColor(.gray)
                            .frame(width: 120, alignment: .leading) // จัดความกว้างให้เท่ากับ InfoRow
                                            
                            TextField("กรุณากรอกที่อยู่", text: $currentAddress) // ใช้ TextField แทน TextEditor
                            .disabled(isSameAddressChecked) // ปิดถ้าใช้ตามบัตร
                            // ลบ background ใน TextField ออก เนื่องจาก Form จะจัดการ Background ให้อัตโนมัติเมื่อ disabled
                                        }
                    
                    // MARK: - Checkbox 'ใช้ที่อยู่ตามบัตร' (ตำแหน่งใหม่)
                    PolicyToggle(
                        isOn: $isSameAddressChecked,
                        ocrAddress: viewModel.ocrData.address,
                        currentAddress: $currentAddress
                    )
                    // เพิ่ม padding ด้านบนเพื่อให้ไม่ติด TextEditor เกินไป
                    .padding(.top, 10)
                }
            }
            
            // ปุ่มดำเนินการต่อ
            Button("ดำเนินการต่อ") {
                viewModel.savePersonalInfo(phoneNumber: phoneNumber)
                viewModel.userProfile.currentAddress = currentAddress
                viewModel.isCurrentAddressSameAsIDCard = isSameAddressChecked
                goToNextStep = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(!phoneNumber.isEmpty ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(phoneNumber.isEmpty)
        }
        .onAppear {
            viewModel.performMockOCR()
            // Note: Logic การตั้งค่าเริ่มต้นสำหรับที่อยู่ปัจจุบันถูกจัดการใน init และ PolicyToggle
        }
        .padding([.horizontal, .bottom])
        
        // MARK: - การนำทางไปหน้า 7 (ขึ้นอยู่กับ Role)
        .navigationDestination(isPresented: $goToNextStep) {
            if viewModel.userProfile.role == .employer {
                EmployerProfileView(viewModel: viewModel)
            } else {
                JobSeekerProfileView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Component สำหรับแสดงข้อมูลที่สามารถแก้ไขได้
struct InfoRow: View {
    let label: String
    @Binding var value: String
    
    var body: some View {
        HStack {
            Text(label)
                .frame(width: 120, alignment: .leading)
                .foregroundColor(.gray)
            TextField("", text: $value)
        }
    }
}

// MARK: - Component ใหม่: Policy Toggle
struct PolicyToggle: View {
    @Binding var isOn: Bool
    let ocrAddress: String
    @Binding var currentAddress: String
    
    var body: some View {
        Button(action: {
            isOn.toggle()
            
            if isOn {
                currentAddress = ocrAddress
            } else {
                currentAddress = ""
            }
        }) {
            HStack {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(isOn ? .blue : .gray)
                Text("ใช้ที่อยู่ตามบัตรประชาชน")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                Spacer() // เพิ่ม Spacer เพื่อดัน Checkbox ไปทางซ้าย
            }
        }
    }
}
