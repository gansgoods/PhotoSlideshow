import UIKit

class ViewController: UIViewController {
    lazy var helloWorldLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
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
    
    private func updateColors() {
        // 设置系统背景色，会自动适应深色/浅色模式
        view.backgroundColor = .systemBackground
        // 设置文字颜色
        updateTextColor()
    }
    
    private func updateTextColor() {
        helloWorldLabel.textColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
    }
} 