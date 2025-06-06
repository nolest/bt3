import SwiftUI

struct StatisticsView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedPeriod: StatsPeriod = .today
    
    enum StatsPeriod: String, CaseIterable {
        case today = "今天"
        case week = "本週"
        case month = "本月"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // 期間選擇器
                    periodSelector
                    
                    // 習慣完成度卡片
                    habitCompletionCard
                    
                    // 統計數據網格
                    statsGrid
                    
                    // 圖表區域
                    chartsSection
                    
                    // 習慣養成進度
                    habitProgressSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("統計分析")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var periodSelector: some View {
        HStack(spacing: 10) {
            ForEach(StatsPeriod.allCases, id: \.self) { period in
                Button(action: {
                    selectedPeriod = period
                }) {
                    Text(period.rawValue)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedPeriod == period ? .white : .blue)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        .background(
                            selectedPeriod == period ? 
                            Color.blue : Color(.secondarySystemGroupedBackground)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private var habitCompletionCard: some View {
        let stats = dataManager.getTodayStatistics()
        
        return VStack(spacing: 15) {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.4, green: 0.49, blue: 0.92),
                        Color(red: 0.46, green: 0.29, blue: 0.64)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                
                VStack(spacing: 10) {
                    Text("\(Int(stats.habitCompletion * 100))%")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("習慣完成度")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(25)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    private var statsGrid: some View {
        let stats = dataManager.getTodayStatistics()
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 2), spacing: 15) {
            StatsCard(
                icon: "🍼",
                title: "總餵奶次數",
                value: "\(stats.feedingCount)",
                color: Color.orange
            )
            
            StatsCard(
                icon: "😴",
                title: "平均睡眠",
                value: String(format: "%.1fh", stats.sleepHours),
                color: Color.purple
            )
            
            StatsCard(
                icon: "👶",
                title: "換尿布次數",
                value: "\(stats.diaperChanges)",
                color: Color.green
            )
            
            StatsCard(
                icon: "🎈",
                title: "玩耍時間",
                value: "\(stats.playTime)分",
                color: Color.yellow
            )
        }
    }
    
    private var chartsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("本週趨勢")
                .font(.headline)
                .fontWeight(.bold)
            
            // 模擬圖表區域
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.secondarySystemGroupedBackground))
                        .frame(height: 200)
                    
                    VStack(spacing: 10) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.system(size: 48))
                            .foregroundColor(.gray)
                        
                        Text("餵奶頻率與時間圖表")
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.gray)
                        
                        Text("顯示每日餵奶次數和時間間隔")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // 模擬周數據
                HStack {
                    ForEach(["週一", "週二", "週三", "週四", "週五", "週六", "週日"], id: \.self) { day in
                        VStack(spacing: 5) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.blue.opacity(0.7))
                                .frame(width: 20, height: CGFloat.random(in: 30...80))
                            
                            Text(day)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        if day != "週日" {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var habitProgressSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("習慣養成進度")
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
                    title: "互動時間",
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

struct StatsCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 12) {
            Text(icon)
                .font(.system(size: 32))
            
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    StatisticsView()
        .environmentObject(DataManager())
} 