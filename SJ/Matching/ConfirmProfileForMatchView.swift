import SwiftUI

struct ConfirmProfileForMatchView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var rai: String = ""
    @State private var ngan: String = ""
    @State private var sqMeters: String = ""
    @State private var longanTrees: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Header
                Text("ยืนยันข้อมูลสวนของคุณ")
                    .font(.title2)
                    .bold()
                    .padding(.top, 10)
                
                // MARK: - Form style manually (ดูสวยกว่า Form)
                VStack(spacing: 15) {
                    
                    profileRow(title: "จำนวนไร่", hint: "เช่น 3", value: $rai)
                    profileRow(title: "จำนวนงาน", hint: "เช่น 2", value: $ngan)
                    profileRow(title: "ตารางเมตร", hint: "เช่น 500", value: $sqMeters)
                    profileRow(title: "จำนวนต้นลำไย", hint: "เช่น 120", value: $longanTrees)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                Spacer()
                
                // MARK: - ปุ่มสีเขียวเหมือนปุ่มเดิมของแอป
                NavigationLink(destination: MatchResultView(viewModel: viewModel)) {
                    Text("เริ่มจับคู่")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.green)
                        .cornerRadius(10)
                        .font(.headline)
                }
                .padding(.bottom, 20)
                
            }
            .padding()
            .navigationTitle("ยืนยันข้อมูลของคุณ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("ปิด") { dismiss() }
                }
            }
            .onAppear {
                // ⭐ โหลดข้อมูลจาก employerProfile
                rai = String(viewModel.employerProfile.rai ?? 0)
                ngan = String(viewModel.employerProfile.ngan ?? 0)
                sqMeters = String(viewModel.employerProfile.squareMeters ?? 0)
                longanTrees = String(viewModel.employerProfile.longanTreeCount ?? 0)
                viewModel.userProfile.province = "เชียงใหม่"
            }
        }
    }
    
    // MARK: - Component แถวข้อมูลสวน
    func profileRow(title: String, hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            TextField(hint, text: value)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 1, y: 1)
        }
    }
}
