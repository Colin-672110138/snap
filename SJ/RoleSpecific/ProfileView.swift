//
//  ProfileView.swift
//  SJ
//
//  Created by colin black on 12/11/2568 BE.
//

// Views/RoleSpecific/RoleSpecificHomeView.swift



// Views/ProfileView.swift

// Views/ProfileView.swift

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("โปรไฟล์ของฉัน")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                
                // MARK: - ส่วนที่ 1: รายการปุ่มข้อมูล
                VStack(alignment: .leading, spacing: 20) {
                    // 1. ปุ่มข้อมูลบัญชี
                    NavigationLink(destination: AccountDataView(viewModel: viewModel)) {
                        ProfileHeaderButton(viewModel: viewModel)
                    }
                    
                    Divider()
                    
                    // 2. ปุ่มรายการโปรด
                    NavigationLink(destination: FavoritesView(viewModel: viewModel)) {
                        ProfileListButton(title: "รายการโปรด", iconName: "heart.fill")
                    }
                    
                    // 3. ปุ่มโพสต์ของฉัน
                    NavigationLink(destination: MyPostsView(viewModel: viewModel)) {
                        ProfileListButton(title: "โพสต์ของฉัน", iconName: "list.bullet.clipboard.fill")
                    }
                    
                    // 4. ปุ่มรีวิวของฉัน
                    NavigationLink(destination: MyReviewsView()) {
                        ProfileListButton(title: "รีวิวของฉัน", iconName: "star.fill")
                    }
                    
                    // 5. ปุ่มแก้ไขพื้นที่สวน (เฉพาะผู้จ้างงาน)
                    if viewModel.userProfile.role == .employer {
                        Divider()
                        NavigationLink(destination: EditAreaView(viewModel: viewModel)) {
                            ProfileListButton(title: "แก้ไขพื้นที่สวน", iconName: "leaf.fill")
                        }
                    }
                }
                .padding(.bottom, 20) // สร้างช่องว่างเล็กน้อยระหว่างรายการกับปุ่ม Log Out
                
                // --- ตรงนี้ไม่มี Spacer ตัวใหญ่แล้ว ---
                
                // MARK: - ปุ่มออกจากระบบ (Log Out) <<< จัดอยู่กลางจอแนวตั้ง, ไม่ต่ำมาก
                Button(action: {
                    showingLogoutAlert = true
                }) {
                    Text("ออกจากระบบ")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 40) // กำหนดความกว้างและจัดให้ปุ่มอยู่กึ่งกลาง
                
                Spacer() // <<< Spacer ตัวนี้จะดันเนื้อหาทั้งหมด (รวมถึงปุ่ม Log Out) ขึ้นไปด้านบน ทำให้ปุ่ม Log Out อยู่ใกล้กับรายการปุ่มมากขึ้น
            }
            .padding(.top)
        }
        // MARK: - Alert ยืนยันการออกจากระบบ
        .alert("ยืนยันการออกจากระบบ", isPresented: $showingLogoutAlert) {
            Button("ออกจากระบบ", role: .destructive) {
                viewModel.logout()
            }
            Button("ยกเลิก", role: .cancel) { }
        } message: {
            Text("คุณต้องการออกจากระบบและกลับไปยังหน้าเข้าสู่ระบบหรือไม่?")
        }
    }
}

// MARK: - Component 1: ปุ่มหัว Profile (รูป/ชื่อ/Line ID)
struct ProfileHeaderButton: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        HStack(spacing: 15) {
            // รูปโปรไฟล์ (Placeholder)
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            
            VStack(alignment: .leading) {
                // ชื่อ (จาก LINE/OCR)
                Text(viewModel.userProfile.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                // Line ID
                Text("ID: \(viewModel.userProfile.lineID)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            
            Spacer()
            
            // Icon >
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
    }
}

// MARK: - Component 2: ปุ่มรายการทั่วไป (รายการโปรด, โพสต์, รีวิว)
struct ProfileListButton: View {
    let title: String
    let iconName: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .frame(width: 25)
                .foregroundColor(.blue) // สี Icon
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}

#Preview {
    ProfileView(viewModel: OnboardingViewModel())
            .environment(\.colorScheme, .light)
}
