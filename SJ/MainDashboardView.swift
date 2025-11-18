//
//  MainDashboardView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/MainDashboardView.swift

import SwiftUI

struct MainDashboardView: View {
    // ต้องรับ ViewModel เข้ามาเพื่อเข้าถึง Role และข้อมูลอื่นๆ
    @StateObject var viewModel: OnboardingViewModel

    var body: some View {
        TabView (selection: $viewModel.currentTabIndex){
            // MARK: - Tab 1: หน้าหลัก (Home/Dashboard)
            // ใช้ View เฉพาะบทบาทสำหรับ Home
            RoleSpecificHomeView(viewModel: viewModel)
                .tabItem {
                    Label("หน้าหลัก", systemImage: "house.fill")
                }
                .tag(0)
            
            // MARK: - Tab 2: หน้าประกาศ (Postings/Jobs)
            // Icon จะเปลี่ยนไปตามบทบาท
            RoleSpecificPostingView(viewModel: viewModel)
                .tabItem {
                    Label("โพสต์",
                          // Icon เปลี่ยน: + สำหรับ Employer, List สำหรับ Job Seeker
                          systemImage: viewModel.userProfile.role == .employer ? "plus.circle.fill" : "plus.circle.fill")
                }
                .tag(1)
            
            // MARK: - Tab 3: หน้าโปรไฟล์
            // ใช้ View สำหรับ Profile
            ProfileView(viewModel: viewModel)
                .tabItem {
                    Label("โปรไฟล์", systemImage: "person.fill")
                }
                .tag(2)
        }
        //.navigationTitle("แอปเกษตรลำไย")
        .navigationBarBackButtonHidden(true)
    }
}


