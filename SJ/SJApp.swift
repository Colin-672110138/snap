//
//  SJApp.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// (YourAppName)App.swift

import SwiftUI

@main
struct AppEntry: App {
    @StateObject var onboardingVM = OnboardingViewModel()
    
    var body: some Scene {
        WindowGroup {
            // MARK: - Logic ควบคุมการแสดงผล Root View
            if onboardingVM.isAuthenticated {
                // 1. ถ้า Logged In แล้ว (ผ่านหน้า Login)
                
                if onboardingVM.isProfileFullyVerified {
                    // 1a. ถ้าทำ Onboarding เสร็จแล้ว (หน้า 8)
                    NavigationStack {
                        MainDashboardView(viewModel: onboardingVM)
                    }
                } else {
                    // 1b. ถ้ายังทำ Onboarding ไม่เสร็จ (แสดงหน้าปัจจุบันใน Flow)
                    NavigationStack {
                        // เราจะใช้ WelcomeRoleSelectionView เป็นจุดเริ่มต้นของ Flow Onboarding
                        WelcomeRoleSelectionView(viewModel: onboardingVM)
                    }
                }
            } else {
                // 2. ถ้า Logged Out หรือยังไม่เคยเข้าสู่ระบบ
                NavigationStack {
                    LoginView(viewModel: onboardingVM)
                }
            }
        }
    }
}
