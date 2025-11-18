//
//  EditAreaView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/Profile/EditAreaView.swift

// Views/Profile/EditAreaView.swift

import SwiftUI

struct EditAreaView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // State สำหรับเก็บค่าที่แก้ไขชั่วคราว (ใช้ String สำหรับ TextField ตัวเลข)
    @State private var raiInput: String
    @State private var nganInput: String
    @State private var sqMeterInput: String
    @State private var treeCountInput: String
    
    @State private var isEditingEnabled: Bool = false
    
    // init เพื่อดึงค่าปัจจุบันจาก ViewModel มาใส่ใน State
    init(viewModel: OnboardingViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        // แปลง Int? เป็น String สำหรับ TextField
        self._raiInput = State(initialValue: viewModel.employerProfile.rai.map { String($0) } ?? "")
        self._nganInput = State(initialValue: viewModel.employerProfile.ngan.map { String($0) } ?? "")
        self._sqMeterInput = State(initialValue: viewModel.employerProfile.squareMeters.map { String($0) } ?? "")
        self._treeCountInput = State(initialValue: viewModel.employerProfile.longanTreeCount.map { String($0) } ?? "")
    }

    // ฟังก์ชันสำหรับบันทึกข้อมูลกลับ ViewModel
    func saveChanges() {
        viewModel.saveEmployerProfile(
            rai: Int(raiInput),
            ngan: Int(nganInput),
            sqMeters: Int(sqMeterInput),
            treeCount: Int(treeCountInput)
        )
    }

    var body: some View {
        VStack {
            Text("แก้ไขพื้นที่สวน")
                .font(.title)
                .padding(.bottom, 10)
            
            Form {
                Section(header: Text("ขนาดพื้นที่ (ไร่ / งาน / ตารางเมตร)")) {
                    // 1. ไร่
                    AreaEditRow(label: "ไร่", value: $raiInput, isEditing: isEditingEnabled)
                    
                    // 2. งาน
                    AreaEditRow(label: "งาน", value: $nganInput, isEditing: isEditingEnabled)
                    
                    // 3. ตารางเมตร
                    AreaEditRow(label: "ตารางเมตร", value: $sqMeterInput, isEditing: isEditingEnabled)
                }
                
                Section(header: Text("จำนวนต้นลำไย")) {
                    // 4. จำนวนต้นลำไย
                    AreaEditRow(label: "จำนวนต้น", value: $treeCountInput, isEditing: isEditingEnabled)
                }
            }
            Spacer()
        }
        .navigationTitle("แก้ไขพื้นที่สวน")
        .navigationBarTitleDisplayMode(.inline)
        // MARK: - ปุ่มแก้ไข/บันทึกใน Navigation Bar
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(isEditingEnabled ? "บันทึก" : "แก้ไข") {
                    if isEditingEnabled {
                        // บันทึกและออกจากโหมดแก้ไข
                        saveChanges()
                        isEditingEnabled = false
                    } else {
                        // เข้าสู่โหมดแก้ไข
                        isEditingEnabled = true
                    }
                }
            }
        }
    }
}

// MARK: - Component สำหรับแถวแก้ไขพื้นที่ (Edit Row)
struct AreaEditRow: View {
    let label: String
    @Binding var value: String
    let isEditing: Bool
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            TextField("กรอก \(label)", text: $value)
                .keyboardType(.numberPad)
                .disabled(!isEditing)
                // สีพื้นหลังเพื่อบ่งบอกสถานะ
        }
        .padding(.vertical, 5)
    }
}
