import SwiftUI

struct FamilyView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingInviteSheet = false
    
    var recentActivities: [ActivityItem] {
        // 從記錄中生成活動項目
        return dataManager.records.prefix(10).map { record in
            ActivityItem(
                memberName: "媽媽", // 簡化處理，實際應該關聯用戶
                action: "記錄了\(record.type.rawValue)",
                details: getRecordDetails(record),
                timestamp: record.timestamp
            )
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 家庭成員卡片
                    familyMembersCard
                    
                    // 最近活動
                    recentActivitiesCard
                    
                    // 邀請按鈕
                    inviteButton
                    
                    // 邀請碼
                    inviteCodeCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("家庭分享")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showingInviteSheet) {
            InviteView()
        }
    }
    
    private var familyMembersCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("家庭成員")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                ForEach(dataManager.familyMembers) { member in
                    FamilyMemberRow(member: member)
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var recentActivitiesCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("最近活動")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(spacing: 12) {
                ForEach(recentActivities) { activity in
                    ActivityRow(activity: activity)
                }
                
                if recentActivities.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "clock")
                            .font(.title2)
                            .foregroundColor(.gray)
                        
                        Text("暫無活動記錄")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    .padding(40)
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var inviteButton: some View {
        Button(action: {
            showingInviteSheet = true
        }) {
            HStack(spacing: 12) {
                Image(systemName: "person.badge.plus")
                    .font(.title3)
                
                Text("邀請新成員加入")
                    .font(.body)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.49, blue: 0.92),
                        Color(red: 0.46, green: 0.29, blue: 0.64)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var inviteCodeCard: some View {
        VStack(spacing: 15) {
            HStack(spacing: 12) {
                Image(systemName: "qrcode")
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("邀請碼：BT2024")
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    
                    Text("分享給家人即可加入")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("複製") {
                    UIPasteboard.general.string = "BT2024"
                }
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.blue)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(20)
        .background(Color.blue.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func getRecordDetails(_ record: BabyRecord) -> String {
        switch record.type {
        case .feeding:
            if let amount = record.amount {
                return "(\(Int(amount))ml)"
            }
        case .sleeping, .playing:
            if let duration = record.duration {
                return "(\(duration)分鐘)"
            }
        default:
            break
        }
        return ""
    }
}

struct FamilyMemberRow: View {
    let member: FamilyMember
    
    var body: some View {
        HStack(spacing: 15) {
            // 頭像
            ZStack {
                Circle()
                    .fill(memberColor)
                    .frame(width: 50, height: 50)
                
                Text(member.avatar)
                    .font(.title3)
            }
            
            // 成員信息
            VStack(alignment: .leading, spacing: 3) {
                Text(member.name)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(member.role)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // 在線狀態
            statusBadge
        }
    }
    
    private var memberColor: LinearGradient {
        let colors: [Color] = [.blue, .purple, .pink, .orange, .green]
        let index = abs(member.name.hashValue) % colors.count
        let color = colors[index]
        
        return LinearGradient(
            gradient: Gradient(colors: [color, color.opacity(0.8)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    private var statusBadge: some View {
        Group {
            if member.isOnline {
                Text("在線")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.green.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Text(timeAgoString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: member.lastActive, relativeTo: Date())
    }
}

struct ActivityRow: View {
    let activity: ActivityItem
    
    var body: some View {
        HStack(spacing: 12) {
            // 活動描述
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(activity.memberName)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(activity.action)
                        .font(.body)
                        .foregroundColor(.primary)
                    
                    if !activity.details.isEmpty {
                        Text(activity.details)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                }
                
                Text(timeAgoString)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
    
    private var timeAgoString: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: activity.timestamp, relativeTo: Date())
    }
}

struct ActivityItem: Identifiable {
    let id = UUID()
    let memberName: String
    let action: String
    let details: String
    let timestamp: Date
}

struct InviteView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // 邀請圖標
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(spacing: 15) {
                    Text("邀請家庭成員")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("分享邀請碼給家人，\n讓他們一起記錄寶寶的成長")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                
                // 邀請碼
                VStack(spacing: 15) {
                    Text("邀請碼")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("BT2024")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 15)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // 分享按鈕
                VStack(spacing: 12) {
                    Button("複製邀請碼") {
                        UIPasteboard.general.string = "BT2024"
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Button("分享給朋友") {
                        // 實際應用中會調用系統分享
                    }
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Spacer()
            }
            .padding(30)
            .navigationTitle("邀請成員")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FamilyView()
        .environmentObject(DataManager())
} 