import Foundation
import UIKit

// MARK: - GAI分析媒体类型
enum MediaType: String, Codable, CaseIterable {
    case photo = "photo"
    case video = "video"
    
    var displayName: String {
        switch self {
        case .photo: return "照片"
        case .video: return "影片"
        }
    }
}

// MARK: - GAI分析状态
enum AnalysisStatus: String, Codable, CaseIterable {
    case pending = "pending"
    case processing = "processing"
    case completed = "completed"
    case failed = "failed"
    
    var displayName: String {
        switch self {
        case .pending: return "等待分析"
        case .processing: return "分析中"
        case .completed: return "分析完成"
        case .failed: return "分析失敗"
        }
    }
    
    var color: UIColor {
        switch self {
        case .pending: return .systemOrange
        case .processing: return .systemBlue
        case .completed: return .systemGreen
        case .failed: return .systemRed
        }
    }
}

// MARK: - 寶寶發展階段
enum DevelopmentStage: String, Codable, CaseIterable {
    case newborn = "newborn"          // 新生兒 (0-3個月)
    case infant = "infant"            // 嬰兒 (3-12個月)
    case toddler = "toddler"          // 幼兒 (1-3歲)
    case preschool = "preschool"      // 學齡前 (3-5歲)
    
    var displayName: String {
        switch self {
        case .newborn: return "新生兒 (0-3個月)"
        case .infant: return "嬰兒 (3-12個月)"
        case .toddler: return "幼兒 (1-3歲)"
        case .preschool: return "學齡前 (3-5歲)"
        }
    }
    
    var ageRange: String {
        switch self {
        case .newborn: return "0-3個月"
        case .infant: return "3-12個月"
        case .toddler: return "1-3歲"
        case .preschool: return "3-5歲"
        }
    }
}

// MARK: - 情緒狀態
enum EmotionState: String, Codable, CaseIterable {
    case happy = "happy"
    case calm = "calm"
    case curious = "curious"
    case sleepy = "sleepy"
    case crying = "crying"
    case fussy = "fussy"
    case alert = "alert"
    case content = "content"
    
    var displayName: String {
        switch self {
        case .happy: return "開心"
        case .calm: return "平靜"
        case .curious: return "好奇"
        case .sleepy: return "想睡"
        case .crying: return "哭泣"
        case .fussy: return "煩躁"
        case .alert: return "警覺"
        case .content: return "滿足"
        }
    }
    
    var emoji: String {
        switch self {
        case .happy: return "😊"
        case .calm: return "😌"
        case .curious: return "🤔"
        case .sleepy: return "😴"
        case .crying: return "😢"
        case .fussy: return "😤"
        case .alert: return "👀"
        case .content: return "😇"
        }
    }
    
    var color: UIColor {
        switch self {
        case .happy: return UIColor.systemYellow
        case .calm: return UIColor.systemBlue
        case .curious: return UIColor.systemPurple
        case .sleepy: return UIColor.systemIndigo
        case .crying: return UIColor.systemRed
        case .fussy: return UIColor.systemOrange
        case .alert: return UIColor.systemGreen
        case .content: return UIColor.systemPink
        }
    }
}

// MARK: - 運動發展評估
struct MotorDevelopmentAssessment: Codable {
    let grossMotor: MotorSkillLevel      // 大肌肉運動
    let fineMotor: MotorSkillLevel       // 精細運動
    let coordination: MotorSkillLevel     // 協調性
    let balance: MotorSkillLevel          // 平衡感
    let detectedActivities: [String]      // 檢測到的活動
    let recommendations: [String]         // 建議
    
    enum MotorSkillLevel: String, Codable, CaseIterable {
        case belowAverage = "below_average"
        case average = "average"
        case aboveAverage = "above_average"
        case advanced = "advanced"
        
        var displayName: String {
            switch self {
            case .belowAverage: return "需要關注"
            case .average: return "正常發展"
            case .aboveAverage: return "發展良好"
            case .advanced: return "超前發展"
            }
        }
        
        var score: Int {
            switch self {
            case .belowAverage: return 1
            case .average: return 2
            case .aboveAverage: return 3
            case .advanced: return 4
            }
        }
        
        var color: UIColor {
            switch self {
            case .belowAverage: return .systemRed
            case .average: return .systemOrange
            case .aboveAverage: return .systemGreen
            case .advanced: return .systemBlue
            }
        }
    }
}

// MARK: - 認知發展評估
struct CognitiveDevelopmentAssessment: Codable {
    let attention: CognitiveSkillLevel       // 注意力
    let socialInteraction: CognitiveSkillLevel // 社交互動
    let languageReadiness: CognitiveSkillLevel // 語言準備度
    let problemSolving: CognitiveSkillLevel   // 問題解決
    let observedBehaviors: [String]           // 觀察到的行為
    let milestones: [String]                  // 達成的里程碑
    
    enum CognitiveSkillLevel: String, Codable, CaseIterable {
        case developing = "developing"
        case emerging = "emerging"
        case established = "established"
        case advanced = "advanced"
        
        var displayName: String {
            switch self {
            case .developing: return "發展中"
            case .emerging: return "初現跡象"
            case .established: return "已建立"
            case .advanced: return "超前發展"
            }
        }
        
        var score: Int {
            switch self {
            case .developing: return 1
            case .emerging: return 2
            case .established: return 3
            case .advanced: return 4
            }
        }
        
        var color: UIColor {
            switch self {
            case .developing: return .systemRed
            case .emerging: return .systemOrange
            case .established: return .systemGreen
            case .advanced: return .systemBlue
            }
        }
    }
}

