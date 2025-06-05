import UIKit
import AVFoundation
import Dispatch

// 显式声明 AnalysisStatus 枚举以解决"Cannot infer contextual base"错误
enum AnalysisStatus {
    case pending
    case processing
    case completed
    case failed
}

// 模拟 MediaItem 类
class MediaItem {
    var id = UUID()
    var analysisStatus: AnalysisStatus = .pending
    var analysisResult: Any? = nil
    
    static func == (lhs: MediaItem, rhs: MediaItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// 模拟 MediaManager 类
class MediaManager {
    // 移除 shared 静态属性，允许直接实例化
    
    func getAllMediaItems() -> [MediaItem] {
        return [] // 模拟空列表
    }
    
    func getMediaStatistics() -> MockMediaStatistics {
        return MockMediaStatistics(totalItems: 0, analyzedCount: 0)
    }
    
    func updateMediaItem(_ item: MediaItem) {
        // 模拟更新方法
    }
    
    func saveImage(_ image: UIImage, completion: @escaping (Result<MediaItem, Error>) -> Void) {
        // 模拟保存图片方法
        let item = MediaItem()
        completion(.success(item))
    }
}

// 模拟 MediaStatistics 结构体，添加 Mock 前缀以避免冲突
struct MockMediaStatistics {
    let totalItems: Int
    let analyzedCount: Int
}

// 模拟 GAIAnalysisService 类
class GAIAnalysisService {
    // 移除 shared 静态属性，允许直接实例化
    
    func getQuotaStatus() -> MockGAIQuotaStatus {
        return MockGAIQuotaStatus(dailyLimit: 10, dailyRemaining: 5, canAnalyze: true)
    }
    
    func analyzeMedia(_ mediaItem: MediaItem, completion: @escaping (Result<Any, Error>) -> Void) {
        // 模拟分析方法
        completion(.success(mediaItem))
    }
    
    func generateReport(for items: [MediaItem], period: DateInterval) -> Any {
        // 模拟生成报告方法
        return items
    }
}

// 模拟 GAIQuotaStatus 结构体，添加 Mock 前缀以避免冲突
struct MockGAIQuotaStatus {
    let dailyLimit: Int
    let dailyRemaining: Int
    let canAnalyze: Bool
}

// 模拟 GAIAnalysisResultViewController 类
class GAIAnalysisResultViewController: UIViewController {
    init(mediaItem: MediaItem, analysisResult: Any) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 模拟 GAIReportViewController 类
class GAIReportViewController: UIViewController {
    init(report: Any) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 模拟 MediaDetailViewController 类
class MediaDetailViewController: UIViewController {
    init(mediaItem: MediaItem) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// 定义 MediaItemCell 类以解决编译问题
class MediaItemCell: UICollectionViewCell {
    var onAnalyzeTapped: (() -> Void)?
    var onFavoriteTapped: (() -> Void)?
    
    func configure(with mediaItem: MediaItem) {
        // 在这里模拟 configure 方法的实现
    }
}

// 移除了重复的 Constants 定义

class PhotosViewController: UIViewController {
    
    // 直接创建实例以避免 .shared 未找到的问题
    private let mediaManager = MediaManager()
    private let gaiAnalysisService = GAIAnalysisService()
    
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
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "還沒有照片，開始記錄寶寶的珍貴時刻吧！"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        contentView.addSubview(messageLabel)
        
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
            
            // Action Buttons
            actionButtonsStackView.topAnchor.constraint(equalTo: statsCardView.bottomAnchor, constant: Constants.Spacing.large),
            actionButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            actionButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            actionButtonsStackView.heightAnchor.constraint(equalToConstant: 44),
            
            // Collection View
            mediaCollectionView.topAnchor.constraint(equalTo: actionButtonsStackView.bottomAnchor, constant: Constants.Spacing.large),
            mediaCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mediaCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mediaCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            mediaCollectionView.heightAnchor.constraint(equalToConstant: 400),
            
            // Message Label
            messageLabel.centerXAnchor.constraint(equalTo: mediaCollectionView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: mediaCollectionView.centerYAnchor),
            messageLabel.leadingAnchor.constraint(greaterThanOrEqualTo: mediaCollectionView.leadingAnchor, constant: Constants.Spacing.large),
            messageLabel.trailingAnchor.constraint(lessThanOrEqualTo: mediaCollectionView.trailingAnchor, constant: -Constants.Spacing.large)
        ])
    }
    
    private func setupCollectionView() {
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        mediaCollectionView.register(MediaItemCell.self, forCellWithReuseIdentifier: "MediaItemCell")
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    private func setupActions() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
        selectPhotoButton.addTarget(self, action: #selector(selectPhotoTapped), for: .touchUpInside)
        generateReportButton.addTarget(self, action: #selector(generateReportTapped), for: .touchUpInside)
    }
    
    private func loadMediaItems() {
        mediaItems = mediaManager.getAllMediaItems()
        updateUI()
    }
    
    private func refreshData() {
        loadMediaItems()
        updateQuotaDisplay()
    }
    
    private func updateQuotaDisplay() {
        let quotaStatus = gaiAnalysisService.getQuotaStatus()
        quotaLabel.text = "今日配額：\(quotaStatus.dailyRemaining)/\(quotaStatus.dailyLimit)"
        
        if !quotaStatus.canAnalyze {
            quotaLabel.textColor = Constants.Colors.errorColor
        } else {
            quotaLabel.textColor = Constants.Colors.secondaryTextColor
        }
    }
    
    private func updateUI() {
        // 创建一个 DispatchWorkItem 来解决类型问题
        let updateWork = DispatchWorkItem {
            let statistics = self.mediaManager.getMediaStatistics()
            
            self.totalItemsLabel.text = "\(statistics.totalItems)"
            self.analyzedItemsLabel.text = "\(statistics.analyzedCount)"
            
            self.messageLabel.isHidden = !self.mediaItems.isEmpty
            self.mediaCollectionView.reloadData()
        }
        
        DispatchQueue.main.async(execute: updateWork)
    }
    
    // MARK: - Actions
    @objc private func takePhotoTapped() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            showAlert(title: "相機不可用", message: "您的設備不支持相機功能")
            return
        }
        
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @objc private func selectPhotoTapped() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    @objc private func generateReportTapped() {
        let analyzedItems = mediaItems.filter { $0.analysisStatus == .completed }
        
        guard !analyzedItems.isEmpty else {
            showAlert(title: "無法生成報告", message: "請先對照片進行AI分析")
            return
        }
        
        let now = Date()
        let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
        let period = DateInterval(start: weekAgo, end: now)
        
        let report = gaiAnalysisService.generateReport(for: analyzedItems, period: period)
        
        let reportVC = GAIReportViewController(report: report)
        let navController = UINavigationController(rootViewController: reportVC)
        present(navController, animated: true)
    }
    
    private func analyzeMediaItem(_ mediaItem: MediaItem) {
        guard let index = mediaItems.firstIndex(where: { $0.id == mediaItem.id }) else { return }
        
        // 更新狀態為處理中
        mediaItems[index].analysisStatus = .processing
        mediaManager.updateMediaItem(mediaItems[index])
        
        // 创建一个 DispatchWorkItem 来解决类型问题
        let updateWork = DispatchWorkItem {
            self.mediaCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
        }
        
        DispatchQueue.main.async(execute: updateWork)
        
        // 開始分析
        gaiAnalysisService.analyzeMedia(mediaItem) { [weak self] result in
            guard let self = self else { return }
            
            // 创建一个 DispatchWorkItem 来解决类型问题
            let updateWork = DispatchWorkItem {
                if case .success(let analysisResult) = result {
                    self.mediaItems[index].analysisStatus = .completed
                    self.mediaItems[index].analysisResult = analysisResult
                    self.mediaManager.updateMediaItem(self.mediaItems[index])
                    
                    self.updateUI()
                    self.updateQuotaDisplay()
                    
                    self.showAlert(title: "分析完成", message: "AI分析已完成，點擊查看結果！")
                } else {
                    // 模拟错误情况
                    let error = NSError(domain: "AI分析", code: 0, userInfo: [NSLocalizedDescriptionKey: "分析失败"])
                    self.mediaItems[index].analysisStatus = .failed
                    self.mediaManager.updateMediaItem(self.mediaItems[index])
                    
                    self.mediaCollectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
                    
                    self.showAlert(title: "分析失敗", message: error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async(execute: updateWork)
        }
    }
    
    private func showAnalysisResult(for mediaItem: MediaItem) {
        guard let result = mediaItem.analysisResult else { return }
        
        let resultVC = GAIAnalysisResultViewController(mediaItem: mediaItem, analysisResult: result)
        let navController = UINavigationController(rootViewController: resultVC)
        present(navController, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 使用正确的强制类型转换来解决类型推断问题
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MediaItemCell", for: indexPath) as! MediaItemCell
        let mediaItem = mediaItems[indexPath.item]
        
        cell.configure(with: mediaItem)
        
        // 使用明确的类型声明来帮助编译器进行类型推断
        cell.onAnalyzeTapped = { [weak self] () -> Void in
            guard let self = self else { return }
            let item = self.mediaItems[indexPath.item]
            
            // 使用明确的枚举值
            if item.analysisStatus == AnalysisStatus.pending || item.analysisStatus == AnalysisStatus.failed {
                self.analyzeMediaItem(item)
            } else if item.analysisStatus == AnalysisStatus.completed {
                self.showAnalysisResult(for: item)
            }
        }
        
        cell.onFavoriteTapped = { [weak self] () -> Void in
            self?.updateUI()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let mediaItem = mediaItems[indexPath.item]
        let detailVC = MediaDetailViewController(mediaItem: mediaItem)
        let navController = UINavigationController(rootViewController: detailVC)
        present(navController, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage else {
            showAlert(title: "錯誤", message: "無法獲取選中的圖片")
            return
        }
        
        mediaManager.saveImage(image) { [weak self] result in
            // 创建一个 DispatchWorkItem 来解决类型问题
            let updateWork = DispatchWorkItem {
                if case .success = result {
                    self?.refreshData()
                    self?.showAlert(title: "保存成功", message: "照片已保存到智能相冊")
                } else {
                    // 模拟错误情况
                    let error = NSError(domain: "保存图片", code: 0, userInfo: [NSLocalizedDescriptionKey: "保存失败"])
                    self?.showAlert(title: "保存失敗", message: error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async(execute: updateWork)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 