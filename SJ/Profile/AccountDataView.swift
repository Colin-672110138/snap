//
//  AccountDataView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/Profile/AccountDataView.swift

// Views/Profile/AccountDataView.swift (แก้ไข)

// Views/Profile/AccountDataView.swift

import SwiftUI

struct AccountDataView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var localPhoneNumber: String
    @State private var localCurrentAddress: String
    
    @State private var isEditingEnabled: Bool = false
    @State private var showingEditConfirmation: Bool = false
    
    init(viewModel: OnboardingViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        self._localPhoneNumber = State(initialValue: viewModel.userProfile.phoneNumber)
        self._localCurrentAddress = State(initialValue: viewModel.userProfile.currentAddress)
    }
    
    var body: some View {
        VStack {
            Text("ข้อมูลบัญชีของคุณ")
                .font(.title)
                .padding(.bottom, 10)
            
            Form {
                // MARK: - ข้อมูลที่ได้จากการยืนยันตัวตน (ไม่สามารถแก้ไขได้)
                Section(header: Text("ข้อมูลที่ได้จากการยืนยันตัวตน (ไม่สามารถแก้ไขได้)")) {
                    ProfileInfoRow(label: "เลขบัตรประชาชน", value: viewModel.userProfile.idCardNumber)
                    ProfileInfoRow(label: "ชื่อ-นามสกุล", value: viewModel.userProfile.name)
                    ProfileInfoRow(label: "วันเดือนปีเกิด", value: viewModel.ocrData.dateOfBirth)
                    ProfileInfoRow(label: "ที่อยู่ตามบัตร", value: viewModel.ocrData.address)
                }
                
                // MARK: - ข้อมูลติดต่อ (แก้ไขได้ - ปรับปรุงสไตล์)
                Section(header: Text("ข้อมูลติดต่อ (แก้ไขได้)")) {
                    
                    // 1. เบอร์โทรศัพท์ (HStack มาตรฐาน)
                    HStack {
                        Text("เบอร์โทรศัพท์")
                            .foregroundColor(.secondary)
                            .frame(width: 120, alignment: .leading)
                        
                        TextField("เบอร์โทร", text: $localPhoneNumber)
                            .keyboardType(.phonePad)
                            .disabled(!isEditingEnabled)
                            .onChange(of: localPhoneNumber) { newValue in
                                if isEditingEnabled {
                                    viewModel.userProfile.phoneNumber = newValue
                                }
                            }
                    }
                    
                    
                    // 2. ที่อยู่ปัจจุบัน (ใช้ HStack + TextField แบบหลายบรรทัด) <<< แก้ไขแล้ว
                    HStack(alignment: .top) { // จัดเรียงให้ Label ชิดด้านบน
                        Text("ที่อยู่ปัจจุบัน")
                            .foregroundColor(.secondary)
                            .frame(width: 120, alignment: .leading)
                        
                        // ใช้ TextField พร้อม axis: .vertical เพื่อให้ดูเป็นแถว Form แต่รองรับหลายบรรทัด
                        TextField("กรอกที่อยู่ปัจจุบัน", text: $localCurrentAddress, axis: .vertical)
                            .lineLimit(2...5) // อนุญาตให้แสดงผล 2-5 บรรทัด
                            .disabled(!isEditingEnabled)
                            .onChange(of: localCurrentAddress) { newValue in
                                if isEditingEnabled {
                                    viewModel.userProfile.currentAddress = newValue
                                }
                            }
                    }
                }
            }
        }
        .navigationTitle("ข้อมูลบัญชีของคุณ")
        .navigationBarTitleDisplayMode(.inline)
        // ... (Toolbar และ Alert modifiers เหมือนเดิม)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditingEnabled ? "บันทึก" : "แก้ไข") {
                    if isEditingEnabled {
                        isEditingEnabled = false
                    } else {
                        showingEditConfirmation = true
                    }
                }
            }
        }
        .alert("แก้ไขข้อมูล", isPresented: $showingEditConfirmation) {
            Button("ต้องการแก้ไข", role: .destructive) {
                isEditingEnabled = true
            }
            Button("ยกเลิก", role: .cancel) { }
        } message: {
            Text("คุณต้องการแก้ไขข้อมูลในส่วนนี้ใช่หรือไม่? เมื่อแก้ไขเสร็จแล้วกรุณากดปุ่ม 'บันทึก' ที่มุมขวาบน")
        }
    }
}

// MARK: - Component สำหรับแสดงข้อมูลที่ไม่สามารถแก้ไขได้ (ProfileInfoRow)
struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 120, alignment: .leading)
            Text(value)
                .foregroundColor(.primary)
                .lineLimit(nil)
        }
    }
}

