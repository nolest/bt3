import UIKit
import AVFoundation

class PhotosViewController: UIViewController {
    
    private let mediaManager = MediaManager.shared
    private let gaiAnalysisService = GAIAnalysisService.shared
    
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
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Colors.primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "智能相冊"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.largeTitle)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "AI智慧分析寶寶成長記錄"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statsCardView: UIView = {
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
    
    private let totalItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.largeTitle)
        label.textColor = Constants.Colors.primaryColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let totalItemsDescLabel: UILabel = {
        let label = UILabel()
        label.text = "總數"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.secondary)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let analyzedItemsLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFont(ofSize: Constants.FontSize.largeTitle)
        label.textColor = Constants.Colors.successColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let analyzedItemsDescLabel: UILabel = {
        let label = UILabel()
        label.text = "已分析"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.secondary)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let quotaLabel: UILabel = {
        let label = UILabel()
        label.text = "配額：10/10"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = Constants.Spacing.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📷 拍照", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryColor
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🖼️ 選擇", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.secondaryColor
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let generateReportButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📊 分析報告", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.infoColor
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let mediaCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.minimumInteritemSpacing = Constants.Spacing.medium
        layout.minimumLineSpacing = Constants.Spacing.medium
        layout.sectionInset = UIEdgeInsets(top: Constants.Spacing.medium, 
                                          left: Constants.Spacing.medium, 
                                          bottom: Constants.Spacing.medium, 
                                          right: Constants.Spacing.medium)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var mediaItems: [MediaItem] = []
    private let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupActions()
        loadMediaItems()
        updateQuotaDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshData()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroundColor
        title = "智能相冊"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Header
        contentView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        // Stats Card
        contentView.addSubview(statsCardView)
        
        let totalStack = UIStackView(arrangedSubviews: [totalItemsLabel, totalItemsDescLabel])
        totalStack.axis = .vertical
        totalStack.spacing = 4
        totalStack.translatesAutoresizingMaskIntoConstraints = false
        
        let analyzedStack = UIStackView(arrangedSubviews: [analyzedItemsLabel, analyzedItemsDescLabel])
        analyzedStack.axis = .vertical
        analyzedStack.spacing = 4
        analyzedStack.translatesAutoresizingMaskIntoConstraints = false
        
        let statsStack = UIStackView(arrangedSubviews: [totalStack, analyzedStack])
        statsStack.axis = .horizontal
        statsStack.distribution = .fillEqually
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        
        statsCardView.addSubview(statsStack)
        statsCardView.addSubview(quotaLabel)
        
        // Action Buttons
        actionButtonsStackView.addArrangedSubview(takePhotoButton)
        actionButtonsStackView.addArrangedSubview(selectPhotoButton)
        actionButtonsStackView.addArrangedSubview(generateReportButton)
        contentView.addSubview(actionButtonsStackView)
        
        // Collection View
        contentView.addSubview(mediaCollectionView)
        
        // Constraints
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
            
            // Header
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Constants.Spacing.large),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.Spacing.large),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Spacing.small),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // Stats Card
            statsCardView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.Spacing.large),
            statsCardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            statsCardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            statsCardView.heightAnchor.constraint(equalToConstant: 120),
            
            statsStack.topAnchor.constraint(equalTo: statsCardView.topAnchor, constant: Constants.Spacing.medium),
            statsStack.leadingAnchor.constraint(equalTo: statsCardView.leadingAnchor, constant: Constants.Spacing.medium),
            statsStack.trailingAnchor.constraint(equalTo: statsCardView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            quotaLabel.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: Constants.Spacing.small),
            quotaLabel.centerXAnchor.constraint(equalTo: statsCardView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
} 