//
//  LineLoginService.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

import Foundation
import Combine
import LineSDK
import UIKit

class LineLoginService: ObservableObject {
    static let shared = LineLoginService()
    
    @Published private(set) var isLoggingIn: Bool = false
    
    func setLoggingIn(_ value: Bool) {
        isLoggingIn = value
    }
    
    private init() {
        // ตั้งค่า LINE SDK
        // ต้องเพิ่ม Channel ID ใน Info.plist หรือใช้:
        // LoginManager.shared.setup(channelID: "YOUR_CHANNEL_ID", universalLinkURL: nil)
    }
    
    // MARK: - Login with LINE
    func login(completion: @escaping (Result<LineUserProfile, Error>) -> Void) {
        // หา UIViewController ปัจจุบันเพื่อใช้ในการแสดง login
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            // ถ้าหา rootViewController ไม่ได้ ให้ใช้ nil
            performLogin(in: nil, completion: completion)
            return
        }
        
        // หา topmost view controller
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            topController = presented
        }
        
        performLogin(in: topController, completion: completion)
    }
    
    private func performLogin(in viewController: UIViewController?, completion: @escaping (Result<LineUserProfile, Error>) -> Void) {
        print("Starting LINE login process...")
        
        // ตรวจสอบว่ามี login process เก่าค้างอยู่หรือไม่
        // ถ้ามี ให้ logout ก่อนเพื่อเคลียร์ state
        if LoginManager.shared.isAuthorized {
            print("Previous login session detected, logging out first...")
            LoginManager.shared.logout { _ in
                DispatchQueue.main.async {
                    // หลังจาก logout แล้วค่อย login ใหม่
                    self.performLoginAfterLogout(in: viewController, completion: completion)
                }
            }
            return
        }
        
        performLoginAfterLogout(in: viewController, completion: completion)
    }
    
    @MainActor
    private func performLoginAfterLogout(in viewController: UIViewController?, completion: @escaping (Result<LineUserProfile, Error>) -> Void) {
        print("Performing LINE login after logout...")
        
        // สร้าง LoginManager.Parameters เพื่อให้สามารถ recreate login process ได้
        // ใช้วิธีนี้เพื่อแก้ปัญหา "Trying to start another login process while previous process is still valid"
        var loginParameters = LoginManager.Parameters()
        loginParameters.allowRecreatingLoginProcess = true
        
        // ใช้ login method ที่ถูกต้องตามลำดับพารามิเตอร์:
        // permissions, in viewController, parameters, completionHandler
        LoginManager.shared.login(
            permissions: [.profile, .openID],
            in: viewController,
            parameters: loginParameters
        ) { result in
            print("LINE Login callback received")
            switch result {
            case .success(_):
                print("LINE Login success callback received")
                // ดึงข้อมูลผู้ใช้จาก Access Token
                API.getProfile { profileResult in
                    switch profileResult {
                    case .success(let profile):
                        print("Profile fetched successfully: \(profile.userID)")
                        let userProfile = LineUserProfile(
                            userID: profile.userID,
                            displayName: profile.displayName,
                            pictureURL: profile.pictureURL,
                            statusMessage: profile.statusMessage
                        )
                        // ปิดหน้าเว็บหลังจาก login สำเร็จ
                        DispatchQueue.main.async {
                            self.dismissWebView()
                        }
                        completion(.success(userProfile))
                    case .failure(let error):
                        print("Failed to get profile in completion: \(error.localizedDescription)")
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                print("LINE Login failed: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Dismiss Web View
    private func dismissWebView() {
        // หา topmost view controller และปิดหน้าเว็บ
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            // ถ้าเป็น SFSafariViewController หรือ web view ให้ปิด
            if String(describing: type(of: presented)).contains("SFSafariViewController") ||
               String(describing: type(of: presented)).contains("Safari") {
                topController.dismiss(animated: true, completion: nil)
                return
            }
            topController = presented
        }
    }
    
    // MARK: - Logout
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        // Reset isLoggingIn flag ก่อน logout
        setLoggingIn(false)
        
        LoginManager.shared.logout { result in
            switch result {
            case .success:
                print("LINE SDK logout successful")
                completion(.success(()))
            case .failure(let error):
                print("LINE SDK logout error: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Get Current Access Token
    func getCurrentAccessToken() -> String? {
        // LINE SDK เก็บ access token ไว้ใน LoginManager
        // ตรวจสอบว่า user login อยู่หรือไม่
        if LoginManager.shared.isAuthorized {
            // Access token จะถูกจัดการโดย LINE SDK อัตโนมัติ
            // ถ้าต้องการ access token จริงๆ อาจต้องเก็บไว้ใน login result
            return nil // หรือ return access token ที่เก็บไว้ใน login result
        }
        return nil
    }
    
    // MARK: - Check if user is logged in
    func isLoggedIn() -> Bool {
        return LoginManager.shared.isAuthorized
    }
}

// MARK: - Models
struct LineUserProfile {
    let userID: String
    let displayName: String
    let pictureURL: URL?
    let statusMessage: String?
}

// MARK: - Errors
enum LineLoginError: LocalizedError {
    case noAccessToken
    case loginFailed
    case profileFetchFailed
    
    var errorDescription: String? {
        switch self {
        case .noAccessToken:
            return "ไม่สามารถดึง Access Token ได้"
        case .loginFailed:
            return "การเข้าสู่ระบบล้มเหลว"
        case .profileFetchFailed:
            return "ไม่สามารถดึงข้อมูลโปรไฟล์ได้"
        }
    }
}
