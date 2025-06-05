import UIKit

class MediaItemCell: UICollectionViewCell {
    
    // MARK: - UI Components
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
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constants.CornerRadius.medium
        imageView.backgroundColor = Constants.Colors.lightBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let playIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle.fill")
        imageView.tintColor = .white
        imageView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        imageView.layer.cornerRadius = 15
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let statusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let typeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let analyzeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🔍 分析", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Constants.Colors.primaryColor
        button.layer.cornerRadius = Constants.CornerRadius.small
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.caption, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.tintColor = Constants.Colors.errorColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Properties
    private var mediaItem: MediaItem?
    var onAnalyzeTapped: (() -> Void)?
    var onFavoriteTapped: (() -> Void)?
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        playIconImageView.isHidden = true
        activityIndicator.stopAnimating()
        onAnalyzeTapped = nil
        onFavoriteTapped = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        contentView.addSubview(containerView)
        
        containerView.addSubview(thumbnailImageView)
        containerView.addSubview(playIconImageView)
        containerView.addSubview(statusView)
        containerView.addSubview(typeLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(analyzeButton)
        containerView.addSubview(favoriteButton)
        containerView.addSubview(activityIndicator)
        
        statusView.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            // Container View
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Thumbnail
            thumbnailImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.small),
            thumbnailImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Play Icon
            playIconImageView.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            playIconImageView.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor),
            playIconImageView.widthAnchor.constraint(equalToConstant: 30),
            playIconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            // Status View
            statusView.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: Constants.Spacing.small),
            statusView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: -Constants.Spacing.small),
            statusView.heightAnchor.constraint(equalToConstant: 20),
            statusView.widthAnchor.constraint(greaterThanOrEqualToConstant: 40),
            
            statusLabel.centerXAnchor.constraint(equalTo: statusView.centerXAnchor),
            statusLabel.centerYAnchor.constraint(equalTo: statusView.centerYAnchor),
            statusLabel.leadingAnchor.constraint(greaterThanOrEqualTo: statusView.leadingAnchor, constant: 6),
            statusLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusView.trailingAnchor, constant: -6),
            
            // Favorite Button
            favoriteButton.topAnchor.constraint(equalTo: thumbnailImageView.topAnchor, constant: Constants.Spacing.small),
            favoriteButton.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: Constants.Spacing.small),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Type Label
            typeLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: Constants.Spacing.small),
            typeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            typeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            
            // Date Label
            dateLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            
            // Analyze Button
            analyzeButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: Constants.Spacing.small),
            analyzeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            analyzeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            analyzeButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.Spacing.small),
            analyzeButton.heightAnchor.constraint(equalToConstant: 28),
            
            // Activity Indicator
            activityIndicator.centerXAnchor.constraint(equalTo: thumbnailImageView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: thumbnailImageView.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        analyzeButton.addTarget(self, action: #selector(analyzeButtonTapped), for: .touchUpInside)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Configuration
    func configure(with mediaItem: MediaItem) {
        self.mediaItem = mediaItem
        
        // 设置缩略图
        if let thumbnail = MediaManager.shared.getThumbnail(for: mediaItem) {
            thumbnailImageView.image = thumbnail
        } else if mediaItem.type == .photo,
                  let image = MediaManager.shared.getImage(for: mediaItem) {
            thumbnailImageView.image = image
        } else {
            thumbnailImageView.image = UIImage(systemName: "photo")
            thumbnailImageView.tintColor = Constants.Colors.secondaryTextColor
        }
        
        // 设置播放图标（视频）
        playIconImageView.isHidden = (mediaItem.type != .video)
        
        // 设置类型标签
        typeLabel.text = mediaItem.type.displayName
        
        // 设置日期
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: mediaItem.createdAt)
        
        // 设置收藏状态
        favoriteButton.isSelected = mediaItem.isFavorite
        
        // 设置分析状态
        updateAnalysisStatus(mediaItem.analysisStatus)
    }
    
    private func updateAnalysisStatus(_ status: AnalysisStatus) {
        statusView.backgroundColor = status.color
        statusLabel.text = status.displayName
        
        switch status {
        case .pending:
            analyzeButton.isHidden = false
            analyzeButton.setTitle("🔍 分析", for: .normal)
            analyzeButton.backgroundColor = Constants.Colors.primaryColor
            analyzeButton.isEnabled = true
            activityIndicator.stopAnimating()
            
        case .processing:
            analyzeButton.isHidden = false
            analyzeButton.setTitle("分析中...", for: .normal)
            analyzeButton.backgroundColor = Constants.Colors.infoColor
            analyzeButton.isEnabled = false
            activityIndicator.startAnimating()
            
        case .completed:
            analyzeButton.isHidden = false
            analyzeButton.setTitle("📋 查看結果", for: .normal)
            analyzeButton.backgroundColor = Constants.Colors.successColor
            analyzeButton.isEnabled = true
            activityIndicator.stopAnimating()
            
        case .failed:
            analyzeButton.isHidden = false
            analyzeButton.setTitle("⚠️ 重試", for: .normal)
            analyzeButton.backgroundColor = Constants.Colors.errorColor
            analyzeButton.isEnabled = true
            activityIndicator.stopAnimating()
        }
    }
    
    // MARK: - Actions
    @objc private func analyzeButtonTapped() {
        guard let mediaItem = mediaItem else { return }
        
        switch mediaItem.analysisStatus {
        case .pending, .failed:
            onAnalyzeTapped?()
        case .completed:
            // 查看结果的逻辑将在父视图控制器中处理
            onAnalyzeTapped?()
        case .processing:
            // 分析中，不做任何操作
            break
        }
    }
    
    @objc private func favoriteButtonTapped() {
        guard var mediaItem = mediaItem else { return }
        
        mediaItem.isFavorite.toggle()
        MediaManager.shared.updateMediaItem(mediaItem)
        favoriteButton.isSelected = mediaItem.isFavorite
        
        onFavoriteTapped?()
    }
} 