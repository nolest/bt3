import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {
        loadAllRecords()
    }
    
    // MARK: - 存储键
    private enum StorageKeys {
        static let feedingRecords = "FeedingRecords"
        static let diaperRecords = "DiaperRecords"
        static let sleepRecords = "SleepRecords"
        static let growthRecords = "GrowthRecords"
        static let milestoneRecords = "MilestoneRecords"
        static let medicationRecords = "MedicationRecords"
        static let babyProfile = "BabyProfile"
    }
    
    // MARK: - 记录存储
    private var feedingRecords: [FeedingRecord] = []
    private var diaperRecords: [DiaperRecord] = []
    private var sleepRecords: [SleepRecord] = []
    private var growthRecords: [GrowthRecord] = []
    private var milestoneRecords: [MilestoneRecord] = []
    private var medicationRecords: [MedicationRecord] = []
    
    // MARK: - 宝宝资料
    var babyProfile: BabyProfile? {
        didSet {
            saveBabyProfile()
        }
    }
    
    // MARK: - 通知
    static let recordsDidUpdateNotification = Notification.Name("RecordsDidUpdate")
    
    // MARK: - 添加记录
    func addRecord<T: BabyRecord & Codable>(_ record: T) {
        switch record {
        case let feeding as FeedingRecord:
            feedingRecords.append(feeding)
            saveFeedingRecords()
        case let diaper as DiaperRecord:
            diaperRecords.append(diaper)
            saveDiaperRecords()
        case let sleep as SleepRecord:
            sleepRecords.append(sleep)
            saveSleepRecords()
        case let growth as GrowthRecord:
            growthRecords.append(growth)
            saveGrowthRecords()
        case let milestone as MilestoneRecord:
            milestoneRecords.append(milestone)
            saveMilestoneRecords()
        case let medication as MedicationRecord:
            medicationRecords.append(medication)
            saveMedicationRecords()
        default:
            break
        }
        
        NotificationCenter.default.post(name: Self.recordsDidUpdateNotification, object: nil)
    }
    
    // MARK: - 获取记录
    func getRecords<T>(ofType type: T.Type) -> [T] {
        switch type {
        case is FeedingRecord.Type:
            return feedingRecords as! [T]
        case is DiaperRecord.Type:
            return diaperRecords as! [T]
        case is SleepRecord.Type:
            return sleepRecords as! [T]
        case is GrowthRecord.Type:
            return growthRecords as! [T]
        case is MilestoneRecord.Type:
            return milestoneRecords as! [T]
        case is MedicationRecord.Type:
            return medicationRecords as! [T]
        default:
            return []
        }
    }
    
    // MARK: - 获取今日记录
    func getTodayRecords() -> [any BabyRecord] {
        let calendar = Calendar.current
        let today = Date()
        
        var todayRecords: [any BabyRecord] = []
        
        todayRecords.append(contentsOf: feedingRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: today) })
        todayRecords.append(contentsOf: diaperRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: today) })
        todayRecords.append(contentsOf: sleepRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: today) })
        todayRecords.append(contentsOf: growthRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: today) })
        todayRecords.append(contentsOf: milestoneRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: today) })
        todayRecords.append(contentsOf: medicationRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: today) })
        
        return todayRecords.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - 获取最近记录
    func getRecentRecords(limit: Int = 10) -> [any BabyRecord] {
        var allRecords: [any BabyRecord] = []
        
        allRecords.append(contentsOf: feedingRecords)
        allRecords.append(contentsOf: diaperRecords)
        allRecords.append(contentsOf: sleepRecords)
        allRecords.append(contentsOf: growthRecords)
        allRecords.append(contentsOf: milestoneRecords)
        allRecords.append(contentsOf: medicationRecords)
        
        return Array(allRecords.sorted { $0.timestamp > $1.timestamp }.prefix(limit))
    }
    
    // MARK: - 获取指定日期范围的记录
    func getRecords(from startDate: Date, to endDate: Date) -> [any BabyRecord] {
        var records: [any BabyRecord] = []
        
        records.append(contentsOf: feedingRecords.filter { $0.timestamp >= startDate && $0.timestamp <= endDate })
        records.append(contentsOf: diaperRecords.filter { $0.timestamp >= startDate && $0.timestamp <= endDate })
        records.append(contentsOf: sleepRecords.filter { $0.timestamp >= startDate && $0.timestamp <= endDate })
        records.append(contentsOf: growthRecords.filter { $0.timestamp >= startDate && $0.timestamp <= endDate })
        records.append(contentsOf: milestoneRecords.filter { $0.timestamp >= startDate && $0.timestamp <= endDate })
        records.append(contentsOf: medicationRecords.filter { $0.timestamp >= startDate && $0.timestamp <= endDate })
        
        return records.sorted { $0.timestamp > $1.timestamp }
    }
    
    // MARK: - 删除记录
    func deleteRecord(withId id: UUID) {
        feedingRecords.removeAll { $0.id == id }
        diaperRecords.removeAll { $0.id == id }
        sleepRecords.removeAll { $0.id == id }
        growthRecords.removeAll { $0.id == id }
        milestoneRecords.removeAll { $0.id == id }
        medicationRecords.removeAll { $0.id == id }
        
        saveAllRecords()
        NotificationCenter.default.post(name: Self.recordsDidUpdateNotification, object: nil)
    }
    
    // MARK: - 统计功能
    func getTodayStats() -> DailyStats {
        let todayRecords = getTodayRecords()
        
        let feedingCount = todayRecords.filter { $0.type == .feeding }.count
        let diaperCount = todayRecords.filter { $0.type == .diaper }.count
        let sleepDuration = calculateTotalSleepDuration(for: Date())
        
        return DailyStats(
            feedingCount: feedingCount,
            diaperCount: diaperCount,
            sleepDuration: sleepDuration,
            lastFeedingTime: getLastRecordTime(ofType: .feeding),
            lastDiaperTime: getLastRecordTime(ofType: .diaper),
            lastSleepTime: getLastRecordTime(ofType: .sleep)
        )
    }
    
    private func calculateTotalSleepDuration(for date: Date) -> TimeInterval {
        let calendar = Calendar.current
        let sleepRecordsToday = sleepRecords.filter { calendar.isDate($0.timestamp, inSameDayAs: date) }
        
        return sleepRecordsToday.compactMap { $0.duration }.reduce(0, +)
    }
    
    private func getLastRecordTime(ofType type: RecordType) -> Date? {
        let allRecords = getRecentRecords(limit: 100)
        return allRecords.first { $0.type == type }?.timestamp
    }
    
    // MARK: - 数据持久化
    private func saveAllRecords() {
        saveFeedingRecords()
        saveDiaperRecords()
        saveSleepRecords()
        saveGrowthRecords()
        saveMilestoneRecords()
        saveMedicationRecords()
    }
    
    private func saveFeedingRecords() {
        if let data = try? JSONEncoder().encode(feedingRecords) {
            UserDefaults.standard.set(data, forKey: StorageKeys.feedingRecords)
        }
    }
    
    private func saveDiaperRecords() {
        if let data = try? JSONEncoder().encode(diaperRecords) {
            UserDefaults.standard.set(data, forKey: StorageKeys.diaperRecords)
        }
    }
    
    private func saveSleepRecords() {
        if let data = try? JSONEncoder().encode(sleepRecords) {
            UserDefaults.standard.set(data, forKey: StorageKeys.sleepRecords)
        }
    }
    
    private func saveGrowthRecords() {
        if let data = try? JSONEncoder().encode(growthRecords) {
            UserDefaults.standard.set(data, forKey: StorageKeys.growthRecords)
        }
    }
    
    private func saveMilestoneRecords() {
        if let data = try? JSONEncoder().encode(milestoneRecords) {
            UserDefaults.standard.set(data, forKey: StorageKeys.milestoneRecords)
        }
    }
    
    private func saveMedicationRecords() {
        if let data = try? JSONEncoder().encode(medicationRecords) {
            UserDefaults.standard.set(data, forKey: StorageKeys.medicationRecords)
        }
    }
    
    private func saveBabyProfile() {
        if let profile = babyProfile,
           let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: StorageKeys.babyProfile)
        }
    }
    
    private func loadAllRecords() {
        loadFeedingRecords()
        loadDiaperRecords()
        loadSleepRecords()
        loadGrowthRecords()
        loadMilestoneRecords()
        loadMedicationRecords()
        loadBabyProfile()
    }
    
    private func loadFeedingRecords() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.feedingRecords),
           let records = try? JSONDecoder().decode([FeedingRecord].self, from: data) {
            feedingRecords = records
        }
    }
    
    private func loadDiaperRecords() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.diaperRecords),
           let records = try? JSONDecoder().decode([DiaperRecord].self, from: data) {
            diaperRecords = records
        }
    }
    
    private func loadSleepRecords() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.sleepRecords),
           let records = try? JSONDecoder().decode([SleepRecord].self, from: data) {
            sleepRecords = records
        }
    }
    
    private func loadGrowthRecords() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.growthRecords),
           let records = try? JSONDecoder().decode([GrowthRecord].self, from: data) {
            growthRecords = records
        }
    }
    
    private func loadMilestoneRecords() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.milestoneRecords),
           let records = try? JSONDecoder().decode([MilestoneRecord].self, from: data) {
            milestoneRecords = records
        }
    }
    
    private func loadMedicationRecords() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.medicationRecords),
           let records = try? JSONDecoder().decode([MedicationRecord].self, from: data) {
            medicationRecords = records
        }
    }
    
    private func loadBabyProfile() {
        if let data = UserDefaults.standard.data(forKey: StorageKeys.babyProfile),
           let profile = try? JSONDecoder().decode(BabyProfile.self, from: data) {
            babyProfile = profile
        }
    }
}

