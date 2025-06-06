import Foundation

// 寶寶信息模型
struct Baby: Codable, Identifiable {
    let id = UUID()
    var name: String
    var birthDate: Date
    var gender: Gender
    var photoData: Data?
    
    enum Gender: String, CaseIterable, Codable {
        case male = "男寶寶"
        case female = "女寶寶"
    }
    
    var ageInDays: Int {
        Calendar.current.dateComponents([.day], from: birthDate, to: Date()).day ?? 0
    }
    
    var ageString: String {
        let days = ageInDays
        let months = days / 30
        let remainingDays = days % 30
        
        if months > 0 {
            return "\(months)個月\(remainingDays)天"
        } else {
            return "\(days)天"
        }
    }
}

// 記錄類型
enum RecordType: String, CaseIterable, Codable {
    case feeding = "餵奶"
    case sleeping = "睡覺"
    case diaper = "換尿布"
    case playing = "玩耍"
    case photo = "拍照"
    case medical = "健康"
    
    var icon: String {
        switch self {
        case .feeding: return "🍼"
        case .sleeping: return "😴"
        case .diaper: return "👶"
        case .playing: return "🎈"
        case .photo: return "📸"
        case .medical: return "🏥"
        }
    }
    
    var color: String {
        switch self {
        case .feeding: return "orange"
        case .sleeping: return "purple"
        case .diaper: return "green"
        case .playing: return "yellow"
        case .photo: return "pink"
        case .medical: return "blue"
        }
    }
}

// 記錄模型
struct BabyRecord: Codable, Identifiable {
    let id = UUID()
    var type: RecordType
    var timestamp: Date
    var duration: Int? // 持續時間（分鐘）
    var amount: Double? // 奶量（ml）
    var feedingType: FeedingType?
    var notes: String
    var photoData: Data?
    
    enum FeedingType: String, CaseIterable, Codable {
        case breast = "母乳"
        case formula = "奶粉"
        case mixed = "混合"
    }
}

// 里程碑模型
struct Milestone: Codable, Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var ageRange: String
    var isCompleted: Bool
    var completedDate: Date?
    var category: MilestoneCategory
    
    enum MilestoneCategory: String, CaseIterable, Codable {
        case physical = "身體發展"
        case cognitive = "認知發展"
        case social = "社交發展"
        case language = "語言發展"
    }
}

// 家庭成員模型
struct FamilyMember: Codable, Identifiable {
    let id = UUID()
    var name: String
    var role: String
    var isOnline: Bool
    var lastActive: Date
    var avatar: String
}

// 統計數據模型
struct Statistics {
    var feedingCount: Int
    var sleepHours: Double
    var diaperChanges: Int
    var playTime: Int
    var habitCompletion: Double
    
    static let empty = Statistics(
        feedingCount: 0,
        sleepHours: 0,
        diaperChanges: 0,
        playTime: 0,
        habitCompletion: 0
    )
} 