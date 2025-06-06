import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingBabyInfoEditor = false
    @State private var feedingReminder = true
    @State private var sleepReminder = true
    @State private var diaperReminder = false
    @State private var cloudBackup = true
    
    var body: some View {
        NavigationView {
            List {
                // 寶寶信息
                babyInfoSection
                
                // 提醒設置
                reminderSection
                
                // 數據與隱私
                dataPrivacySection
                
                // 幫助與支持
                helpSupportSection
            }
            .navigationTitle("設置")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingBabyInfoEditor) {
            BabyInfoEditor()
        }
    }
    
    private var babyInfoSection: some View {
        Section("寶寶信息") {
            Button(action: {
                showingBabyInfoEditor = true
            }) {
                HStack(spacing: 15) {
                    // 寶寶頭像
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color(red: 1.0, green: 0.92, blue: 0.65),
                                        Color(red: 0.98, green: 0.69, blue: 0.63)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 50, height: 50)
                        
                        Text("👶")
                            .font(.title2)
                    }
                    
                    VStack(alignment: .leading, spacing: 3) {
                        Text(dataManager.baby?.name ?? "小寶貝")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        if let baby = dataManager.baby {
                            Text("\(formatDate(baby.birthDate)) • \(baby.gender.rawValue)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private var reminderSection: some View {
        Section("提醒設置") {
            SettingToggleRow(
                icon: "🍼",
                title: "餵奶提醒",
                subtitle: "每3小時提醒一次",
                isOn: $feedingReminder,
                iconColor: .orange
            )
            
            SettingToggleRow(
                icon: "😴",
                title: "睡眠提醒",
                subtitle: "每晚8:00提醒睡前準備",
                isOn: $sleepReminder,
                iconColor: .purple
            )
            
            SettingToggleRow(
                icon: "👶",
                title: "換尿布提醒",
                subtitle: "根據記錄智能提醒",
                isOn: $diaperReminder,
                iconColor: .green
            )
        }
    }
    
    private var dataPrivacySection: some View {
        Section("數據與隱私") {
            SettingRow(
                icon: "⬇️",
                title: "導出數據",
                subtitle: "將記錄導出為PDF或Excel",
                iconColor: .blue
            ) {
                // 導出數據邏輯
            }
            
            SettingRow(
                icon: "🛡️",
                title: "隱私設置",
                subtitle: "管理數據共享權限",
                iconColor: .orange
            ) {
                // 隱私設置邏輯
            }
            
            SettingToggleRow(
                icon: "☁️",
                title: "雲端備份",
                subtitle: "自動備份到iCloud",
                isOn: $cloudBackup,
                iconColor: .blue
            )
        }
    }
    
    private var helpSupportSection: some View {
        Section("幫助與支持") {
            SettingRow(
                icon: "❓",
                title: "使用幫助",
                subtitle: "常見問題與使用指南",
                iconColor: .blue
            ) {
                // 幫助頁面
            }
            
            SettingRow(
                icon: "⭐",
                title: "評價應用",
                subtitle: "在App Store中評價",
                iconColor: .yellow
            ) {
                // 跳轉到App Store評價
            }
            
            SettingRow(
                icon: "🚪",
                title: "關於應用",
                subtitle: "版本信息與開發團隊",
                iconColor: .gray
            ) {
                // 關於頁面
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let iconColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                // 圖標
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 35, height: 35)
                    
                    Text(icon)
                        .font(.body)
                }
                
                // 文本
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SettingToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    let iconColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            // 圖標
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 35, height: 35)
                
                Text(icon)
                    .font(.body)
            }
            
            // 文本
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 開關
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
    }
}

struct BabyInfoEditor: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var birthDate = Date()
    @State private var gender: Baby.Gender = .male
    
    var body: some View {
        NavigationView {
            Form {
                Section("基本信息") {
                    HStack {
                        Text("姓名")
                        Spacer()
                        TextField("寶寶姓名", text: $name)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    DatePicker("出生日期", selection: $birthDate, displayedComponents: .date)
                    
                    Picker("性別", selection: $gender) {
                        ForEach(Baby.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                }
                
                Section("頭像") {
                    HStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(red: 1.0, green: 0.92, blue: 0.65),
                                            Color(red: 0.98, green: 0.69, blue: 0.63)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                            
                            Text("👶")
                                .font(.system(size: 40))
                        }
                        
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("編輯信息")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("取消") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        saveBabyInfo()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            if let baby = dataManager.baby {
                name = baby.name
                birthDate = baby.birthDate
                gender = baby.gender
            }
        }
    }
    
    private func saveBabyInfo() {
        let updatedBaby = Baby(
            name: name.isEmpty ? "小寶貝" : name,
            birthDate: birthDate,
            gender: gender
        )
        
        dataManager.updateBaby(updatedBaby)
        dismiss()
    }
}

#Preview {
    SettingsView()
        .environmentObject(DataManager())
} 