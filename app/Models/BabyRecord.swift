import Foundation

// MARK: - 记录类型枚举
enum RecordType: String, CaseIterable {
    case feeding = "feeding"
    case diaper = "diaper"
    case sleep = "sleep"
    case growth = "growth"
    case milestone = "milestone"
    case medication = "medication"
    
    var displayName: String {
        switch self {
        case .feeding: return "餵奶"
        case .diaper: return "換尿布"
        case .sleep: return "睡眠"
        case .growth: return "成長"
        case .milestone: return "里程碑"
        case .medication: return "藥物"
        }
    }
    
    var iconName: String {
        switch self {
        case .feeding: return "drop.fill"
        case .diaper: return "tshirt.fill"
        case .sleep: return "moon.fill"
        case .growth: return "ruler.fill"
        case .milestone: return "star.fill"
        case .medication: return "pills.fill"
        }
    }
}

// MARK: - 基础记录协议
protocol BabyRecord {
    var id: UUID { get }
    var timestamp: Date { get }
    var type: RecordType { get }
    var notes: String? { get }
}

// MARK: - 餵奶记录
struct FeedingRecord: BabyRecord, Codable {
    let id: UUID
    let timestamp: Date
    let type: RecordType = .feeding
    var notes: String?
    
    let feedingType: FeedingType
    let duration: TimeInterval? // 餵奶持续时间（秒）
    let amount: Double? // 奶量（毫升）
    let side: BreastSide? // 母乳餵养时的侧边
    
    enum FeedingType: String, CaseIterable, Codable {
        case breast = "breast"
        case bottle = "bottle"
        case solid = "solid"
        
        var displayName: String {
            switch self {
            case .breast: return "母乳"
            case .bottle: return "奶瓶"
            case .solid: return "固體食物"
            }
        }
    }
    
    enum BreastSide: String, CaseIterable, Codable {
        case left = "left"
        case right = "right"
        case both = "both"
        
        var displayName: String {
            switch self {
            case .left: return "左側"
            case .right: return "右側"
            case .both: return "雙側"
            }
        }
    }
    
    init(feedingType: FeedingType, duration: TimeInterval? = nil, amount: Double? = nil, side: BreastSide? = nil, notes: String? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.feedingType = feedingType
        self.duration = duration
        self.amount = amount
        self.side = side
        self.notes = notes
    }
}

// MARK: - 尿布记录
struct DiaperRecord: BabyRecord, Codable {
    let id: UUID
    let timestamp: Date
    let type: RecordType = .diaper
    var notes: String?
    
    let diaperType: DiaperType
    let wetness: WetnessLevel
    let hasBowelMovement: Bool
    let consistency: BowelConsistency?
    
    enum DiaperType: String, CaseIterable, Codable {
        case wet = "wet"
        case dirty = "dirty"
        case both = "both"
        case dry = "dry"
        
        var displayName: String {
            switch self {
            case .wet: return "濕尿布"
            case .dirty: return "髒尿布"
            case .both: return "又濕又髒"
            case .dry: return "乾淨"
            }
        }
    }
    
    enum WetnessLevel: String, CaseIterable, Codable {
        case dry = "dry"
        case light = "light"
        case medium = "medium"
        case heavy = "heavy"
        
        var displayName: String {
            switch self {
            case .dry: return "乾燥"
            case .light: return "輕微"
            case .medium: return "中等"
            case .heavy: return "嚴重"
            }
        }
    }
    
    enum BowelConsistency: String, CaseIterable, Codable {
        case liquid = "liquid"
        case soft = "soft"
        case normal = "normal"
        case hard = "hard"
        
        var displayName: String {
            switch self {
            case .liquid: return "液體"
            case .soft: return "軟便"
            case .normal: return "正常"
            case .hard: return "硬便"
            }
        }
    }
    
    init(diaperType: DiaperType, wetness: WetnessLevel, hasBowelMovement: Bool, consistency: BowelConsistency? = nil, notes: String? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.diaperType = diaperType
        self.wetness = wetness
        self.hasBowelMovement = hasBowelMovement
        self.consistency = consistency
        self.notes = notes
    }
}

