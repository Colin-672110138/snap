//
//  SJApp.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// (YourAppName)App.swift

import SwiftUI
import LineSDK
import UIKit

@main
struct AppEntry: App {
    @StateObject var onboardingVM = OnboardingViewModel()
    
    init() {
        // ตั้งค่า LINE SDK เมื่อแอปเริ่มต้น
        // ต้องเพิ่ม Channel ID ใน Info.plist หรือใช้:
        LoginManager.shared.setup(channelID: "2008472580", universalLinkURL: nil)
    }
    
    var body: some Scene {
        WindowGroup {
            // MARK: - Logic ควบคุมการแสดงผล Root View
            ContentView(viewModel: onboardingVM)
                .onOpenURL { url in
                    // จัดการ URL callback จาก LINE SDK
                    // LINE SDK จะจัดการ URL callback อัตโนมัติผ่าน URL scheme ที่ตั้งค่าไว้ใน Info.plist
                    print("Received URL callback: \(url)")
                    
                    // LINE SDK จะปิดหน้าเว็บอัตโนมัติเมื่อ login สำเร็จ
                    // แต่ถ้ายังไม่ปิด อาจต้องจัดการเพิ่มเติม
                    handleLineCallback(url: url)
                }
        }
    }
    
    // MARK: - Handle LINE SDK URL Callback
    private func handleLineCallback(url: URL) {
        if url.scheme?.hasPrefix("line3rdp") == true {
            print("LINE URL callback received: \(url)")
            // URL callback จาก LINE SDK
            // LINE SDK จะจัดการ callback เองผ่าน completion callback ใน performLogin
            // แต่ถ้า completion callback ไม่ถูกเรียก เราต้องตรวจสอบเอง
            
            // ปิดหน้าเว็บก่อน
            dismissWebView()
            
            // รอให้ LINE SDK จัดการ callback เสร็จก่อน (completion callback ควรจะถูกเรียก)
            // แล้วตรวจสอบ login status หลายครั้ง
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // ถ้ายังไม่ authorized อาจจะต้องใช้วิธีอื่น
                if !LoginManager.shared.isAuthorized {
                    print("LINE SDK not authorized after callback, trying alternative method...")
                    // ลองใช้ checkLoginStatus จาก ViewModel
                    self.onboardingVM.checkLoginStatus()
                }
                self.checkAndCompleteLoginWithRetry(retryCount: 0, maxRetries: 20)
            }
        }
    }
    
    // MARK: - Check and Complete Login with Retry
    private func checkAndCompleteLoginWithRetry(retryCount: Int, maxRetries: Int) {
        print("Checking login status (attempt \(retryCount + 1)/\(maxRetries + 1))")
        print("isAuthorized: \(LoginManager.shared.isAuthorized)")
        print("Current isAuthenticated: \(onboardingVM.isAuthenticated)")
        
        // ตรวจสอบว่า LINE SDK login สำเร็จหรือไม่
        if LoginManager.shared.isAuthorized {
            print("LINE SDK is authorized, fetching profile...")
            // ดึงข้อมูล profile
            API.getProfile { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profile):
                        print("Profile fetched: \(profile.userID), \(profile.displayName)")
                        // บันทึกข้อมูลจาก LINE
                        self.onboardingVM.userProfile.lineID = profile.userID
                        self.onboardingVM.userProfile.name = profile.displayName
                        
                        // Set authenticated
                        self.onboardingVM.isAuthenticated = true
                        print("Login completed successfully - isAuthenticated set to: \(self.onboardingVM.isAuthenticated)")
                        
                        // Force UI update
                        DispatchQueue.main.async {
                            // ให้แน่ใจว่า UI update
                            print("UI should update now - isAuthenticated: \(self.onboardingVM.isAuthenticated)")
                        }
                        
                    case .failure(let error):
                        print("Failed to get profile: \(error.localizedDescription)")
                        // Retry ถ้ายังไม่สำเร็จ
                        if retryCount < maxRetries {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                self.checkAndCompleteLoginWithRetry(retryCount: retryCount + 1, maxRetries: maxRetries)
                            }
                        }
                    }
                }
            }
            } else {
                print("LINE SDK not authorized yet (retry \(retryCount + 1)/\(maxRetries + 1))")
                // ถ้ายังไม่ authorized ให้ retry
                if retryCount < maxRetries {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.checkAndCompleteLoginWithRetry(retryCount: retryCount + 1, maxRetries: maxRetries)
                    }
                } else {
                    print("Login check timeout - LINE SDK may not be ready yet")
                    // ถ้า retry หมดแล้วยังไม่สำเร็จ ให้ใช้ mock login เป็น fallback
                    print("Using mock login as fallback")
                    self.onboardingVM.performMockLineLogin()
                }
            }
    }
    
    // MARK: - Dismiss Web View
    private func dismissWebView() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            // ถ้าเป็น SFSafariViewController หรือ web view ให้ปิด
            let viewControllerType = String(describing: type(of: presented))
            if viewControllerType.contains("SFSafariViewController") ||
               viewControllerType.contains("Safari") ||
               viewControllerType.contains("Web") {
                topController.dismiss(animated: true, completion: nil)
                return
            }
            topController = presented
        }
    }
}
