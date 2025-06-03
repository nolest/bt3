import UIKit

class HomeViewController: UIViewController {
    
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
    
    private let babyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 35
        imageView.backgroundColor = Constants.Colors.cardBackgroundColor
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = Constants.Colors.primaryLightColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let babyNameLabel: UILabel = {
        let label = UILabel()
        label.text = "小寶寶"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.title, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let babyAgeLabel: UILabel = {
        let label = UILabel()
        label.text = "3個月21天"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusView: UIView = {
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
    
    private let statusTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "當前狀態"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let statusStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let activitySectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "今日活動"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let activityCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = Constants.Spacing.medium
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: Constants.Spacing.medium, bottom: 0, right: Constants.Spacing.medium)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ActivityCell.self, forCellWithReuseIdentifier: "ActivityCell")
        return collectionView
    }()
    
    private let reminderSectionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let reminderTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "即將到來的提醒"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reminderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Constants.Spacing.medium
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = false
        collectionView.register(ReminderCell.self, forCellWithReuseIdentifier: "ReminderCell")
        return collectionView
    }()
    
    // 模拟数据
    private let activities: [(title: String, icon: String, time: String)] = [
        ("餵奶", "drop.fill", "08:30"),
        ("換尿布", "wind", "09:15"),
        ("睡覺", "bed.double.fill", "10:00"),
        ("洗澡", "shower.fill", "18:30")
    ]
    
    private let reminders: [(title: String, time: String, icon: String)] = [
        ("餵奶時間", "11:30", "clock.fill"),
        ("睡覺時間", "13:00", "bed.double.fill")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        setupNavigationBar()
        setupViews()
        setupCollectionViews()
        setupStatusIcons()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(notificationButtonTapped))
        
        if #available(iOS 15.0, *) {
            navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.primaryColor
        }
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(babyImageView)
        headerView.addSubview(babyNameLabel)
        headerView.addSubview(babyAgeLabel)
        
        contentView.addSubview(statusView)
        statusView.addSubview(statusTitleLabel)
        statusView.addSubview(statusStackView)
        
        contentView.addSubview(activitySectionView)
        activitySectionView.addSubview(activityTitleLabel)
        activitySectionView.addSubview(activityCollectionView)
        
        contentView.addSubview(reminderSectionView)
        reminderSectionView.addSubview(reminderTitleLabel)
        reminderSectionView.addSubview(reminderCollectionView)
        
        NSLayoutConstraint.activate([
            // 滚动视图约束
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            headerView.heightAnchor.constraint(equalToConstant: 150),
            
            // 宝宝图像约束
            babyImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            babyImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            babyImageView.widthAnchor.constraint(equalToConstant: 70),
            babyImageView.heightAnchor.constraint(equalToConstant: 70),
            
            // 宝宝名称标签约束
            babyNameLabel.leadingAnchor.constraint(equalTo: babyImageView.trailingAnchor, constant: Constants.Spacing.medium),
            babyNameLabel.topAnchor.constraint(equalTo: babyImageView.topAnchor, constant: Constants.Spacing.small),
            babyNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            // 宝宝年龄标签约束
            babyAgeLabel.leadingAnchor.constraint(equalTo: babyNameLabel.leadingAnchor),
            babyAgeLabel.topAnchor.constraint(equalTo: babyNameLabel.bottomAnchor, constant: Constants.Spacing.small),
            babyAgeLabel.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            // 状态视图约束
            statusView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -25),
            statusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            statusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            statusView.heightAnchor.constraint(equalToConstant: 100),
            
            // 状态标题标签约束
            statusTitleLabel.topAnchor.constraint(equalTo: statusView.topAnchor, constant: Constants.Spacing.medium),
            statusTitleLabel.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: Constants.Spacing.medium),
            statusTitleLabel.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            // 状态栈视图约束
            statusStackView.topAnchor.constraint(equalTo: statusTitleLabel.bottomAnchor, constant: Constants.Spacing.medium),
            statusStackView.leadingAnchor.constraint(equalTo: statusView.leadingAnchor, constant: Constants.Spacing.large),
            statusStackView.trailingAnchor.constraint(equalTo: statusView.trailingAnchor, constant: -Constants.Spacing.large),
            statusStackView.bottomAnchor.constraint(equalTo: statusView.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // 活动部分视图约束
            activitySectionView.topAnchor.constraint(equalTo: statusView.bottomAnchor, constant: Constants.Spacing.large),
            activitySectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activitySectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activitySectionView.heightAnchor.constraint(equalToConstant: 180),
            
            // 活动标题标签约束
            activityTitleLabel.topAnchor.constraint(equalTo: activitySectionView.topAnchor),
            activityTitleLabel.leadingAnchor.constraint(equalTo: activitySectionView.leadingAnchor, constant: Constants.Spacing.large),
            activityTitleLabel.trailingAnchor.constraint(equalTo: activitySectionView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 活动集合视图约束
            activityCollectionView.topAnchor.constraint(equalTo: activityTitleLabel.bottomAnchor, constant: Constants.Spacing.medium),
            activityCollectionView.leadingAnchor.constraint(equalTo: activitySectionView.leadingAnchor),
            activityCollectionView.trailingAnchor.constraint(equalTo: activitySectionView.trailingAnchor),
            activityCollectionView.bottomAnchor.constraint(equalTo: activitySectionView.bottomAnchor),
            
            // 提醒部分视图约束
            reminderSectionView.topAnchor.constraint(equalTo: activitySectionView.bottomAnchor, constant: Constants.Spacing.medium),
            reminderSectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            reminderSectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            // 提醒标题标签约束
            reminderTitleLabel.topAnchor.constraint(equalTo: reminderSectionView.topAnchor),
            reminderTitleLabel.leadingAnchor.constraint(equalTo: reminderSectionView.leadingAnchor, constant: Constants.Spacing.large),
            reminderTitleLabel.trailingAnchor.constraint(equalTo: reminderSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 提醒集合视图约束
            reminderCollectionView.topAnchor.constraint(equalTo: reminderTitleLabel.bottomAnchor, constant: Constants.Spacing.medium),
            reminderCollectionView.leadingAnchor.constraint(equalTo: reminderSectionView.leadingAnchor, constant: Constants.Spacing.large),
            reminderCollectionView.trailingAnchor.constraint(equalTo: reminderSectionView.trailingAnchor, constant: -Constants.Spacing.large),
            reminderCollectionView.heightAnchor.constraint(equalToConstant: CGFloat(reminders.count * 80)),
            reminderCollectionView.bottomAnchor.constraint(equalTo: reminderSectionView.bottomAnchor),
            
            // 内容视图底部约束
            reminderSectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.extraLarge)
        ])
    }
    
    private func setupCollectionViews() {
        activityCollectionView.dataSource = self
        activityCollectionView.delegate = self
        
        reminderCollectionView.dataSource = self
        reminderCollectionView.delegate = self
    }
    
    private func setupStatusIcons() {
        // 添加状态图标
        let statusItems = [
            ("最近餵奶", "1小時前", "drop.fill"),
            ("最近睡眠", "30分鐘前", "bed.double.fill"),
            ("最近換尿布", "45分鐘前", "wind")
        ]
        
        for (title, time, iconName) in statusItems {
            let statusItemView = createStatusItemView(title: title, time: time, iconName: iconName)
            statusStackView.addArrangedSubview(statusItemView)
        }
    }
    
    private func createStatusItemView(title: String, time: String, iconName: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let iconView = UIImageView()
        iconView.image = UIImage(systemName: iconName)
        iconView.tintColor = Constants.Colors.primaryColor
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        titleLabel.textColor = Constants.Colors.primaryTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        
        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.caption - 2)
        timeLabel.textColor = Constants.Colors.secondaryTextColor
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textAlignment = .center
        
        containerView.addSubview(iconView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 80),
            
            iconView.topAnchor.constraint(equalTo: containerView.topAnchor),
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        return containerView
    }
    
    @objc private func notificationButtonTapped() {
        // 处理通知按钮点击
        print("通知按钮点击")
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == activityCollectionView {
            return activities.count
        } else if collectionView == reminderCollectionView {
            return reminders.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == activityCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            let activity = activities[indexPath.item]
            cell.configure(title: activity.title, iconName: activity.icon, time: activity.time)
            return cell
        } else if collectionView == reminderCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReminderCell", for: indexPath) as! ReminderCell
            let reminder = reminders[indexPath.item]
            cell.configure(title: reminder.title, time: reminder.time, iconName: reminder.icon)
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == activityCollectionView {
            return CGSize(width: 120, height: 120)
        } else if collectionView == reminderCollectionView {
            return CGSize(width: collectionView.bounds.width, height: 70)
        }
        return CGSize.zero
    }
}

// MARK: - ActivityCell
class ActivityCell: UICollectionViewCell {
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
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .medium)
        label.textColor = Constants.Colors.primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
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
        containerView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.medium),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: Constants.Spacing.small),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.small),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.small),
            timeLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -Constants.Spacing.small)
        ])
    }
    
    func configure(title: String, iconName: String, time: String) {
        titleLabel.text = title
        iconImageView.image = UIImage(systemName: iconName)
        timeLabel.text = time
    }
}

// MARK: - ReminderCell
class ReminderCell: UICollectionViewCell {
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
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .medium)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .bold)
        label.textColor = Constants.Colors.primaryColor
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
        containerView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Constants.Spacing.medium),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            timeLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func configure(title: String, time: String, iconName: String) {
        titleLabel.text = title
        timeLabel.text = time
        iconImageView.image = UIImage(systemName: iconName)
    }
} 