// MARK: - 睡眠记录
struct SleepRecord: BabyRecord, Codable {
    let id: UUID
    let timestamp: Date
    let type: RecordType = .sleep
    var notes: String?
    
    let startTime: Date
    let endTime: Date?
    let quality: SleepQuality
    let location: SleepLocation
    
    enum SleepQuality: String, CaseIterable, Codable {
        case excellent = "excellent"
        case good = "good"
        case fair = "fair"
        case poor = "poor"
        
        var displayName: String {
            switch self {
            case .excellent: return "極佳"
            case .good: return "良好"
            case .fair: return "一般"
            case .poor: return "不佳"
            }
        }
    }
    
    enum SleepLocation: String, CaseIterable, Codable {
        case crib = "crib"
        case bed = "bed"
        case stroller = "stroller"
        case carSeat = "carSeat"
        case other = "other"
        
        var displayName: String {
            switch self {
            case .crib: return "嬰兒床"
            case .bed: return "大床"
            case .stroller: return "嬰兒車"
            case .carSeat: return "汽車座椅"
            case .other: return "其他"
            }
        }
    }
    
    var duration: TimeInterval? {
        guard let endTime = endTime else { return nil }
        return endTime.timeIntervalSince(startTime)
    }
    
    init(startTime: Date, endTime: Date? = nil, quality: SleepQuality, location: SleepLocation, notes: String? = nil) {
        self.id = UUID()
        self.timestamp = startTime
        self.startTime = startTime
        self.endTime = endTime
        self.quality = quality
        self.location = location
        self.notes = notes
    }
}

// MARK: - 成長记录
struct GrowthRecord: BabyRecord, Codable {
    let id: UUID
    let timestamp: Date
    let type: RecordType = .growth
    var notes: String?
    
    let weight: Double? // 體重（公斤）
    let height: Double? // 身高（公分）
    let headCircumference: Double? // 頭圍（公分）
    
    init(weight: Double? = nil, height: Double? = nil, headCircumference: Double? = nil, notes: String? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.weight = weight
        self.height = height
        self.headCircumference = headCircumference
        self.notes = notes
    }
}

// MARK: - 里程碑记录
struct MilestoneRecord: BabyRecord, Codable {
    let id: UUID
    let timestamp: Date
    let type: RecordType = .milestone
    var notes: String?
    
    let milestoneType: MilestoneType
    let description: String
    let ageInDays: Int
    
    enum MilestoneType: String, CaseIterable, Codable {
        case physical = "physical"
        case cognitive = "cognitive"
        case social = "social"
        case language = "language"
        
        var displayName: String {
            switch self {
            case .physical: return "身體發展"
            case .cognitive: return "認知發展"
            case .social: return "社交發展"
            case .language: return "語言發展"
            }
        }
    }
    
    init(milestoneType: MilestoneType, description: String, ageInDays: Int, notes: String? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.milestoneType = milestoneType
        self.description = description
        self.ageInDays = ageInDays
        self.notes = notes
    }
}

// MARK: - 藥物记录
struct MedicationRecord: BabyRecord, Codable {
    let id: UUID
    let timestamp: Date
    let type: RecordType = .medication
    var notes: String?
    
    let medicationName: String
    let dosage: String
    let administrationMethod: AdministrationMethod
    let prescribedBy: String?
    
    enum AdministrationMethod: String, CaseIterable, Codable {
        case oral = "oral"
        case topical = "topical"
        case injection = "injection"
        case drops = "drops"
        
        var displayName: String {
            switch self {
            case .oral: return "口服"
            case .topical: return "外用"
            case .injection: return "注射"
            case .drops: return "滴劑"
            }
        }
    }
    
    init(medicationName: String, dosage: String, administrationMethod: AdministrationMethod, prescribedBy: String? = nil, notes: String? = nil) {
        self.id = UUID()
        self.timestamp = Date()
        self.medicationName = medicationName
        self.dosage = dosage
        self.administrationMethod = administrationMethod
        self.prescribedBy = prescribedBy
        self.notes = notes
    }
} 