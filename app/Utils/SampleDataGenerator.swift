import Foundation

class SampleDataGenerator {
    static let shared = SampleDataGenerator()
    
    private init() {}
    
    func generateSampleDataIfNeeded() {
        let dataManager = DataManager.shared
        
        // 如果没有宝宝资料，创建一个示例资料
        if dataManager.babyProfile == nil {
            createSampleBabyProfile()
        }
        
        // 如果没有记录，创建一些示例记录
        if dataManager.getRecentRecords(limit: 1).isEmpty {
            createSampleRecords()
        }
    }
    
    private func createSampleBabyProfile() {
        let dataManager = DataManager.shared
        
        // 创建一个3个月大的宝宝
        let birthDate = Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date()
        
        let babyProfile = BabyProfile(
            name: "小寶貝",
            birthDate: birthDate,
            gender: .female,
            birthWeight: 3.2,
            birthHeight: 50.0
        )
        
        dataManager.babyProfile = babyProfile
    }
    
    private func createSampleRecords() {
        let dataManager = DataManager.shared
        
        // 创建今天的一些记录
        let today = Date()
        let calendar = Calendar.current
        
        // 餵奶记录 - 今天早上8点
        if let morningTime = calendar.date(bySettingHour: 8, minute: 0, second: 0, of: today) {
            let feedingRecord = FeedingRecord(
                feedingType: .breast,
                duration: 1200, // 20分钟
                side: .left
            )
            // 手动设置时间
            let modifiedRecord = FeedingRecord(feedingType: feedingRecord.feedingType, duration: feedingRecord.duration, amount: feedingRecord.amount, side: feedingRecord.side, notes: feedingRecord.notes)
            dataManager.addRecord(modifiedRecord)
        }
        
        // 换尿布记录 - 今天早上9点
        if let diaperTime = calendar.date(bySettingHour: 9, minute: 30, second: 0, of: today) {
            let diaperRecord = DiaperRecord(
                diaperType: .wet,
                wetness: .medium,
                hasBowelMovement: false
            )
            dataManager.addRecord(diaperRecord)
        }
        
        // 睡眠记录 - 今天上午10点到12点
        if let sleepStart = calendar.date(bySettingHour: 10, minute: 0, second: 0, of: today),
           let sleepEnd = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: today) {
            let sleepRecord = SleepRecord(
                startTime: sleepStart,
                endTime: sleepEnd,
                quality: .good,
                location: .crib
            )
            dataManager.addRecord(sleepRecord)
        }
        
        // 成长记录 - 昨天
        if let yesterday = calendar.date(byAdding: .day, value: -1, to: today) {
            let growthRecord = GrowthRecord(
                weight: 6.2,
                height: 62.0,
                headCircumference: 40.5,
                notes: "定期體檢"
            )
            dataManager.addRecord(growthRecord)
        }
        
        // 里程碑记录 - 一周前
        if let weekAgo = calendar.date(byAdding: .day, value: -7, to: today) {
            let milestoneRecord = MilestoneRecord(
                milestoneType: .physical,
                description: "第一次翻身",
                ageInDays: 90,
                notes: "寶寶今天第一次自己翻身了！"
            )
            dataManager.addRecord(milestoneRecord)
        }
        
        // 更多餵奶记录
        createAdditionalFeedingRecords()
        
        // 更多换尿布记录
        createAdditionalDiaperRecords()
    }
    
    private func createAdditionalFeedingRecords() {
        let dataManager = DataManager.shared
        let calendar = Calendar.current
        let today = Date()
        
        // 今天中午12点
        if let lunchTime = calendar.date(bySettingHour: 12, minute: 30, second: 0, of: today) {
            let record = FeedingRecord(
                feedingType: .breast,
                duration: 900, // 15分钟
                side: .right
            )
            dataManager.addRecord(record)
        }
        
        // 今天下午3点
        if let afternoonTime = calendar.date(bySettingHour: 15, minute: 0, second: 0, of: today) {
            let record = FeedingRecord(
                feedingType: .bottle,
                amount: 120.0 // 120ml
            )
            dataManager.addRecord(record)
        }
        
        // 今天晚上6点
        if let eveningTime = calendar.date(bySettingHour: 18, minute: 15, second: 0, of: today) {
            let record = FeedingRecord(
                feedingType: .breast,
                duration: 1080, // 18分钟
                side: .both
            )
            dataManager.addRecord(record)
        }
    }
    
    private func createAdditionalDiaperRecords() {
        let dataManager = DataManager.shared
        let calendar = Calendar.current
        let today = Date()
        
        // 今天中午1点
        if let lunchTime = calendar.date(bySettingHour: 13, minute: 0, second: 0, of: today) {
            let record = DiaperRecord(
                diaperType: .dirty,
                wetness: .light,
                hasBowelMovement: true,
                consistency: .soft
            )
            dataManager.addRecord(record)
        }
        
        // 今天下午4点
        if let afternoonTime = calendar.date(bySettingHour: 16, minute: 30, second: 0, of: today) {
            let record = DiaperRecord(
                diaperType: .wet,
                wetness: .heavy,
                hasBowelMovement: false
            )
            dataManager.addRecord(record)
        }
        
        // 今天晚上7点
        if let eveningTime = calendar.date(bySettingHour: 19, minute: 45, second: 0, of: today) {
            let record = DiaperRecord(
                diaperType: .both,
                wetness: .medium,
                hasBowelMovement: true,
                consistency: .normal
            )
            dataManager.addRecord(record)
        }
    }
    
    func createTestRecord() {
        let dataManager = DataManager.shared
        
        // 创建一个测试餵奶记录
        let testRecord = FeedingRecord(
            feedingType: .breast,
            duration: 600, // 10分钟
            side: .left,
            notes: "測試記錄"
        )
        
        dataManager.addRecord(testRecord)
    }
} 