// MARK: - GAI分析結果
struct GAIAnalysisResult: Codable {
    let id: UUID
    let mediaId: UUID
    let timestamp: Date
    let analysisVersion: String
    
    // 基本檢測結果
    let detectedFaces: Int
    let primaryEmotions: [EmotionState]
    let emotionConfidence: Double
    let developmentStage: DevelopmentStage
    
    // 詳細分析
    let motorDevelopment: MotorDevelopmentAssessment
    let cognitiveDevelopment: CognitiveDevelopmentAssessment
    
    // 健康指標
    let overallHealthScore: Double        // 整體健康評分 (0-100)
    let growthIndicators: [String]        // 成長指標
    let potentialConcerns: [String]       // 潛在關注點
    
    // AI建議
    let recommendations: [String]         // 育兒建議
    let nextMilestones: [String]         // 下一個預期里程碑
    let parentingTips: [String]          // 育兒小貼士
    
    // 分析信心度
    let analysisConfidence: Double        // 分析信心度 (0-1)
    let dataQuality: DataQuality          // 數據質量
    
    enum DataQuality: String, Codable, CaseIterable {
        case excellent = "excellent"
        case good = "good"
        case fair = "fair"
        case poor = "poor"
        
        var displayName: String {
            switch self {
            case .excellent: return "優秀"
            case .good: return "良好"
            case .fair: return "一般"
            case .poor: return "較差"
            }
        }
        
        var color: UIColor {
            switch self {
            case .excellent: return .systemGreen
            case .good: return .systemBlue
            case .fair: return .systemOrange
            case .poor: return .systemRed
            }
        }
    }
    
    // 計算整體發展評分
    var overallDevelopmentScore: Double {
        let motorAverage = (motorDevelopment.grossMotor.score + 
                           motorDevelopment.fineMotor.score + 
                           motorDevelopment.coordination.score + 
                           motorDevelopment.balance.score) / 4.0
        
        let cognitiveAverage = (cognitiveDevelopment.attention.score + 
                               cognitiveDevelopment.socialInteraction.score + 
                               cognitiveDevelopment.languageReadiness.score + 
                               cognitiveDevelopment.problemSolving.score) / 4.0
        
        return (Double(motorAverage) + Double(cognitiveAverage)) / 2.0 * 25.0 // 轉換為0-100分制
    }
}

// MARK: - 媒體項目
struct MediaItem: Codable {
    let id: UUID
    let filename: String
    let type: MediaType
    let createdAt: Date
    let fileSize: Int64
    let thumbnailPath: String?
    var analysisStatus: AnalysisStatus
    var analysisResult: GAIAnalysisResult?
    let babyAge: Int? // 寶寶年齡（月數）
    var tags: [String]
    var isFavorite: Bool
    
    init(filename: String, type: MediaType, fileSize: Int64, babyAge: Int? = nil) {
        self.id = UUID()
        self.filename = filename
        self.type = type
        self.createdAt = Date()
        self.fileSize = fileSize
        self.thumbnailPath = nil
        self.analysisStatus = .pending
        self.analysisResult = nil
        self.babyAge = babyAge
        self.tags = []
        self.isFavorite = false
    }
    
    // 獲取文件URL
    func getFileURL() -> URL {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent("media").appendingPathComponent(filename)
    }
    
    // 獲取縮略圖URL
    func getThumbnailURL() -> URL? {
        guard let thumbnailPath = thumbnailPath else { return nil }
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsPath.appendingPathComponent("thumbnails").appendingPathComponent(thumbnailPath)
    }
}

// MARK: - GAI分析報告
struct GAIAnalysisReport: Codable {
    let id: UUID
    let generatedAt: Date
    let reportPeriod: DateInterval
    let mediaItems: [UUID] // 包含的媒體項目ID
    
    // 彙總統計
    let totalAnalyses: Int
    let averageDevelopmentScore: Double
    let emotionDistribution: [EmotionState: Double]
    let developmentProgress: DevelopmentProgress
    
    // 趨勢分析
    let growthTrends: [String]
    let improvementAreas: [String]
    let concernAreas: [String]
    
    // 建議摘要
    let keyRecommendations: [String]
    let upcomingMilestones: [String]
    
    struct DevelopmentProgress: Codable {
        let motorSkills: Double      // 運動技能進步 (-1 to 1)
        let cognitiveSkills: Double  // 認知技能進步 (-1 to 1)
        let socialSkills: Double     // 社交技能進步 (-1 to 1)
        let overallProgress: Double  // 整體進步 (-1 to 1)
        
        func getProgressDescription(for skill: String) -> String {
            let value: Double
            switch skill {
            case "motor": value = motorSkills
            case "cognitive": value = cognitiveSkills
            case "social": value = socialSkills
            default: value = overallProgress
            }
            
            if value > 0.3 {
                return "顯著進步"
            } else if value > 0.1 {
                return "穩定進步"
            } else if value > -0.1 {
                return "維持穩定"
            } else if value > -0.3 {
                return "輕微退步"
            } else {
                return "需要關注"
            }
        }
        
        func getProgressColor(for skill: String) -> UIColor {
            let value: Double
            switch skill {
            case "motor": value = motorSkills
            case "cognitive": value = cognitiveSkills
            case "social": value = socialSkills
            default: value = overallProgress
            }
            
            if value > 0.1 {
                return .systemGreen
            } else if value > -0.1 {
                return .systemBlue
            } else {
                return .systemOrange
            }
        }
    }
} 