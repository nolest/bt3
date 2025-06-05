import Foundation
import UIKit

// MARK: - GAI分析服务协议
protocol GAIAnalysisServiceProtocol {
    func analyzeMedia(_ mediaItem: MediaItem, completion: @escaping (Result<GAIAnalysisResult, GAIAnalysisError>) -> Void)
    func generateReport(for mediaItems: [MediaItem], period: DateInterval) -> GAIAnalysisReport
    func getQuotaStatus() -> GAIQuotaStatus
}

// MARK: - GAI分析错误
enum GAIAnalysisError: Error, LocalizedError {
    case invalidMedia
    case networkError
    case quotaExceeded
    case analysisTimeout
    case serverError(String)
    case unsupportedFormat
    
    var errorDescription: String? {
        switch self {
        case .invalidMedia:
            return "無效的媒體文件"
        case .networkError:
            return "網絡連接錯誤"
        case .quotaExceeded:
            return "分析配額已用完"
        case .analysisTimeout:
            return "分析超時"
        case .serverError(let message):
            return "服務器錯誤：\(message)"
        case .unsupportedFormat:
            return "不支持的文件格式"
        }
    }
}

// MARK: - GAI配額狀態
struct GAIQuotaStatus {
    let dailyLimit: Int
    let dailyUsed: Int
    let monthlyLimit: Int
    let monthlyUsed: Int
    let resetTime: Date
    
    var dailyRemaining: Int {
        return max(0, dailyLimit - dailyUsed)
    }
    
    var monthlyRemaining: Int {
        return max(0, monthlyLimit - monthlyUsed)
    }
    
    var canAnalyze: Bool {
        return dailyRemaining > 0 && monthlyRemaining > 0
    }
}

// MARK: - GAI分析服务实现
class GAIAnalysisService: GAIAnalysisServiceProtocol {
    static let shared = GAIAnalysisService()
    
    private let analysisQueue = DispatchQueue(label: "com.babytracker.analysis", qos: .userInitiated)
    private var analysisCache: [UUID: GAIAnalysisResult] = [:]
    
    // 模拟API配额
    private var dailyAnalysisCount = 0
    private var monthlyAnalysisCount = 0
    private let dailyLimit = 10
    private let monthlyLimit = 100
    
    private init() {
        loadAnalysisCache()
        loadQuotaStatus()
    }
    
