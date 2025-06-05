import UIKit

class GAIAnalysisResultViewController: UIViewController {
    
    private let mediaItem: MediaItem
    private let analysisResult: GAIAnalysisResult
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.CornerRadius.medium
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let headerInfoView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryColor
        view.layer.cornerRadius = Constants.CornerRadius.medium
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.extraLargeTitle)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scoreDescLabel: UILabel = {
        let label = UILabel()
        label.text = "整體發展評分"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.secondary)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 情緒分析區域
    private let emotionSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.large
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emotionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "😊 情緒分析"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.title2)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emotionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Spacing.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // 運動發展區域
    private let motorSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.large
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let motorTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🏃‍♂️ 運動發展"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.title2)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 認知發展區域
    private let cognitiveSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.large
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cognitiveTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "🧠 認知發展"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.title2)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 建議區域
    private let recommendationSectionView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.large
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let recommendationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "💡 AI建議"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.title2)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initialization
    init(mediaItem: MediaItem, analysisResult: GAIAnalysisResult) {
        self.mediaItem = mediaItem
        self.analysisResult = analysisResult
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "AI分析結果"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissTapped)
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "分享",
            style: .plain,
            target: self,
            action: #selector(shareTapped)
        )
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroundColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加所有區域
        contentView.addSubview(headerImageView)
        contentView.addSubview(headerInfoView)
        contentView.addSubview(emotionSectionView)
        contentView.addSubview(motorSectionView)
        contentView.addSubview(cognitiveSectionView)
        contentView.addSubview(recommendationSectionView)
        
        // Header info 內容
        headerInfoView.addSubview(scoreLabel)
        headerInfoView.addSubview(scoreDescLabel)
        headerInfoView.addSubview(stageLabel)
        
        // 情緒區域內容
        emotionSectionView.addSubview(emotionTitleLabel)
        emotionSectionView.addSubview(emotionStackView)
        
        // 運動發展區域內容
        motorSectionView.addSubview(motorTitleLabel)
        
        // 認知發展區域內容
        cognitiveSectionView.addSubview(cognitiveTitleLabel)
        
        // 建議區域內容
        recommendationSectionView.addSubview(recommendationTitleLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Scroll View
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header Image
            headerImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Spacing.large),
            headerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            headerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            headerImageView.heightAnchor.constraint(equalToConstant: 200),
            
            // Header Info
            headerInfoView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: Constants.Spacing.large),
            headerInfoView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            headerInfoView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            headerInfoView.heightAnchor.constraint(equalToConstant: 120),
            
            scoreLabel.topAnchor.constraint(equalTo: headerInfoView.topAnchor, constant: Constants.Spacing.medium),
            scoreLabel.centerXAnchor.constraint(equalTo: headerInfoView.centerXAnchor),
            
            scoreDescLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: Constants.Spacing.small),
            scoreDescLabel.centerXAnchor.constraint(equalTo: headerInfoView.centerXAnchor),
            
            stageLabel.topAnchor.constraint(equalTo: scoreDescLabel.bottomAnchor, constant: Constants.Spacing.small),
            stageLabel.centerXAnchor.constraint(equalTo: headerInfoView.centerXAnchor),
            stageLabel.bottomAnchor.constraint(equalTo: headerInfoView.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // Emotion Section
            emotionSectionView.topAnchor.constraint(equalTo: headerInfoView.bottomAnchor, constant: Constants.Spacing.large),
            emotionSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            emotionSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            emotionTitleLabel.topAnchor.constraint(equalTo: emotionSectionView.topAnchor, constant: Constants.Spacing.large),
            emotionTitleLabel.leadingAnchor.constraint(equalTo: emotionSectionView.leadingAnchor, constant: Constants.Spacing.large),
            emotionTitleLabel.trailingAnchor.constraint(equalTo: emotionSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            
            emotionStackView.topAnchor.constraint(equalTo: emotionTitleLabel.bottomAnchor, constant: Constants.Spacing.large),
            emotionStackView.leadingAnchor.constraint(equalTo: emotionSectionView.leadingAnchor, constant: Constants.Spacing.large),
            emotionStackView.trailingAnchor.constraint(equalTo: emotionSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            emotionStackView.bottomAnchor.constraint(equalTo: emotionSectionView.bottomAnchor, constant: -Constants.Spacing.large),
            emotionStackView.heightAnchor.constraint(equalToConstant: 80),
            
            // Motor Section
            motorSectionView.topAnchor.constraint(equalTo: emotionSectionView.bottomAnchor, constant: Constants.Spacing.large),
            motorSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            motorSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            motorTitleLabel.topAnchor.constraint(equalTo: motorSectionView.topAnchor, constant: Constants.Spacing.large),
            motorTitleLabel.leadingAnchor.constraint(equalTo: motorSectionView.leadingAnchor, constant: Constants.Spacing.large),
            motorTitleLabel.trailingAnchor.constraint(equalTo: motorSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // Cognitive Section
            cognitiveSectionView.topAnchor.constraint(equalTo: motorSectionView.bottomAnchor, constant: Constants.Spacing.large),
            cognitiveSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            cognitiveSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            cognitiveTitleLabel.topAnchor.constraint(equalTo: cognitiveSectionView.topAnchor, constant: Constants.Spacing.large),
            cognitiveTitleLabel.leadingAnchor.constraint(equalTo: cognitiveSectionView.leadingAnchor, constant: Constants.Spacing.large),
            cognitiveTitleLabel.trailingAnchor.constraint(equalTo: cognitiveSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // Recommendation Section
            recommendationSectionView.topAnchor.constraint(equalTo: cognitiveSectionView.bottomAnchor, constant: Constants.Spacing.large),
            recommendationSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            recommendationSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            recommendationSectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.large),
            
            recommendationTitleLabel.topAnchor.constraint(equalTo: recommendationSectionView.topAnchor, constant: Constants.Spacing.large),
            recommendationTitleLabel.leadingAnchor.constraint(equalTo: recommendationSectionView.leadingAnchor, constant: Constants.Spacing.large),
            recommendationTitleLabel.trailingAnchor.constraint(equalTo: recommendationSectionView.trailingAnchor, constant: -Constants.Spacing.large)
        ])
    }
    
    private func configureContent() {
        // 設置圖片
        if let image = MediaManager.shared.getImage(for: mediaItem) {
            headerImageView.image = image
        } else if let thumbnail = MediaManager.shared.getThumbnail(for: mediaItem) {
            headerImageView.image = thumbnail
        }
        
        // 設置評分
        let score = Int(analysisResult.overallDevelopmentScore)
        scoreLabel.text = "\(score)"
        stageLabel.text = analysisResult.developmentStage.displayName
        
        // 設置情緒
        configureEmotionSection()
        
        // 設置運動發展
        configureMotorSection()
        
        // 設置認知發展
        configureCognitiveSection()
        
        // 設置建議
        configureRecommendationSection()
    }
    
    private func configureEmotionSection() {
        // 清空已有視圖
        emotionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for emotion in analysisResult.primaryEmotions {
            let emotionView = createEmotionView(emotion: emotion)
            emotionStackView.addArrangedSubview(emotionView)
        }
    }
    
    private func createEmotionView(emotion: EmotionState) -> UIView {
        let container = UIView()
        container.backgroundColor = emotion.color.withAlphaComponent(0.1)
        container.layer.cornerRadius = Constants.CornerRadius.medium
        container.layer.borderWidth = 2
        container.layer.borderColor = emotion.color.cgColor
        
        let emojiLabel = UILabel()
        emojiLabel.text = emotion.emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 24)
        emojiLabel.textAlignment = .center
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nameLabel = UILabel()
        nameLabel.text = emotion.displayName
        nameLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.caption, weight: .medium)
        nameLabel.textColor = emotion.color
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(emojiLabel)
        container.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.Spacing.small),
            emojiLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: emojiLabel.bottomAnchor, constant: Constants.Spacing.extraSmall),
            nameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -Constants.Spacing.small)
        ])
        
        return container
    }
    
    private func configureMotorSection() {
        let motor = analysisResult.motorDevelopment
        
        // 創建技能評估視圖
        let skillsView = createSkillsAssessmentView(
            skills: [
                ("大肌肉", motor.grossMotor.displayName, motor.grossMotor.color),
                ("精細運動", motor.fineMotor.displayName, motor.fineMotor.color),
                ("協調性", motor.coordination.displayName, motor.coordination.color),
                ("平衡感", motor.balance.displayName, motor.balance.color)
            ]
        )
        
        motorSectionView.addSubview(skillsView)
        
        // 添加檢測到的活動
        let activitiesLabel = createInfoLabel(title: "檢測到的活動", items: motor.detectedActivities)
        motorSectionView.addSubview(activitiesLabel)
        
        NSLayoutConstraint.activate([
            skillsView.topAnchor.constraint(equalTo: motorTitleLabel.bottomAnchor, constant: Constants.Spacing.large),
            skillsView.leadingAnchor.constraint(equalTo: motorSectionView.leadingAnchor, constant: Constants.Spacing.large),
            skillsView.trailingAnchor.constraint(equalTo: motorSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            skillsView.heightAnchor.constraint(equalToConstant: 100),
            
            activitiesLabel.topAnchor.constraint(equalTo: skillsView.bottomAnchor, constant: Constants.Spacing.large),
            activitiesLabel.leadingAnchor.constraint(equalTo: motorSectionView.leadingAnchor, constant: Constants.Spacing.large),
            activitiesLabel.trailingAnchor.constraint(equalTo: motorSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            activitiesLabel.bottomAnchor.constraint(equalTo: motorSectionView.bottomAnchor, constant: -Constants.Spacing.large)
        ])
    }
    
    private func configureCognitiveSection() {
        let cognitive = analysisResult.cognitiveDevelopment
        
        // 創建技能評估視圖
        let skillsView = createSkillsAssessmentView(
            skills: [
                ("注意力", cognitive.attention.displayName, cognitive.attention.color),
                ("社交互動", cognitive.socialInteraction.displayName, cognitive.socialInteraction.color),
                ("語言準備", cognitive.languageReadiness.displayName, cognitive.languageReadiness.color),
                ("問題解決", cognitive.problemSolving.displayName, cognitive.problemSolving.color)
            ]
        )
        
        cognitiveSectionView.addSubview(skillsView)
        
        // 添加觀察到的行為
        let behaviorsLabel = createInfoLabel(title: "觀察到的行為", items: cognitive.observedBehaviors)
        cognitiveSectionView.addSubview(behaviorsLabel)
        
        NSLayoutConstraint.activate([
            skillsView.topAnchor.constraint(equalTo: cognitiveTitleLabel.bottomAnchor, constant: Constants.Spacing.large),
            skillsView.leadingAnchor.constraint(equalTo: cognitiveSectionView.leadingAnchor, constant: Constants.Spacing.large),
            skillsView.trailingAnchor.constraint(equalTo: cognitiveSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            skillsView.heightAnchor.constraint(equalToConstant: 100),
            
            behaviorsLabel.topAnchor.constraint(equalTo: skillsView.bottomAnchor, constant: Constants.Spacing.large),
            behaviorsLabel.leadingAnchor.constraint(equalTo: cognitiveSectionView.leadingAnchor, constant: Constants.Spacing.large),
            behaviorsLabel.trailingAnchor.constraint(equalTo: cognitiveSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            behaviorsLabel.bottomAnchor.constraint(equalTo: cognitiveSectionView.bottomAnchor, constant: -Constants.Spacing.large)
        ])
    }
    
    private func configureRecommendationSection() {
        var previousView: UIView = recommendationTitleLabel
        
        // 育兒建議
        if !analysisResult.recommendations.isEmpty {
            let recommendationsView = createRecommendationView(title: "💡 育兒建議", items: analysisResult.recommendations)
            recommendationSectionView.addSubview(recommendationsView)
            
            NSLayoutConstraint.activate([
                recommendationsView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.Spacing.large),
                recommendationsView.leadingAnchor.constraint(equalTo: recommendationSectionView.leadingAnchor, constant: Constants.Spacing.large),
                recommendationsView.trailingAnchor.constraint(equalTo: recommendationSectionView.trailingAnchor, constant: -Constants.Spacing.large)
            ])
            previousView = recommendationsView
        }
        
        // 下一個里程碑
        if !analysisResult.nextMilestones.isEmpty {
            let milestonesView = createRecommendationView(title: "🎯 下一個里程碑", items: analysisResult.nextMilestones)
            recommendationSectionView.addSubview(milestonesView)
            
            NSLayoutConstraint.activate([
                milestonesView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.Spacing.large),
                milestonesView.leadingAnchor.constraint(equalTo: recommendationSectionView.leadingAnchor, constant: Constants.Spacing.large),
                milestonesView.trailingAnchor.constraint(equalTo: recommendationSectionView.trailingAnchor, constant: -Constants.Spacing.large)
            ])
            previousView = milestonesView
        }
        
        // 育兒小貼士
        if !analysisResult.parentingTips.isEmpty {
            let tipsView = createRecommendationView(title: "📝 育兒小貼士", items: analysisResult.parentingTips)
            recommendationSectionView.addSubview(tipsView)
            
            NSLayoutConstraint.activate([
                tipsView.topAnchor.constraint(equalTo: previousView.bottomAnchor, constant: Constants.Spacing.large),
                tipsView.leadingAnchor.constraint(equalTo: recommendationSectionView.leadingAnchor, constant: Constants.Spacing.large),
                tipsView.trailingAnchor.constraint(equalTo: recommendationSectionView.trailingAnchor, constant: -Constants.Spacing.large),
                tipsView.bottomAnchor.constraint(equalTo: recommendationSectionView.bottomAnchor, constant: -Constants.Spacing.large)
            ])
        } else {
            previousView.bottomAnchor.constraint(equalTo: recommendationSectionView.bottomAnchor, constant: -Constants.Spacing.large).isActive = true
        }
    }
    
    private func createSkillsAssessmentView(skills: [(String, String, UIColor)]) -> UIView {
        let container = UIView()
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Spacing.small
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        for (name, level, color) in skills {
            let skillView = createSkillView(name: name, level: level, color: color)
            stackView.addArrangedSubview(skillView)
        }
        
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: container.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    private func createSkillView(name: String, level: String, color: UIColor) -> UIView {
        let container = UIView()
        container.backgroundColor = color.withAlphaComponent(0.1)
        container.layer.cornerRadius = Constants.CornerRadius.medium
        container.layer.borderWidth = 1
        container.layer.borderColor = color.cgColor
        
        let nameLabel = UILabel()
        nameLabel.text = name
        nameLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.caption, weight: .medium)
        nameLabel.textColor = Constants.Colors.primaryTextColor
        nameLabel.textAlignment = .center
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let levelLabel = UILabel()
        levelLabel.text = level
        levelLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        levelLabel.textColor = color
        levelLabel.textAlignment = .center
        levelLabel.numberOfLines = 2
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(nameLabel)
        container.addSubview(levelLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: Constants.Spacing.small),
            nameLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            levelLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Constants.Spacing.extraSmall),
            levelLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            levelLabel.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 4),
            levelLabel.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -4),
            levelLabel.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -Constants.Spacing.small)
        ])
        
        return container
    }
    
    private func createInfoLabel(title: String, items: [String]) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = Constants.Colors.primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let text = "\(title)：\n" + items.map { "• \($0)" }.joined(separator: "\n")
        label.text = text
        
        return label
    }
    
    private func createRecommendationView(title: String, items: [String]) -> UIView {
        let container = UIView()
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.headline, weight: .semibold)
        titleLabel.textColor = Constants.Colors.primaryTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        contentLabel.textColor = Constants.Colors.primaryTextColor
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let text = items.map { "• \($0)" }.joined(separator: "\n")
        contentLabel.text = text
        
        container.addSubview(titleLabel)
        container.addSubview(contentLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Spacing.medium),
            contentLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }
    
    // MARK: - Actions
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
    
    @objc private func shareTapped() {
        let shareText = generateShareText()
        let activityController = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        
        if let popover = activityController.popoverPresentationController {
            popover.barButtonItem = navigationItem.leftBarButtonItem
        }
        
        present(activityController, animated: true)
    }
    
    private func generateShareText() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        var text = "🍼 寶寶AI分析報告\n\n"
        text += "📅 分析時間：\(formatter.string(from: analysisResult.timestamp))\n"
        text += "🎯 發展階段：\(analysisResult.developmentStage.displayName)\n"
        text += "📊 整體評分：\(Int(analysisResult.overallDevelopmentScore))分\n\n"
        
        text += "😊 情緒狀態：\(analysisResult.primaryEmotions.map { $0.displayName }.joined(separator: "、"))\n\n"
        
        if !analysisResult.recommendations.isEmpty {
            text += "💡 AI建議：\n"
            for recommendation in analysisResult.recommendations {
                text += "• \(recommendation)\n"
            }
        }
        
        text += "\n🏷️ #寶寶成長記錄 #AI分析 #智能育兒"
        
        return text
    }
} 