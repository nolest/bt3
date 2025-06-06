import SwiftUI

struct HomeView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 寶寶信息卡片
                    babyInfoCard
                    
                    // 快速操作按鈕
                    quickActionsGrid
                    
                    // 今日統計
                    todayStatsCard
                    
                    // 習慣進度
                    habitProgressCard
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("今天概覽")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var babyInfoCard: some View {
        VStack(spacing: 0) {
            // 漸變背景
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.49, blue: 0.92),
                        Color(red: 0.46, green: 0.29, blue: 0.64)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                HStack(spacing: 20) {
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
                            .frame(width: 70, height: 70)
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                        
                        Text("👶")
                            .font(.system(size: 32))
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("\(dataManager.baby?.name ?? "小寶貝")的一天")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("\(dataManager.baby?.ageString ?? "3個月15天") • 今天表現很棒！")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                }
                .padding(25)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var quickActionsGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
            ForEach(RecordType.allCases, id: \.self) { recordType in
                QuickActionButton(recordType: recordType) {
                    dataManager.selectedRecordType = recordType
                    dataManager.showingRecordSheet = true
                }
            }
        }
    }
    
    private var todayStatsCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("今日統計")
                .font(.headline)
                .fontWeight(.bold)
            
            let stats = dataManager.getTodayStatistics()
            
            HStack {
                StatItem(
                    icon: "🍼",
                    value: "\(stats.feedingCount)",
                    label: "次餵奶",
                    color: Color.orange
                )
                
                Spacer()
                
                StatItem(
                    icon: "😴",
                    value: String(format: "%.1fh", stats.sleepHours),
                    label: "睡眠時間",
                    color: Color.purple
                )
                
                Spacer()
                
                StatItem(
                    icon: "👶",
                    value: "\(stats.diaperChanges)",
                    label: "換尿布",
                    color: Color.green
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var habitProgressCard: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("今日習慣進度")
                .font(.headline)
                .fontWeight(.bold)
            
            let stats = dataManager.getTodayStatistics()
            
            VStack(spacing: 15) {
                HabitProgressRow(
                    icon: "🍼",
                    title: "規律餵奶",
                    progress: min(Double(stats.feedingCount) / 8.0, 1.0),
                    color: Color.orange
                )
                
                HabitProgressRow(
                    icon: "😴",
                    title: "睡眠規律",
                    progress: min(stats.sleepHours / 14.0, 1.0),
                    color: Color.purple
                )
                
                HabitProgressRow(
                    icon: "🎈",
                    title: "互動玩耍",
                    progress: min(Double(stats.playTime) / 120.0, 1.0),
                    color: Color.yellow
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct QuickActionButton: View {
    let recordType: RecordType
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                Text(recordType.icon)
                    .font(.system(size: 32))
                
                Text(recordType.rawValue)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(1.0)
        .animation(.easeInOut(duration: 0.1), value: false)
    }
}

struct StatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(icon)
                .font(.title2)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct HabitProgressRow: View {
    let icon: String
    let title: String
    let progress: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            // 圖標
            ZStack {
                Circle()
                    .fill(color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Text(icon)
                    .font(.title3)
            }
            
            // 標題
            Text(title)
                .font(.body)
                .foregroundColor(.primary)
            
            Spacer()
            
            // 進度條
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 80, height: 8)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 80 * progress, height: 8)
                    .animation(.easeInOut(duration: 1), value: progress)
            }
            
            // 百分比
            Text("\(Int(progress * 100))%")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(color)
                .frame(width: 35, alignment: .trailing)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(DataManager())
} 