// MARK: - 宝宝资料模型
struct BabyProfile: Codable {
    let id: UUID
    var name: String
    var birthDate: Date
    var gender: Gender
    var birthWeight: Double? // 出生體重（公斤）
    var birthHeight: Double? // 出生身高（公分）
    var photoData: Data? // 头像照片数据
    
    enum Gender: String, CaseIterable, Codable {
        case male = "male"
        case female = "female"
        case other = "other"
        
        var displayName: String {
            switch self {
            case .male: return "男孩"
            case .female: return "女孩"
            case .other: return "其他"
            }
        }
    }
    
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    var ageDescription: String {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: birthDate, to: Date())
        
        if let years = components.year, years > 0 {
            if let months = components.month, months > 0 {
                return "\(years)歲\(months)個月"
            } else {
                return "\(years)歲"
            }
        } else if let months = components.month, months > 0 {
            if let days = components.day, days > 0 {
                return "\(months)個月\(days)天"
            } else {
                return "\(months)個月"
            }
        } else if let days = components.day {
            return "\(days)天"
        }
        
        return "新生兒"
    }
    
    init(name: String, birthDate: Date, gender: Gender, birthWeight: Double? = nil, birthHeight: Double? = nil, photoData: Data? = nil) {
        self.id = UUID()
        self.name = name
        self.birthDate = birthDate
        self.gender = gender
        self.birthWeight = birthWeight
        self.birthHeight = birthHeight
        self.photoData = photoData
    }
}

// MARK: - 每日统计模型
struct DailyStats {
    let feedingCount: Int
    let diaperCount: Int
    let sleepDuration: TimeInterval
    let lastFeedingTime: Date?
    let lastDiaperTime: Date?
    let lastSleepTime: Date?
    
    var sleepDurationFormatted: String {
        let hours = Int(sleepDuration) / 3600
        let minutes = Int(sleepDuration) % 3600 / 60
        return "\(hours)小時\(minutes)分鐘"
    }
} 