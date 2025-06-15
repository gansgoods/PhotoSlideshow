import UIKit
import Photos

class ViewController: UIViewController {
    lazy var helloWorldLabel: UILabel = {
        let label = UILabel()
        label.text = "照片轮播演示"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 24.0, weight: .bold)
        
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
    
    lazy var photoCountLabel: UILabel = {
        let label = UILabel()
        label.text = "正在加载照片..."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        
        if #available(iOS 13.0, *) {
            label.textColor = .secondaryLabel
        } else {
            label.textColor = .gray
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var livePhotoCountLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        
        if #available(iOS 13.0, *) {
            label.textColor = .systemOrange
        } else {
            label.textColor = .orange
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("测试照片访问", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(testPhotoAccess), for: .touchUpInside)
        return button
    }()
    
    private let photoManager = PhotoManager()
    
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
        view.addSubview(photoCountLabel)
        view.addSubview(livePhotoCountLabel)
        view.addSubview(testButton)
        
        NSLayoutConstraint.activate([
            helloWorldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloWorldLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80),
            
            photoCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoCountLabel.topAnchor.constraint(equalTo: helloWorldLabel.bottomAnchor, constant: 20),
            photoCountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            photoCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            livePhotoCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            livePhotoCountLabel.topAnchor.constraint(equalTo: photoCountLabel.bottomAnchor, constant: 10),
            livePhotoCountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            livePhotoCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.topAnchor.constraint(equalTo: livePhotoCountLabel.bottomAnchor, constant: 30),
            testButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func testPhotoAccess() {
        photoCountLabel.text = "正在请求权限..."
        livePhotoCountLabel.text = ""
        
        photoManager.requestPhotoPermission { [weak self] status in
            switch status {
            case .authorized, .limited:
                self?.loadPhotos()
            case .denied, .restricted:
                self?.photoCountLabel.text = "照片权限被拒绝"
            case .notDetermined:
                self?.photoCountLabel.text = "未确定照片权限"
            @unknown default:
                self?.photoCountLabel.text = "未知权限状态"
            }
        }
    }
    
    private func loadPhotos() {
        photoCountLabel.text = "正在加载照片..."
        
        // 加载所有照片
        photoManager.fetchPhotos { [weak self] photos in
            if photos.isEmpty {
                self?.photoCountLabel.text = "没有找到照片\n请向模拟器添加一些照片！"
            } else {
                self?.photoCountLabel.text = "找到 \(photos.count) 张照片"
                
                // 加载实况照片
                self?.photoManager.fetchLivePhotos { livePhotos in
                    if livePhotos.isEmpty {
                        self?.livePhotoCountLabel.text = "📱 没有实况照片\n请添加一些Live Photos！"
                    } else {
                        self?.livePhotoCountLabel.text = "🎬 找到 \(livePhotos.count) 张实况照片"
                    }
                }
            }
        }
    }
    
    func updateColors() {
        // 使用兼容iOS 12的颜色方案
        if #available(iOS 13.0, *) {
            // iOS 13+ 支持系统颜色和深色模式
            view.backgroundColor = .systemBackground
            helloWorldLabel.textColor = .label
            photoCountLabel.textColor = .secondaryLabel
            livePhotoCountLabel.textColor = .systemOrange
        } else {
            // iOS 12 使用固定的颜色
            view.backgroundColor = .white
            helloWorldLabel.textColor = .black
            photoCountLabel.textColor = .gray
            livePhotoCountLabel.textColor = .orange
        }
    }
} 

