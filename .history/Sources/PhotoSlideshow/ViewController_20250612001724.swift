import UIKit

class ViewController: UIViewController {
    lazy var helloWorldLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold) // 增大字体并加粗
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateColors()
        
        // 强制设置高对比度颜色确保可见性
        setHighContrastColors()
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
    
    // 新添加的方法：强制设置颜色
    func setForceWhiteBackground() {
        view.backgroundColor = .white
    }
    
    func setForceBlackText() {
        helloWorldLabel.textColor = .black
    }
    
    func setHighContrastColors() {
        // 强制设置白色背景和黑色文字，确保最大对比度
        view.backgroundColor = .white
        helloWorldLabel.textColor = .black
        helloWorldLabel.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        
        // 额外确保视图立即刷新
        view.setNeedsDisplay()
        helloWorldLabel.setNeedsDisplay()
    }
} 