import UIKit

class PhotosViewController: UIViewController {
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["照片", "影片", "GAI分析"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.register(GAIAnalysisCell.self, forCellWithReuseIdentifier: "GAIAnalysisCell")
        return collectionView
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = Constants.Colors.primaryColor
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // 模拟数据
    private var photos: [String] = ["baby1", "baby2", "baby3", "baby4", "baby5", "baby6", "baby7", "baby8", "baby9", "baby10", "baby11", "baby12"]
    private var videos: [String] = ["video1", "video2", "video3", "video4", "video5", "video6"]
    private var gaiAnalyses: [(title: String, description: String, date: String)] = [
        ("3個月成長報告", "寶寶的頸部支撐能力明顯提升，能夠抬頭並保持穩定。笑容開始更加頻繁，能夠對外界刺激做出積極反應。", "2023-10-15"),
        ("4個月成長報告", "寶寶開始嘗試翻身，對周圍環境表現出更多興趣。開始發出更多元化的聲音，嘗試與人互動。", "2023-11-20"),
        ("智能發展報告", "分析顯示寶寶的智能發展處於同齡人群的80%水平，社交互動能力發展良好。", "2023-12-05")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        setupViews()
        setupNavigationBar()
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        cameraButton.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonTapped))
        
        if #available(iOS 15.0, *) {
            navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.primaryColor
        }
    }
    
    private func setupViews() {
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        view.addSubview(cameraButton)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Spacing.medium),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.Spacing.medium),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            cameraButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            cameraButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Spacing.large),
            cameraButton.widthAnchor.constraint(equalToConstant: 60),
            cameraButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    @objc private func cameraButtonTapped() {
        // 处理相机按钮点击
        print("相机按钮点击")
    }
    
    @objc private func shareButtonTapped() {
        // 处理分享按钮点击
        print("分享按钮点击")
    }
}

// MARK: - UICollectionViewDataSource
extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 照片
            return photos.count
        case 1: // 影片
            return videos.count
        case 2: // GAI分析
            return gaiAnalyses.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0, 1: // 照片或影片
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
            
            // 设置单元格内容
            let isVideo = segmentedControl.selectedSegmentIndex == 1
            let imageName = isVideo ? videos[indexPath.item] : photos[indexPath.item]
            
            // 使用系统图标模拟照片/视频
            let systemImageName = isVideo ? "video.fill" : "photo.fill"
            cell.configure(with: UIImage(systemName: systemImageName)!, isVideo: isVideo)
            
            return cell
            
        case 2: // GAI分析
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GAIAnalysisCell", for: indexPath) as! GAIAnalysisCell
            
            // 设置GAI分析单元格内容
            let analysis = gaiAnalyses[indexPath.item]
            cell.configure(title: analysis.title, description: analysis.description, date: analysis.date)
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        
        switch segmentedControl.selectedSegmentIndex {
        case 0, 1: // 照片或影片
            // 每行3个照片/视频
            let itemWidth = (width - 4) / 3
            return CGSize(width: itemWidth, height: itemWidth)
            
        case 2: // GAI分析
            // GAI分析卡片宽度为屏幕宽度
            return CGSize(width: width - Constants.Spacing.large * 2, height: 150)
            
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch segmentedControl.selectedSegmentIndex {
        case 0, 1: // 照片或影片
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            
        case 2: // GAI分析
            return UIEdgeInsets(top: Constants.Spacing.medium, left: Constants.Spacing.large, bottom: Constants.Spacing.medium, right: Constants.Spacing.large)
            
        default:
            return UIEdgeInsets.zero
        }
    }
}

// MARK: - PhotoCell
class PhotoCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let videoIndicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(imageView)
        contentView.addSubview(videoIndicator)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            videoIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.small),
            videoIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.small),
            videoIndicator.widthAnchor.constraint(equalToConstant: 24),
            videoIndicator.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with image: UIImage, isVideo: Bool = false) {
        imageView.image = image
        imageView.tintColor = Constants.Colors.primaryColor.withAlphaComponent(0.8)
        videoIndicator.isHidden = !isVideo
    }
}

// MARK: - GAIAnalysisCell
class GAIAnalysisCell: UICollectionViewCell {
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = Constants.Colors.secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.hintTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "brain")
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.medium),
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.medium),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: Constants.Spacing.small),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.Spacing.small),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: Constants.Spacing.small),
            dateLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            dateLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.Spacing.medium)
        ])
    }
    
    func configure(title: String, description: String, date: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
    }
} 