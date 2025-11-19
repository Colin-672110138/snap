//
//  ContentView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        Group {
            if viewModel.isAuthenticated {
                // 1. ถ้า Logged In แล้ว (ผ่านหน้า Login)
                NavigationStack {
                    if viewModel.isProfileFullyVerified {
                        // 1a. ถ้าทำ Onboarding เสร็จแล้ว (หน้า 8)
                        MainDashboardView(viewModel: viewModel)
                    } else {
                        // 1b. ถ้ายังทำ Onboarding ไม่เสร็จ (แสดงหน้าปัจจุบันใน Flow)
                        // เราจะใช้ WelcomeRoleSelectionView เป็นจุดเริ่มต้นของ Flow Onboarding
                        WelcomeRoleSelectionView(viewModel: viewModel)
                    }
                }
                .transition(.opacity)
            } else {
                // 2. ถ้า Logged Out หรือยังไม่เคยเข้าสู่ระบบ
                NavigationStack {
                    LoginView(viewModel: viewModel)
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isAuthenticated)
    }
}

#Preview {
    ContentView(viewModel: OnboardingViewModel())
}
