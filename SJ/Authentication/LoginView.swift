//
//  LoginView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/Authentication/LoginView.swift

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            
            
            Image("Logo1")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle()) // ทำให้เป็นวงกลม
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 4) // เส้นขอบสีขาว
                )
                .shadow(radius: 2) // เพิ่มเงาเล็กน้อย (optional)
            
            Text("ยินดีต้อนรับสู่ ")
                .font(.largeTitle)
                .bold()
            + Text("Suk")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.yellow)
            + Text("Job")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.green)
            
            HStack {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)

                Text("เข้าสู่ระบบ")
                    .font(.headline)
                    .foregroundColor(.gray)

                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
            }
            
            // ปุ่มจำลองการ Login
            Button(action: {
                viewModel.performLineLogin() // เรียกใช้ Mock Login
            }) {
                HStack {
                    //Image("") // สมมติว่ามีรูป Line Icon
                    Text("เข้าสู่ระบบด้วย LINE")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green) // สีเขียวสื่อถึงการเกษตร/Go
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding(40)
        // เมื่อ Login สำเร็จ (isAuthenticated = true) จะนำทางไปหน้าถัดไป
        .navigationDestination(isPresented: $viewModel.isAuthenticated) {
            WelcomeRoleSelectionView(viewModel: viewModel)
        }
    }
}
#Preview {
    LoginView(viewModel: OnboardingViewModel())
            .environment(\.colorScheme, .light)
}
