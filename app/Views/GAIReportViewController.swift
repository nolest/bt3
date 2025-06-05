import UIKit

class GAIReportViewController: UIViewController {
    
    private let report: GAIAnalysisReport
    
    init(report: GAIAnalysisReport) {
        self.report = report
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Colors.backgroundColor
        title = "分析報告"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissTapped)
        )
        
        let label = UILabel()
        label.text = "GAI分析報告功能開發中..."
        label.font = UIFont.systemFont(ofSize: Constants.FontSize.title2)
        label.textColor = Constants.Colors.secondaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
} 