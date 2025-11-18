// Views/Authentication/WelcomeRoleSelectionView.swift

import SwiftUI

struct WelcomeRoleSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    // 1. สถานะสำหรับเก็บการเลือกบทบาทชั่วคราว
    @State private var selectedRole: UserRole = .none
    
    // 2. สถานะสำหรับควบคุมการนำทางเมื่อกดปุ่ม
    @State private var goToNextStep: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("ยินดีต้อนรับ")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Image(systemName: "person.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.black)
            
            Text((viewModel.userProfile.name))
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
            
            Text("เลือกบทบาทของคุณ")
                .font(.title2)
                .padding(.bottom, 0)
            
            // MARK: - ปุ่มเลือกบทบาท
            VStack(spacing: 20) {
                RoleSelectionButton(
                    role: .employer,
                    title: UserRole.employer.rawValue,
                    description: "ต้องการหาคนงานมาช่วยเก็บผลผลิต",
                    selectedRole: $selectedRole // ส่ง Binding เพื่อติดตามการเลือก
                ) {
                    selectedRole = .employer // อัปเดตการเลือกเมื่อถูกกด
                }
                
                RoleSelectionButton(
                    role: .jobSeeker,
                    title: UserRole.jobSeeker.rawValue,
                    description: "ต้องการหางานรับจ้างเก็บผลผลิต",
                    selectedRole: $selectedRole // ส่ง Binding เพื่อติดตามการเลือก
                ) {
                    selectedRole = .jobSeeker // อัปเดตการเลือกเมื่อถูกกด
                }
            }
            
            Spacer()
            
            // MARK: - ปุ่มดำเนินการต่อ
            Button("ดำเนินการต่อ") {
                // 3. เมื่อกดปุ่ม ให้อัปเดต ViewModel และนำทาง
                viewModel.selectRole(selectedRole) // บันทึกบทบาทที่เลือกใน ViewModel
                goToNextStep = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            // ใช้สีเขียวเมื่อเลือกแล้ว / สีเทาเมื่อยังไม่เลือก
            .background(selectedRole == .none ? Color.gray : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(selectedRole == .none) // 4. ปิดใช้งานถ้ายังไม่ได้เลือก
        }
        .padding()
        
        // 5. การนำทางจะเกิดขึ้นเมื่อ goToNextStep เป็น true เท่านั้น
        .navigationDestination(isPresented: $goToNextStep) {
            GenderSelectionView(viewModel: viewModel)
        }
    }
}


// MARK: - Component สำหรับปุ่มเลือกบทบาท (สไตล์ใหม่: ขุ่น → ฟ้าอ่อนเมื่อเลือก)
struct RoleSelectionButton: View {
    let role: UserRole
    let title: String
    let description: String
    @Binding var selectedRole: UserRole // รับสถานะการเลือก
    let action: () -> Void
    
    var isSelected: Bool {
        return selectedRole == role
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(isSelected ? .blue : .primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .blue.opacity(0.8) : .gray)
                }
                Spacer()
                
                // ไอคอนวงกลมเลือก (เพิ่มความรู้สึก interactive)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .blue : .gray.opacity(0.6))
                    .imageScale(.large)
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                isSelected
                ? Color.blue.opacity(0.15)    // สีฟ้าอ่อนเมื่อเลือก
                : Color.gray.opacity(0.15)    // สีเทาใสขุ่นเมื่อยังไม่เลือก
            )
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            )
            .shadow(color: isSelected ? Color.blue.opacity(0.2) : .clear, radius: 4, x: 0, y: 2)
        }
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}

#Preview {
    WelcomeRoleSelectionView(viewModel: OnboardingViewModel())
            .environment(\.colorScheme, .light)
}
