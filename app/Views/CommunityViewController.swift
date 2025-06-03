import UIKit

class CommunityViewController: UIViewController {
    
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
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "育兒社群"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.largeTitle, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let headerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "與其他父母分享經驗，獲得專業建議"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = .white
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let facebookLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("連接Facebook帳號", for: .normal)
        button.setImage(UIImage(systemName: "f.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(hex: "#3b5998")
        button.layer.cornerRadius = Constants.CornerRadius.medium
        button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .semibold)
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["熱門話題", "專家建議", "我的貼文"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let createPostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
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
    private var posts: [(author: String, avatar: String, time: String, content: String, likes: Int, comments: Int)] = [
        ("王媽媽", "person.crop.circle.fill", "2小時前", "寶寶最近睡眠不安穩，有沒有其他家長遇到類似情況？有什麼好的解決方法嗎？", 15, 8),
        ("李爸爸", "person.crop.circle.fill", "昨天", "分享一下我家寶寶的成長照片，四個月大了！好可愛！", 42, 12),
        ("兒科醫生 陳醫師", "stethoscope", "2天前", "【專家建議】關於寶寶的睡眠問題，以下是一些實用技巧：\n1. 建立規律的睡眠時間\n2. 創造安靜舒適的睡眠環境\n3. 睡前進行安撫活動，例如輕聲唱歌或講故事", 89, 23),
        ("張媽媽", "person.crop.circle.fill", "3天前", "有人能推薦好用的嬰兒推車嗎？預算約5000元左右。", 7, 18)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        setupViews()
        setupNavigationBar()
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        facebookLoginButton.addTarget(self, action: #selector(facebookLoginButtonTapped), for: .touchUpInside)
        createPostButton.addTarget(self, action: #selector(createPostButtonTapped), for: .touchUpInside)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "bell.fill"), style: .plain, target: self, action: #selector(notificationsButtonTapped))
        
        if #available(iOS 15.0, *) {
            navigationItem.rightBarButtonItem?.tintColor = Constants.Colors.primaryColor
        }
    }
    
    private func setupViews() {
        // 添加滚动视图
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // 添加头部视图
        contentView.addSubview(headerView)
        headerView.addSubview(headerLabel)
        headerView.addSubview(headerDescriptionLabel)
        headerView.addSubview(facebookLoginButton)
        
        // 添加分段控制器
        contentView.addSubview(segmentedControl)
        
        // 添加表格视图
        contentView.addSubview(tableView)
        
        // 添加创建帖子按钮
        view.addSubview(createPostButton)
        
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
            headerView.heightAnchor.constraint(equalToConstant: 180),
            
            // 头部标签约束
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: Constants.Spacing.large),
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 头部描述标签约束
            headerDescriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Constants.Spacing.small),
            headerDescriptionLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            headerDescriptionLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // Facebook登录按钮约束
            facebookLoginButton.topAnchor.constraint(equalTo: headerDescriptionLabel.bottomAnchor, constant: Constants.Spacing.medium),
            facebookLoginButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Constants.Spacing.large),
            facebookLoginButton.trailingAnchor.constraint(lessThanOrEqualTo: headerView.trailingAnchor, constant: -Constants.Spacing.large),
            facebookLoginButton.bottomAnchor.constraint(lessThanOrEqualTo: headerView.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // 分段控制器约束
            segmentedControl.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Constants.Spacing.large),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 表格视图约束
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.Spacing.medium),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(posts.count * 180)),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // 创建帖子按钮约束
            createPostButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            createPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Spacing.large),
            createPostButton.widthAnchor.constraint(equalToConstant: 60),
            createPostButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // 根据选中的分段控制器索引切换显示的内容
        print("选中的内容类型: \(sender.selectedSegmentIndex)")
        tableView.reloadData()
    }
    
    @objc private func facebookLoginButtonTapped() {
        // 处理Facebook登录
        print("Facebook登录按钮点击")
        
        // 模拟登录成功后的状态变化
        facebookLoginButton.setTitle("已连接Facebook帐号", for: .normal)
        facebookLoginButton.backgroundColor = UIColor(hex: "#4267B2")
    }
    
    @objc private func createPostButtonTapped() {
        // 创建新帖子
        let alertController = UIAlertController(title: "創建新貼文", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "分享您的想法..."
        }
        
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        let postAction = UIAlertAction(title: "發布", style: .default) { [weak self] _ in
            if let content = alertController.textFields?.first?.text, !content.isEmpty {
                // 模拟创建新帖子
                let newPost: (author: String, avatar: String, time: String, content: String, likes: Int, comments: Int) = (
                    "我", "person.crop.circle.fill", "剛剛", content, 0, 0
                )
                
                self?.posts.insert(newPost, at: 0)
                self?.tableView.reloadData()
                
                // 更新表格视图高度约束
                if let tableView = self?.tableView {
                    for constraint in (self?.contentView.constraints)! where constraint.firstItem === tableView && constraint.firstAttribute == .height {
                        constraint.constant = CGFloat((self?.posts.count)! * 180)
                    }
                }
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(postAction)
        
        present(alertController, animated: true)
    }
    
    @objc private func notificationsButtonTapped() {
        // 处理通知按钮点击
        print("通知按钮点击")
    }
}

// MARK: - UITableViewDataSource
extension CommunityViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let post = posts[indexPath.row]
        cell.configure(
            author: post.author,
            avatarName: post.avatar,
            time: post.time,
            content: post.content,
            likes: post.likes,
            comments: post.comments
        )
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CommunityViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 处理帖子点击，例如跳转到详情页面
        print("点击了帖子: \(indexPath.row)")
    }
}

