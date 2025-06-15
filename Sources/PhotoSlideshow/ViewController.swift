import UIKit

class ViewController: UIViewController {
    lazy var helloWorldLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello World"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        
        // iOS 12兼容的颜色设置
        if #available(iOS 13.0, *) {
            label.textColor = .label
        } else {
            // iOS 12中使用固定的黑色文字
            label.textColor = .black
        }
        
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
        
        // iOS 13+ 才支持深色模式
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                updateColors()
            }
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
        // 使用兼容iOS 12的颜色方案
        if #available(iOS 13.0, *) {
            // iOS 13+ 支持系统颜色和深色模式
            view.backgroundColor = .systemBackground
            helloWorldLabel.textColor = .label
        } else {
            // iOS 12 使用固定的颜色
            view.backgroundColor = .white
            helloWorldLabel.textColor = .black
        }
    }
} 

