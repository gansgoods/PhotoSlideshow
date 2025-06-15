import UIKit

class ViewController: UIViewController {
    lazy var helloWorldLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        label.textColor = .label // 使用系统标签颜色
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateColors()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateColors()
        }
    }
    
    private func setupUI() {
        view.addSubview(helloWorldLabel)
        
        NSLayoutConstraint.activate([
            helloWorldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloWorldLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func updateColors() {
        // 使用系统颜色，自动适配深色/浅色模式
        view.backgroundColor = .systemBackground
        helloWorldLabel.textColor = .label
    }
} 