// MARK: - PostCell
class PostCell: UITableViewCell {
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
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        label.textColor = Constants.Colors.primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let interactionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = Constants.Spacing.large
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = Constants.Colors.secondaryTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let likeCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.tintColor = Constants.Colors.secondaryTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.caption)
        label.textColor = Constants.Colors.secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = Constants.Colors.secondaryTextColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(authorLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(contentLabel)
        
        // 创建点赞组件
        let likeStack = UIStackView(arrangedSubviews: [likeButton, likeCountLabel])
        likeStack.axis = .horizontal
        likeStack.spacing = 4
        likeStack.alignment = .center
        
        // 创建评论组件
        let commentStack = UIStackView(arrangedSubviews: [commentButton, commentCountLabel])
        commentStack.axis = .horizontal
        commentStack.spacing = 4
        commentStack.alignment = .center
        
        // 添加到交互栈视图
        interactionStackView.addArrangedSubview(likeStack)
        interactionStackView.addArrangedSubview(commentStack)
        interactionStackView.addArrangedSubview(shareButton)
        
        containerView.addSubview(interactionStackView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Spacing.small),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Spacing.large),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Spacing.large),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Spacing.small),
            
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.medium),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.Spacing.medium),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: Constants.Spacing.medium),
            
            timeLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: Constants.Spacing.medium),
            timeLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            contentLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: Constants.Spacing.medium),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.medium),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            interactionStackView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: Constants.Spacing.medium),
            interactionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.Spacing.large),
            interactionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Constants.Spacing.large),
            interactionStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Constants.Spacing.medium)
        ])
        
        // 设置按钮事件
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
    }
    
    func configure(author: String, avatarName: String, time: String, content: String, likes: Int, comments: Int) {
        authorLabel.text = author
        avatarImageView.image = UIImage(systemName: avatarName)
        timeLabel.text = time
        contentLabel.text = content
        likeCountLabel.text = "\(likes)"
        commentCountLabel.text = "\(comments)"
    }
    
    @objc private func likeButtonTapped() {
        // 模拟点赞功能
        if let text = likeCountLabel.text, let count = Int(text) {
            likeCountLabel.text = "\(count + 1)"
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            likeButton.tintColor = UIColor.systemRed
        }
    }
    
    @objc private func commentButtonTapped() {
        // 处理评论按钮点击
        print("评论按钮点击")
    }
    
    @objc private func shareButtonTapped() {
        // 处理分享按钮点击
        print("分享按钮点击")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        authorLabel.text = nil
        avatarImageView.image = nil
        timeLabel.text = nil
        contentLabel.text = nil
        likeCountLabel.text = nil
        commentCountLabel.text = nil
        
        // 重置点赞按钮状态
        likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        likeButton.tintColor = Constants.Colors.secondaryTextColor
    }
} 