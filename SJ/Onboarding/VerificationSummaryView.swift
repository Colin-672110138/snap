// Views/Onboarding/VerificationSummaryView.swift

import SwiftUI
import UIKit

struct VerificationSummaryView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showingConfirmation = false

    var body: some View {
        VStack(spacing: 30) {
            // ... (Title and Subtitle)
            
            Text("ยืนยันรูปถ่าย") // <<< หัวข้อใหม่ตามที่ต้องการ
                .font(.title3)
                .bold()
                .padding(.top, 10)
            
            // MARK: - แถบแสดงรูปภาพ 3 รูป (ปรับให้ดูสะอาดตา)
            ScrollView { // เพิ่ม ScrollView เพื่อรองรับรูปภาพขนาดใหญ่
                VStack(spacing: 5) {
                    // รูปภาพแต่ละรายการจะถูกแสดงโดยไม่มีพื้นหลังสีเทา
                    SummaryImage(title: "บัตรประชาชนด้านหน้า", uiImage: viewModel.idCardFrontImage)
                    SummaryImage(title: "บัตรประชาชนด้านหลัง", uiImage: viewModel.idCardBackImage)
                    SummaryImage(title: "รูปถ่ายคู่บัตร", uiImage: viewModel.selfieWithIDImage)
                }
                .padding(.horizontal, 20) // เพิ่ม Padding ให้โดยรวมดูไม่ติดขอบ
                
                Spacer()
            }
            // ปรับปุ่มให้ย้ายมาอยู่ด้านล่างสุดของหน้าจอ
            
            // MARK: - ปุ่มยืนยัน
            Button("ยืนยันและดำเนินการต่อ") {
                showingConfirmation = true
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal) // เพิ่ม Padding ให้ปุ่ม
            
        }
        .padding()
        //.navigationTitle("ยืนยันตัวตน")
        // MARK: - ข้อความเด้ง (Alert)
        .alert("ยืนยันตัวตนเรียบร้อย", isPresented: $showingConfirmation) {
            Button("ไปยังหน้าหลัก") {
                viewModel.isProfileFullyVerified = true // <<< ตั้งค่าเพื่อ Trigger Navigation
            }
        } message: {
            Text("คุณสามารถเริ่มโพสต์งานหรือหางานได้ทันที")
        }
        
        // MARK: - การนำทางไปหน้าหลัก (แก้ไข: ส่ง viewModel เข้าไป)
        .navigationDestination(isPresented: $viewModel.isProfileFullyVerified) {
            MainDashboardView(viewModel: viewModel) // <<<< แก้ไขตรงนี้
        }
    }
}

// MARK: - Component สำหรับแสดงรูปในหน้าสรุป (ปรับปรุง Minimal Style)
struct SummaryImage: View {
    let title: String
    let uiImage: UIImage?
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title) // <<< ย้ายหัวข้อมาด้านบนรูป
                .font(.caption)
                .bold()
                .foregroundColor(.secondary)
            
            if let uiImage = uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 180) // เพิ่มความสูงให้รูปดูใหญ่ขึ้น
                    .cornerRadius(8)
                    .shadow(radius: 5) // เพิ่มเงาเล็กน้อยให้รูปภาพดูมีมิติ
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .frame(height: 160)
            }
        }
        .frame(maxWidth: .infinity)
        // <<< ลบ Background, Padding และ Shadow ภายนอกออกทั้งหมด >>>
    }
}

#Preview {
    // ต้องสร้าง Instance ของ ViewModel และส่งเข้าไปใน Preview
    VerificationSummaryView(viewModel: OnboardingViewModel())
        .environment(\.colorScheme, .light)
}
