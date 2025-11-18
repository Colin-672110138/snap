// Views/Onboarding/GenderSelectionView.swift

import SwiftUI

struct GenderSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    @State private var goToNextStep = false
    
    // ตั้งค่าสีสำหรับการเลือกให้สอดคล้องกับ Role Selection (สีฟ้า)
    let selectedColor = Color.blue

    var body: some View {
        VStack(spacing: 30) {
            Text("ข้อมูลส่วนตัว (3/8)") // อัปเดตเลขหน้า
                .font(.title2)
                .bold()
            
            Text("กรุณาเลือกเพศของคุณ")
                .font(.headline)
            
            // MARK: - ปุ่มเลือกเพศ 3 ปุ่ม (เรียงลงมา)
            VStack(spacing: 20) { // ใช้ spacing 20 เพื่อให้ดูไม่ติดกัน
                // ปุ่ม "ชาย"
                GenderButton(
                    title: "ชาย",
                    tag: "Male",
                    iconName: "m.circle.fill", // เพิ่ม icon
                    selectedTag: $viewModel.userProfile.gender
                )
                
                // ปุ่ม "หญิง"
                GenderButton(
                    title: "หญิง",
                    tag: "Female",
                    iconName: "f.circle.fill", // เพิ่ม icon
                    selectedTag: $viewModel.userProfile.gender
                )
                
                // ปุ่ม "ไม่ระบุ"
                GenderButton(
                    title: "ไม่ระบุ",
                    tag: "Other", // ใช้ "Other" แทน
                    iconName: "questionmark.circle.fill", // เพิ่ม icon
                    selectedTag: $viewModel.userProfile.gender
                )
            }
            .padding(.horizontal, 30) // เพิ่ม padding ด้านข้างเพื่อให้ดูไม่ติดขอบ
            
            Spacer()
            
            // ปุ่มดำเนินการต่อ
            Button("ดำเนินการต่อ") {
                // ตรวจสอบว่ามีการเลือกแล้ว (Male, Female, หรือ Other)
                if !viewModel.userProfile.gender.isEmpty {
                    goToNextStep = true
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            // ใช้สีเขียวเมื่อเลือกแล้ว / สีเทาเมื่อยังไม่เลือก
            .background(viewModel.userProfile.gender.isEmpty ? Color.gray : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(viewModel.userProfile.gender.isEmpty)
        }
        .padding()
        .navigationTitle("เลือกเพศ")
        
        // MARK: - การนำทางไปหน้า 4
        .navigationDestination(isPresented: $goToNextStep) {
            IDCardUploadView(viewModel: viewModel)
        }
    }
}

// MARK: - Component สำหรับปุ่มเลือกเพศ (Cube-like Style)
struct GenderButton: View {
    let title: String
    let tag: String
    let iconName: String
    @Binding var selectedTag: String
    
    var isSelected: Bool {
        return selectedTag == tag
    }
    
    // 🎨 ฟังก์ชันเลือกสีตามเพศ
    var selectedColor: Color {
        switch tag {
        case "Male": return Color.blue.opacity(0.15)
        case "Female": return Color.pink.opacity(0.2)
        default: return Color.purple.opacity(0.15)
        }
    }
    
    var strokeColor: Color {
        switch tag {
        case "Male": return .blue
        case "Female": return .pink
        default: return .purple
        }
    }

    var body: some View {
        Button(action: {
            selectedTag = tag
        }) {
            HStack(spacing: 20) {
                Image(systemName: iconName)
                    .font(.title)
                    .frame(width: 40)
                
                Text(title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
            }
            .foregroundColor(isSelected ? strokeColor : .primary)
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ? selectedColor : Color.gray.opacity(0.15)
            )
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? strokeColor : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? strokeColor.opacity(0.25) : .clear, radius: 4, x: 0, y: 2)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
// #Preview ของเดิม (แนะนำให้ลบก่อนใช้งานจริง)

#Preview {
    GenderSelectionView(viewModel: OnboardingViewModel())
        .environment(\.colorScheme, .light)
}

