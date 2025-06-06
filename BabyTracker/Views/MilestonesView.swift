import SwiftUI

struct MilestonesView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var completedMilestones: [Milestone] {
        dataManager.milestones.filter { $0.isCompleted }
    }
    
    var pendingMilestones: [Milestone] {
        dataManager.milestones.filter { !$0.isCompleted }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 進度概覽卡片
                    progressOverviewCard
                    
                    // 里程碑列表
                    milestonesContent
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("成長里程碑")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var progressOverviewCard: some View {
        VStack(spacing: 15) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.49, blue: 0.92),
                        Color(red: 0.46, green: 0.29, blue: 0.64)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 15) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.yellow)
                    
                    Text("已完成 \(completedMilestones.count)/\(dataManager.milestones.count) 個里程碑")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("您的寶寶發展得很好！")
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(25)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var milestonesContent: some View {
        VStack(spacing: 25) {
            // 0-3個月里程碑
            milestoneSection(
                title: "0-3個月",
                milestones: dataManager.milestones.filter { 
                    $0.ageRange.contains("週") || $0.ageRange.contains("3個月")
                }
            )
            
            // 3-6個月里程碑
            milestoneSection(
                title: "3-6個月",
                milestones: dataManager.milestones.filter { 
                    $0.ageRange.contains("6個月") || $0.ageRange.contains("4-6") || $0.ageRange.contains("6-8")
                }
            )
            
            // 6個月以上里程碑
            milestoneSection(
                title: "6個月以上",
                milestones: dataManager.milestones.filter { 
                    $0.ageRange.contains("7-") || $0.ageRange.contains("10-")
                }
            )
        }
    }
    
    private func milestoneSection(title: String, milestones: [Milestone]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.bottom, 5)
            
            VStack(spacing: 12) {
                ForEach(milestones) { milestone in
                    MilestoneRow(milestone: milestone) {
                        dataManager.toggleMilestone(milestone)
                    }
                }
            }
        }
    }
}

struct MilestoneRow: View {
    let milestone: Milestone
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 15) {
                // 里程碑圖標
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: iconName)
                        .font(.title3)
                        .foregroundColor(.white)
                }
                
                // 里程碑內容
                VStack(alignment: .leading, spacing: 5) {
                    Text(milestone.title)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Text(statusText)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // 狀態標籤
                statusBadge
            }
            .padding(20)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: milestone.isCompleted)
    }
    
    private var iconBackgroundColor: LinearGradient {
        if milestone.isCompleted {
            return LinearGradient(
                gradient: Gradient(colors: [Color.green, Color.mint]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                gradient: Gradient(colors: [Color.gray, Color.gray.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    private var iconName: String {
        if milestone.isCompleted {
            return "checkmark"
        } else {
            return "clock"
        }
    }
    
    private var statusText: String {
        if milestone.isCompleted {
            if let date = milestone.completedDate {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return "已完成 - \(formatter.string(from: date))"
            } else {
                return "已完成"
            }
        } else {
            return "預計 \(milestone.ageRange) 達成"
        }
    }
    
    private var statusBadge: some View {
        Group {
            if milestone.isCompleted {
                Text("已完成")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.green)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            } else {
                Text("待完成")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
}

#Preview {
    MilestonesView()
        .environmentObject(DataManager())
} 