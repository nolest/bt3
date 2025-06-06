import Foundation
import SwiftUI

class DataManager: ObservableObject {
    @Published var baby: Baby?
    @Published var records: [BabyRecord] = []
    @Published var milestones: [Milestone] = []
    @Published var familyMembers: [FamilyMember] = []
    @Published var showingRecordSheet = false
    @Published var selectedRecordType: RecordType = .feeding
    
    init() {
        loadData()
        setupDefaultData()
    }
    
    // MARK: - 數據持久化
    private func saveData() {
        if let baby = baby {
            saveBaby(baby)
        }
        saveRecords(records)
        saveMilestones(milestones)
        saveFamilyMembers(familyMembers)
    }
    
    private func loadData() {
        baby = loadBaby()
        records = loadRecords()
        milestones = loadMilestones()
        familyMembers = loadFamilyMembers()
    }
    
    private func saveBaby(_ baby: Baby) {
        if let data = try? JSONEncoder().encode(baby) {
            UserDefaults.standard.set(data, forKey: "baby")
        }
    }
    
    private func loadBaby() -> Baby? {
        guard let data = UserDefaults.standard.data(forKey: "baby"),
              let baby = try? JSONDecoder().decode(Baby.self, from: data) else {
            return nil
        }
        return baby
    }
    
    private func saveRecords(_ records: [BabyRecord]) {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: "records")
        }
    }
    
    private func loadRecords() -> [BabyRecord] {
        guard let data = UserDefaults.standard.data(forKey: "records"),
              let records = try? JSONDecoder().decode([BabyRecord].self, from: data) else {
            return []
        }
        return records
    }
    
    private func saveMilestones(_ milestones: [Milestone]) {
        if let data = try? JSONEncoder().encode(milestones) {
            UserDefaults.standard.set(data, forKey: "milestones")
        }
    }
    
    private func loadMilestones() -> [Milestone] {
        guard let data = UserDefaults.standard.data(forKey: "milestones"),
              let milestones = try? JSONDecoder().decode([Milestone].self, from: data) else {
            return []
        }
        return milestones
    }
    
    private func saveFamilyMembers(_ members: [FamilyMember]) {
        if let data = try? JSONEncoder().encode(members) {
            UserDefaults.standard.set(data, forKey: "familyMembers")
        }
    }
    
    private func loadFamilyMembers() -> [FamilyMember] {
        guard let data = UserDefaults.standard.data(forKey: "familyMembers"),
              let members = try? JSONDecoder().decode([FamilyMember].self, from: data) else {
            return []
        }
        return members
    }
    
    // MARK: - 業務邏輯
    func addRecord(_ record: BabyRecord) {
        records.append(record)
        records.sort { $0.timestamp > $1.timestamp }
        saveData()
    }
    
    func updateBaby(_ baby: Baby) {
        self.baby = baby
        saveData()
    }
    
    func toggleMilestone(_ milestone: Milestone) {
        if let index = milestones.firstIndex(where: { $0.id == milestone.id }) {
            milestones[index].isCompleted.toggle()
            milestones[index].completedDate = milestones[index].isCompleted ? Date() : nil
            saveData()
        }
    }
    
    // MARK: - 統計數據
    func getTodayStatistics() -> Statistics {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        let todayRecords = records.filter { record in
            record.timestamp >= today && record.timestamp < tomorrow
        }
        
        let feedingCount = todayRecords.filter { $0.type == .feeding }.count
        let sleepRecords = todayRecords.filter { $0.type == .sleeping }
        let sleepHours = Double(sleepRecords.compactMap { $0.duration }.reduce(0, +)) / 60.0
        let diaperChanges = todayRecords.filter { $0.type == .diaper }.count
        let playRecords = todayRecords.filter { $0.type == .playing }
        let playTime = playRecords.compactMap { $0.duration }.reduce(0, +)
        
        // 簡單的習慣完成度計算
        let targetFeeding = 8
        let targetSleep = 14.0
        let targetDiaper = 6
        
        let feedingCompletion = min(Double(feedingCount) / Double(targetFeeding), 1.0)
        let sleepCompletion = min(sleepHours / targetSleep, 1.0)
        let diaperCompletion = min(Double(diaperChanges) / Double(targetDiaper), 1.0)
        
        let habitCompletion = (feedingCompletion + sleepCompletion + diaperCompletion) / 3.0
        
        return Statistics(
            feedingCount: feedingCount,
            sleepHours: sleepHours,
            diaperChanges: diaperChanges,
            playTime: playTime,
            habitCompletion: habitCompletion
        )
    }
    
    func getLastFeedingTime() -> Date? {
        return records.filter { $0.type == .feeding }
            .sorted { $0.timestamp > $1.timestamp }
            .first?.timestamp
    }
    
    // MARK: - 默認數據
    private func setupDefaultData() {
        // 如果沒有寶寶信息，創建默認的
        if baby == nil {
            baby = Baby(
                name: "小寶貝",
                birthDate: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(),
                gender: .male
            )
        }
        
        // 如果沒有里程碑，創建默認的
        if milestones.isEmpty {
            milestones = createDefaultMilestones()
        }
        
        // 如果沒有家庭成員，創建默認的
        if familyMembers.isEmpty {
            familyMembers = createDefaultFamilyMembers()
        }
        
        saveData()
    }
    
    private func createDefaultMilestones() -> [Milestone] {
        return [
            Milestone(title: "第一次微笑", description: "寶寶開始對外界有反應", ageRange: "6-8週", isCompleted: true, completedDate: Date(), category: .social),
            Milestone(title: "能夠抬頭", description: "趴著時能抬起頭部", ageRange: "2-4個月", isCompleted: true, completedDate: Date(), category: .physical),
            Milestone(title: "學會翻身", description: "從趴著翻到仰著或相反", ageRange: "4-6個月", isCompleted: false, category: .physical),
            Milestone(title: "獨立坐立", description: "不需要支撐獨立坐著", ageRange: "6-8個月", isCompleted: false, category: .physical),
            Milestone(title: "開始爬行", description: "能夠向前移動", ageRange: "7-10個月", isCompleted: false, category: .physical),
            Milestone(title: "說出第一個詞", description: "有意義的發音", ageRange: "10-14個月", isCompleted: false, category: .language)
        ]
    }
    
    private func createDefaultFamilyMembers() -> [FamilyMember] {
        return [
            FamilyMember(name: "媽媽", role: "主要照顧者", isOnline: true, lastActive: Date(), avatar: "👩"),
            FamilyMember(name: "爸爸", role: "協助照顧", isOnline: false, lastActive: Calendar.current.date(byAdding: .hour, value: -2, to: Date()) ?? Date(), avatar: "👨"),
            FamilyMember(name: "奶奶", role: "偶爾照顧", isOnline: false, lastActive: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), avatar: "👵")
        ]
    }
} 