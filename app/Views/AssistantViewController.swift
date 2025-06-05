import UIKit

class AssistantViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryColor
        view.layer.cornerRadius = Constants.CornerRadius.large
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let assistantImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "wand.and.stars.inverse")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "您好，我是您的智慧育兒助理"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.title2, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "我可以幫助您解答育兒問題，提供建議，並分析寶寶的發展情況"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recentQuestionsLabel: UILabel = {
        let label = UILabel()
        label.text = "常見問題"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.headline, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let recentQuestionsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Spacing.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let aiAnalysisLabel: UILabel = {
        let label = UILabel()
        label.text = "智能分析"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.headline, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let aiAnalysisCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Spacing.medium
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.Spacing.medium, bottom: 0, right: Constants.Spacing.medium)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AIAnalysisCell.self, forCellWithReuseIdentifier: "AIAnalysisCell")
        return collectionView
    }()
    
    private let askQuestionView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.medium
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let questionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "輸入您的育兒問題..."
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = Constants.Colors.primaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 模拟数据
    private let commonQuestions = [
        "寶寶3個月，晚上總是哭鬧，如何改善？",
        "4個月寶寶該添加輔食嗎？",
        "寶寶有點發熱，是否需要就醫？",
        "如何判斷寶寶是否吃飽？"
    ]
    
    private let aiAnalyses: [(title: String, description: String, icon: String)] = [
        ("睡眠分析", "寶寶的睡眠時間和質量分析", "bed.double.fill"),
        ("成長曲線", "根據身高體重的成長曲線分析", "chart.line.uptrend.xyaxis"),
        ("發展里程碑", "發展里程碑達成情況分析", "flag.fill"),
        ("餵養建議", "基於餵養記錄的個性化建議", "drop.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        setupViews()
        setupCommonQuestions()
        setupActions()
        
        aiAnalysisCollectionView.dataSource = self
        aiAnalysisCollectionView.delegate = self
    }
    
    private func setupViews() {
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加头部视图
        contentView.addSubview(headerView)
        headerView.addSubview(assistantImageView)
        headerView.addSubview(welcomeLabel)
        headerView.addSubview(descriptionLabel)
        
        // 添加常见问题部分
        contentView.addSubview(recentQuestionsLabel)
        contentView.addSubview(recentQuestionsStackView)
        
        // 添加AI分析部分
        contentView.addSubview(aiAnalysisLabel)
        contentView.addSubview(aiAnalysisCollectionView)
        
        // 添加提问视图
        view.addSubview(askQuestionView)
        askQuestionView.addSubview(questionTextField)
        askQuestionView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: askQuestionView.topAnchor),
            
            // 内容视图约束
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 头部视图约束
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Spacing.medium),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.medium),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.medium),
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            // 助理图像约束
            assistantImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            assistantImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            assistantImageView.widthAnchor.constraint(equalToConstant: 60),
            assistantImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // 欢迎标签约束
            welcomeLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Constants.Spacing.large),
            welcomeLabel.leadingAnchor.constraint(equalTo: assistantImageView.trailingAnchor, constant: Constants.Spacing.medium),
            welcomeLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            // 描述标签约束
            descriptionLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: Constants.Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: assistantImageView.trailingAnchor, constant: Constants.Spacing.medium),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.Spacing.medium),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // 常见问题标签约束
            recentQuestionsLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.Spacing.large),
            recentQuestionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            recentQuestionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 常见问题栈视图约束
            recentQuestionsStackView.topAnchor.constraint(equalTo: recentQuestionsLabel.bottomAnchor, constant: Constants.Spacing.medium),
            recentQuestionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            recentQuestionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // AI分析标签约束
            aiAnalysisLabel.topAnchor.constraint(equalTo: recentQuestionsStackView.bottomAnchor, constant: Constants.Spacing.large),
            aiAnalysisLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            aiAnalysisLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // AI分析集合视图约束
            aiAnalysisCollectionView.topAnchor.constraint(equalTo: aiAnalysisLabel.bottomAnchor, constant: Constants.Spacing.medium),
            aiAnalysisCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            aiAnalysisCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            aiAnalysisCollectionView.heightAnchor.constraint(equalToConstant: 150),
            aiAnalysisCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // 提问视图约束
            askQuestionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            askQuestionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            askQuestionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            askQuestionView.heightAnchor.constraint(equalToConstant: 60),
            
            // 问题文本字段约束
            questionTextField.leadingAnchor.constraint(equalTo: askQuestionView.leadingAnchor, constant: Constants.Spacing.large),
            questionTextField.centerYAnchor.constraint(equalTo: askQuestionView.centerYAnchor),
            questionTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -Constants.Spacing.medium),
            
            // 发送按钮约束
            sendButton.trailingAnchor.constraint(equalTo: askQuestionView.trailingAnchor, constant: -Constants.Spacing.large),
            sendButton.centerYAnchor.constraint(equalTo: askQuestionView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupCommonQuestions() {
        // 清除现有的问题
        recentQuestionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 添加常见问题
        for question in commonQuestions {
            let questionButton = createQuestionButton(title: question)
            recentQuestionsStackView.addArrangedSubview(questionButton)
        }
    }
    
    private func createQuestionButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.contentHorizontalAlignment = .left
        button.setTitleColor(Constants.Colors.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        button.backgroundColor = Constants.Colors.cardBackgroundColor
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.addTarget(self, action: #selector(questionButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    private func setupActions() {
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // 添加点击手势，用于关闭键盘
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func questionButtonTapped(_ sender: UIButton) {
        if let question = sender.title(for: .normal) {
            questionTextField.text = question
            sendButtonTapped()
        }
    }
    
    @objc private func sendButtonTapped() {
        guard let question = questionTextField.text, !question.isEmpty else { return }
        
        // 模拟发送问题到智能助理
        print("发送问题: \(question)")
        
        // 显示一个简单的回复
        let alertController = UIAlertController(title: "智慧助理回答", message: "感謝您的提問！我正在分析這個問題，請稍等片刻...\n\n基於您的問題，我建議您可以嘗試...", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "謝謝", style: .default))
        present(alertController, animated: true)
        
        // 清空输入框
        questionTextField.text = ""
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UICollectionViewDataSource
extension AssistantViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aiAnalyses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AIAnalysisCell", for: indexPath) as! AIAnalysisCell
        
        let analysis = aiAnalyses[indexPath.item]
        cell.configure(title: analysis.title, description: analysis.description, iconName: analysis.icon)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AssistantViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}

// MARK: - AIAnalysisCell
class AIAnalysisCell: UICollectionViewCell {
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.cardBackgroundColor
        view.layer.cornerRadius = Constants.CornerRadius.medium
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.layer.shadowOpacity = 0.1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.large),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Constants.Spacing.small)
        ])
    }
    
    func configure(title: String, description: String, iconName: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        iconImageView.image = UIImage(systemName: iconName)
    }
} 