    // MARK: - 主要分析方法
    func analyzeMedia(_ mediaItem: MediaItem, completion: @escaping (Result<GAIAnalysisResult, GAIAnalysisError>) -> Void) {
        // 检查配额
        let quotaStatus = getQuotaStatus()
        guard quotaStatus.canAnalyze else {
            completion(.failure(.quotaExceeded))
            return
        }
        
        // 检查是否已有缓存结果
        if let cachedResult = analysisCache[mediaItem.id] {
            completion(.success(cachedResult))
            return
        }
        
        // 异步执行分析
        analysisQueue.async { [weak self] in
            self?.performAnalysis(mediaItem) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let analysisResult):
                        // 缓存结果
                        self?.analysisCache[mediaItem.id] = analysisResult
                        self?.saveAnalysisCache()
                        
                        // 更新配额
                        self?.updateQuotaUsage()
                        
                        completion(.success(analysisResult))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // MARK: - 执行分析（模拟）
    private func performAnalysis(_ mediaItem: MediaItem, completion: @escaping (Result<GAIAnalysisResult, GAIAnalysisError>) -> Void) {
        // 模拟网络延迟
        DispatchQueue.global().asyncAfter(deadline: .now() + Double.random(in: 2...5)) {
            
            // 模拟偶发错误
            if Int.random(in: 1...10) == 1 {
                completion(.failure(.networkError))
                return
            }
            
            // 生成模拟分析结果
            let analysisResult = self.generateMockAnalysisResult(for: mediaItem)
            completion(.success(analysisResult))
        }
    }
    
    // MARK: - 生成模拟分析结果
    private func generateMockAnalysisResult(for mediaItem: MediaItem) -> GAIAnalysisResult {
        // 根据宝宝年龄确定发展阶段
        let developmentStage: DevelopmentStage
        if let age = mediaItem.babyAge {
            switch age {
            case 0...3: developmentStage = .newborn
            case 4...12: developmentStage = .infant
            case 13...36: developmentStage = .toddler
            default: developmentStage = .preschool
            }
        } else {
            developmentStage = .infant
        }
        
        // 生成随机但合理的情绪状态
        let emotions = generateRealisticEmotions()
        
        // 生成运动发展评估
        let motorDevelopment = generateMotorDevelopmentAssessment(for: developmentStage)
        
        // 生成认知发展评估
        let cognitiveDevelopment = generateCognitiveDevelopmentAssessment(for: developmentStage)
        
        // 生成健康指标和建议
        let healthScore = Double.random(in: 70...95)
        let recommendations = generateRecommendations(for: developmentStage, emotions: emotions)
        
        return GAIAnalysisResult(
            id: UUID(),
            mediaId: mediaItem.id,
            timestamp: Date(),
            analysisVersion: "1.0.0",
            detectedFaces: Int.random(in: 1...2),
            primaryEmotions: emotions,
            emotionConfidence: Double.random(in: 0.7...0.95),
            developmentStage: developmentStage,
            motorDevelopment: motorDevelopment,
            cognitiveDevelopment: cognitiveDevelopment,
            overallHealthScore: healthScore,
            growthIndicators: generateGrowthIndicators(for: developmentStage),
            potentialConcerns: generatePotentialConcerns(healthScore: healthScore),
            recommendations: recommendations.recommendations,
            nextMilestones: recommendations.milestones,
            parentingTips: recommendations.tips,
            analysisConfidence: Double.random(in: 0.75...0.92),
            dataQuality: [.excellent, .good, .fair].randomElement() ?? .good
        )
    }
    
    // MARK: - 生成具体评估内容
    private func generateRealisticEmotions() -> [EmotionState] {
        let primaryEmotion = EmotionState.allCases.randomElement()!
        var emotions = [primaryEmotion]
        
        // 30%概率添加第二种情绪
        if Bool.random() && Double.random(in: 0...1) < 0.3 {
            let secondaryEmotion = EmotionState.allCases.filter { $0 != primaryEmotion }.randomElement()!
            emotions.append(secondaryEmotion)
        }
        
        return emotions
    }
    
    private func generateMotorDevelopmentAssessment(for stage: DevelopmentStage) -> MotorDevelopmentAssessment {
        let skillLevels = MotorDevelopmentAssessment.MotorSkillLevel.allCases
        let activities = getMotorActivities(for: stage)
        let recommendations = getMotorRecommendations(for: stage)
        
        return MotorDevelopmentAssessment(
            grossMotor: skillLevels.randomElement()!,
            fineMotor: skillLevels.randomElement()!,
            coordination: skillLevels.randomElement()!,
            balance: skillLevels.randomElement()!,
            detectedActivities: Array(activities.shuffled().prefix(Int.random(in: 2...4))),
            recommendations: Array(recommendations.shuffled().prefix(Int.random(in: 2...3)))
        )
    }
    
    private func generateCognitiveDevelopmentAssessment(for stage: DevelopmentStage) -> CognitiveDevelopmentAssessment {
        let skillLevels = CognitiveDevelopmentAssessment.CognitiveSkillLevel.allCases
        let behaviors = getCognitiveBehaviors(for: stage)
        let milestones = getCognitiveMilestones(for: stage)
        
        return CognitiveDevelopmentAssessment(
            attention: skillLevels.randomElement()!,
            socialInteraction: skillLevels.randomElement()!,
            languageReadiness: skillLevels.randomElement()!,
            problemSolving: skillLevels.randomElement()!,
            observedBehaviors: Array(behaviors.shuffled().prefix(Int.random(in: 2...4))),
            milestones: Array(milestones.shuffled().prefix(Int.random(in: 1...3)))
        )
    }
    
    // MARK: - 生成建议内容
    private func generateRecommendations(for stage: DevelopmentStage, emotions: [EmotionState]) -> (recommendations: [String], milestones: [String], tips: [String]) {
        let recommendations: [String]
        let milestones: [String]
        let tips: [String]
        
        switch stage {
        case .newborn:
            recommendations = [
                "多進行眼神接觸和說話",
                "提供充足的肌膚接觸",
                "建立規律的作息時間",
                "觀察寶寶的飢餓和疲勞信號"
            ]
            milestones = [
                "開始微笑回應",
                "頭部控制改善",
                "對聲音做出反應"
            ]
            tips = [
                "新生兒需要大量睡眠，每天16-20小時是正常的",
                "頻繁的餵食是正常的，新生兒每2-3小時需要餵食一次",
                "哭泣是寶寶唯一的溝通方式，要耐心回應"
            ]
            
        case .infant:
            recommendations = [
                "鼓勵翻身和爬行動作",
                "提供豐富的感官刺激",
                "進行簡單的手眼協調遊戲",
                "開始引入固體食物"
            ]
            milestones = [
                "獨立坐起",
                "開始爬行",
                "說出第一個字"
            ]
            tips = [
                "6個月開始添加輔食，一次只添加一種新食物",
                "建立睡前例行程序有助於改善睡眠質量",
                "多和寶寶說話，即使他們還不會回應"
            ]
            
        case .toddler:
            recommendations = [
                "鼓勵獨立行走和奔跑",
                "提供語言學習機會",
                "培養社交技能",
                "設定簡單的規則和界限"
            ]
            milestones = [
                "說出第一個完整句子",
                "學會使用餐具",
                "開始如廁訓練"
            ]
            tips = [
                "幼兒期是語言發展的關鍵時期，多讀書給孩子聽",
                "建立一致的日常例行程序",
                "耐心應對情緒爆發，這是正常的發展階段"
            ]
            
        case .preschool:
            recommendations = [
                "鼓勵創造性遊戲",
                "培養學前技能",
                "發展友誼關係",
                "準備入學準備"
            ]
            milestones = [
                "學會寫自己的名字",
                "能夠分離焦慮",
                "發展同理心"
            ]
            tips = [
                "鼓勵孩子表達自己的感受",
                "提供選擇的機會來培養獨立性",
                "準備學校環境的適應"
            ]
        }
        
        return (
            Array(recommendations.shuffled().prefix(3)),
            Array(milestones.shuffled().prefix(2)),
            Array(tips.shuffled().prefix(2))
        )
    }
    
    // MARK: - 輔助方法
    private func getMotorActivities(for stage: DevelopmentStage) -> [String] {
        switch stage {
        case .newborn:
            return ["頭部轉動", "手臂揮舞", "腿部踢動", "反射動作"]
        case .infant:
            return ["翻身", "坐立", "爬行", "抓握", "站立支撐"]
        case .toddler:
            return ["行走", "奔跑", "攀爬", "踢球", "投擲"]
        case .preschool:
            return ["跳躍", "平衡", "騎腳踏車", "畫畫", "剪紙"]
        }
    }
    
    private func getMotorRecommendations(for stage: DevelopmentStage) -> [String] {
        switch stage {
        case .newborn:
            return ["多做撫觸按摩", "進行適度的俯臥時間", "輕柔的肢體運動"]
        case .infant:
            return ["提供安全的爬行空間", "鼓勵抓握遊戲", "練習坐立平衡"]
        case .toddler:
            return ["戶外活動增加", "攀爬遊樂設施", "球類遊戲"]
        case .preschool:
            return ["精細動作練習", "體育活動參與", "手工藝製作"]
        }
    }
    
    private func getCognitiveBehaviors(for stage: DevelopmentStage) -> [String] {
        switch stage {
        case .newborn:
            return ["視覺追蹤", "聲音反應", "面部識別"]
        case .infant:
            return ["好奇心表現", "模仿行為", "物體永恆概念"]
        case .toddler:
            return ["語言表達", "問題解決", "想象遊戲"]
        case .preschool:
            return ["邏輯思維", "創意表達", "社交理解"]
        }
    }
    
    private func getCognitiveMilestones(for stage: DevelopmentStage) -> [String] {
        switch stage {
        case .newborn:
            return ["識別母親聲音", "對光線反應"]
        case .infant:
            return ["認識自己名字", "理解簡單指令"]
        case .toddler:
            return ["說出兩字詞組", "認識身體部位"]
        case .preschool:
            return ["數到十", "識別顏色"]
        }
    }
    
    private func generateGrowthIndicators(for stage: DevelopmentStage) -> [String] {
        let indicators = ["身高發育正常", "體重增長穩定", "頭圍發育良好", "肌肉張力適當"]
        return Array(indicators.shuffled().prefix(Int.random(in: 2...4)))
    }
    
    private func generatePotentialConcerns(healthScore: Double) -> [String] {
        if healthScore > 85 {
            return [] // 沒有關注點
        } else if healthScore > 75 {
            return ["建議增加互動時間"].shuffled()
        } else {
            return ["建議諮詢兒科醫生", "需要更多關注"].shuffled()
        }
    }
    
    // MARK: - 報告生成
    func generateReport(for mediaItems: [MediaItem], period: DateInterval) -> GAIAnalysisReport {
        let analyzedItems = mediaItems.filter { $0.analysisResult != nil }
        let results = analyzedItems.compactMap { $0.analysisResult }
        
        if results.isEmpty {
            return GAIAnalysisReport(
                id: UUID(),
                generatedAt: Date(),
                reportPeriod: period,
                mediaItems: [],
                totalAnalyses: 0,
                averageDevelopmentScore: 0,
                emotionDistribution: [:],
                developmentProgress: GAIAnalysisReport.DevelopmentProgress(
                    motorSkills: 0,
                    cognitiveSkills: 0,
                    socialSkills: 0,
                    overallProgress: 0
                ),
                growthTrends: [],
                improvementAreas: [],
                concernAreas: [],
                keyRecommendations: [],
                upcomingMilestones: []
            )
        }
        
        // 計算平均發展評分
        let averageScore = results.map { $0.overallDevelopmentScore }.reduce(0, +) / Double(results.count)
        
        // 計算情緒分佈
        var emotionCounts: [EmotionState: Int] = [:]
        for result in results {
            for emotion in result.primaryEmotions {
                emotionCounts[emotion, default: 0] += 1
            }
        }
        let totalEmotions = emotionCounts.values.reduce(0, +)
        let emotionDistribution: [EmotionState: Double] = emotionCounts.mapValues { Double($0) / Double(totalEmotions) }
        
        // 生成發展進步（模擬）
        let developmentProgress = GAIAnalysisReport.DevelopmentProgress(
            motorSkills: Double.random(in: -0.2...0.4),
            cognitiveSkills: Double.random(in: -0.1...0.5),
            socialSkills: Double.random(in: -0.15...0.3),
            overallProgress: Double.random(in: -0.1...0.35)
        )
        
        return GAIAnalysisReport(
            id: UUID(),
            generatedAt: Date(),
            reportPeriod: period,
            mediaItems: analyzedItems.map { $0.id },
            totalAnalyses: results.count,
            averageDevelopmentScore: averageScore,
            emotionDistribution: emotionDistribution,
            developmentProgress: developmentProgress,
            growthTrends: generateGrowthTrends(),
            improvementAreas: generateImprovementAreas(),
            concernAreas: generateConcernAreas(),
            keyRecommendations: generateKeyRecommendations(),
            upcomingMilestones: generateUpcomingMilestones()
        )
    }
    
    private func generateGrowthTrends() -> [String] {
        return ["情緒表達更加豐富", "運動協調性改善", "社交互動增加"].shuffled()
    }
    
    private func generateImprovementAreas() -> [String] {
        return ["語言發展", "精細動作", "注意力集中"].shuffled()
    }
    
    private func generateConcernAreas() -> [String] {
        let concerns = ["睡眠質量", "食慾狀況", "情緒波動"]
        return Int.random(in: 0...1) == 0 ? [] : Array(concerns.shuffled().prefix(1))
    }
    
    private func generateKeyRecommendations() -> [String] {
        return ["增加戶外活動時間", "建立規律作息", "多進行親子互動"].shuffled()
    }
    
    private func generateUpcomingMilestones() -> [String] {
        return ["學會新的動作技能", "語言能力提升", "社交技能發展"].shuffled()
    }
    
    // MARK: - 配額管理
    func getQuotaStatus() -> GAIQuotaStatus {
        return GAIQuotaStatus(
            dailyLimit: dailyLimit,
            dailyUsed: dailyAnalysisCount,
            monthlyLimit: monthlyLimit,
            monthlyUsed: monthlyAnalysisCount,
            resetTime: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        )
    }
    
    private func updateQuotaUsage() {
        dailyAnalysisCount += 1
        monthlyAnalysisCount += 1
        saveQuotaStatus()
    }
    
    // MARK: - 數據持久化
    private func loadAnalysisCache() {
        if let data = UserDefaults.standard.data(forKey: "GAIAnalysisCache"),
           let cache = try? JSONDecoder().decode([UUID: GAIAnalysisResult].self, from: data) {
            analysisCache = cache
        }
    }
    
    private func saveAnalysisCache() {
        if let data = try? JSONEncoder().encode(analysisCache) {
            UserDefaults.standard.set(data, forKey: "GAIAnalysisCache")
        }
    }
    
    private func loadQuotaStatus() {
        dailyAnalysisCount = UserDefaults.standard.integer(forKey: "GAIDailyCount")
        monthlyAnalysisCount = UserDefaults.standard.integer(forKey: "GAIMonthlyCount")
        
        // 檢查是否需要重置每日計數
        let lastResetDate = UserDefaults.standard.object(forKey: "GAILastResetDate") as? Date ?? Date.distantPast
        if !Calendar.current.isDate(lastResetDate, inSameDayAs: Date()) {
            dailyAnalysisCount = 0
            UserDefaults.standard.set(Date(), forKey: "GAILastResetDate")
        }
    }
    
    private func saveQuotaStatus() {
        UserDefaults.standard.set(dailyAnalysisCount, forKey: "GAIDailyCount")
        UserDefaults.standard.set(monthlyAnalysisCount, forKey: "GAIMonthlyCount")
    }
} 