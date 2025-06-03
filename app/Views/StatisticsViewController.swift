import UIKit

class StatisticsViewController: UIViewController {
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["餵奶", "換尿布", "睡眠", "成長"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let timeSegmentedControl: UISegmentedControl = {
        let items = ["週", "月", "年"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let chartView: UIView = {
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
    
    private let chartImageView: UIImageView = {
        let imageView = UIImageView()
        // 使用系统图标模拟图表
        imageView.image = UIImage(systemName: "chart.bar.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Constants.Colors.primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let chartTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "餵奶統計"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let summaryView: UIView = {
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
    
    private let summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "本週摘要"
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.subtitle, weight: .bold)
        label.textColor = Constants.Colors.primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let summaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.Spacing.medium
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.Colors.backgroundColor
        
        setupViews()
        setupSummaryItems()
        setupActions()
    }
    
    private func setupViews() {
        // 添加控件到视图
        view.addSubview(segmentedControl)
        view.addSubview(timeSegmentedControl)
        view.addSubview(chartView)
        chartView.addSubview(chartTitleLabel)
        chartView.addSubview(chartImageView)
        view.addSubview(summaryView)
        summaryView.addSubview(summaryTitleLabel)
        summaryView.addSubview(summaryStackView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            // 分段控制器约束
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.Spacing.medium),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 时间分段控制器约束
            timeSegmentedControl.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: Constants.Spacing.medium),
            timeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            timeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            
            // 图表视图约束
            chartView.topAnchor.constraint(equalTo: timeSegmentedControl.bottomAnchor, constant: Constants.Spacing.large),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            chartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.35),
            
            // 图表标题标签约束
            chartTitleLabel.topAnchor.constraint(equalTo: chartView.topAnchor, constant: Constants.Spacing.medium),
            chartTitleLabel.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: Constants.Spacing.medium),
            chartTitleLabel.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            // 图表图像视图约束
            chartImageView.topAnchor.constraint(equalTo: chartTitleLabel.bottomAnchor, constant: Constants.Spacing.medium),
            chartImageView.leadingAnchor.constraint(equalTo: chartView.leadingAnchor, constant: Constants.Spacing.medium),
            chartImageView.trailingAnchor.constraint(equalTo: chartView.trailingAnchor, constant: -Constants.Spacing.medium),
            chartImageView.bottomAnchor.constraint(equalTo: chartView.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // 摘要视图约束
            summaryView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: Constants.Spacing.large),
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.Spacing.large),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.Spacing.large),
            summaryView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Spacing.medium),
            
            // 摘要标题标签约束
            summaryTitleLabel.topAnchor.constraint(equalTo: summaryView.topAnchor, constant: Constants.Spacing.medium),
            summaryTitleLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: Constants.Spacing.medium),
            summaryTitleLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -Constants.Spacing.medium),
            
            // 摘要栈视图约束
            summaryStackView.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: Constants.Spacing.medium),
            summaryStackView.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor, constant: Constants.Spacing.medium),
            summaryStackView.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor, constant: -Constants.Spacing.medium),
            summaryStackView.bottomAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: -Constants.Spacing.medium)
        ])
    }
    
    private func setupSummaryItems() {
        // 清除现有的摘要项
        summaryStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 根据当前选中的统计类型添加摘要项
        switch segmentedControl.selectedSegmentIndex {
        case 0: // 餵奶
            addSummaryItem(title: "總餵奶次數", value: "32次")
            addSummaryItem(title: "平均每日餵奶次數", value: "4.6次")
            addSummaryItem(title: "母乳餵食比例", value: "75%")
            addSummaryItem(title: "奶瓶餵食比例", value: "25%")
            addSummaryItem(title: "總餵奶量", value: "960ml")
        case 1: // 換尿布
            addSummaryItem(title: "總換尿布次數", value: "42次")
            addSummaryItem(title: "平均每日換尿布次數", value: "6次")
            addSummaryItem(title: "尿尿次數", value: "28次")
            addSummaryItem(title: "便便次數", value: "14次")
        case 2: // 睡眠
            addSummaryItem(title: "總睡眠時間", value: "98小時")
            addSummaryItem(title: "平均每日睡眠時間", value: "14小時")
            addSummaryItem(title: "最長睡眠時間", value: "5.5小時")
            addSummaryItem(title: "白天睡眠比例", value: "35%")
            addSummaryItem(title: "夜間睡眠比例", value: "65%")
        case 3: // 成長
            addSummaryItem(title: "當前體重", value: "6.2kg")
            addSummaryItem(title: "體重增長", value: "+0.4kg")
            addSummaryItem(title: "當前身高", value: "62cm")
            addSummaryItem(title: "身高增長", value: "+2cm")
            addSummaryItem(title: "當前頭圍", value: "41cm")
        default:
            break
        }
    }
    
    private func addSummaryItem(title: String, value: String) {
        let itemView = createSummaryItemView(title: title, value: value)
        summaryStackView.addArrangedSubview(itemView)
    }
    
    private func createSummaryItemView(title: String, value: String) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.body)
        titleLabel.textColor = Constants.Colors.secondaryTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = UIFont.systemFont(ofSize: Constants.FontSize.body, weight: .bold)
        valueLabel.textColor = Constants.Colors.primaryTextColor
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Constants.Spacing.medium)
        ])
        
        return containerView
    }
    
    private func setupActions() {
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        timeSegmentedControl.addTarget(self, action: #selector(timeSegmentChanged), for: .valueChanged)
    }
    
    @objc private func segmentChanged(_ sender: UISegmentedControl) {
        // 更新图表标题
        let titles = ["餵奶統計", "換尿布統計", "睡眠統計", "成長統計"]
        chartTitleLabel.text = titles[sender.selectedSegmentIndex]
        
        // 更新摘要标题
        let summaryTitles = ["本週摘要", "本月摘要", "本年摘要"]
        summaryTitleLabel.text = summaryTitles[timeSegmentedControl.selectedSegmentIndex]
        
        // 更新摘要内容
        setupSummaryItems()
    }
    
    @objc private func timeSegmentChanged(_ sender: UISegmentedControl) {
        // 更新摘要标题
        let summaryTitles = ["本週摘要", "本月摘要", "本年摘要"]
        summaryTitleLabel.text = summaryTitles[sender.selectedSegmentIndex]
        
        // 更新摘要内容（在实际应用中，这里会根据不同的时间范围加载不同的数据）
        setupSummaryItems()
    }
}