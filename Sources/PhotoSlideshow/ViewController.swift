import UIKit
import Photos

class ViewController: UIViewController {
    // MARK: - UI组件
    
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
        label.text = "正在检查照片权限..."
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
    
    lazy var permissionDeniedLabel: UILabel = {
        let label = UILabel()
        label.text = "需要照片访问权限\n请在设置中允许访问照片"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.numberOfLines = 0
        label.isHidden = true
        
        if #available(iOS 13.0, *) {
            label.textColor = .systemRed
        } else {
            label.textColor = .red
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 4
        let itemsPerRow: CGFloat = 3
        
        // 获取屏幕宽度，确保使用合适的尺寸
        let screenWidth = UIScreen.main.bounds.width
        let totalSpacing = spacing * (itemsPerRow + 1) // 左右边距 + 间距
        let itemWidth = (screenWidth - totalSpacing) / itemsPerRow
        
        // 确保最小尺寸
        let finalItemWidth = max(itemWidth, 100) // 最小100pt
        
        layout.itemSize = CGSize(width: finalItemWidth, height: finalItemWidth)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // 设置背景色确保可见
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .white
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    lazy var testButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("重新请求权限", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(requestPhotoAccess), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    // MARK: - 属性
    
    private let photoManager = PhotoManager()
    private var photos: [PHAsset] = []
    
    // MARK: - 生命周期
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateColors()
        checkPhotoPermissionAndLoadPhotos()
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
    
    // MARK: - UI设置
    
    private func setupUI() {
        view.addSubview(helloWorldLabel)
        view.addSubview(photoCountLabel)
        view.addSubview(permissionDeniedLabel)
        view.addSubview(photoCollectionView)
        view.addSubview(testButton)
        
        NSLayoutConstraint.activate([
            // 标题
            helloWorldLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            helloWorldLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // 状态标签
            photoCountLabel.topAnchor.constraint(equalTo: helloWorldLabel.bottomAnchor, constant: 10),
            photoCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            photoCountLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            photoCountLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // 权限拒绝标签
            permissionDeniedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            permissionDeniedLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            permissionDeniedLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            permissionDeniedLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            
            // 照片网格
            photoCollectionView.topAnchor.constraint(equalTo: photoCountLabel.bottomAnchor, constant: 20),
            photoCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoCollectionView.bottomAnchor.constraint(equalTo: testButton.topAnchor, constant: -20),
            
            // 测试按钮
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            testButton.widthAnchor.constraint(equalToConstant: 200),
            testButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    // MARK: - 权限和照片加载
    
    private func checkPhotoPermissionAndLoadPhotos() {
        let currentStatus = photoManager.getCurrentPermissionStatus()
        handlePhotoPermissionStatus(currentStatus)
    }
    
    func handlePhotoPermissionStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .authorized, .limited:
            loadAllPhotos()
            permissionDeniedLabel.isHidden = true
            testButton.isHidden = true
            photoCollectionView.isHidden = false
        case .denied, .restricted:
            photoCountLabel.text = "照片权限被拒绝"
            permissionDeniedLabel.isHidden = false
            testButton.isHidden = false
            photoCollectionView.isHidden = true
        case .notDetermined:
            photoCountLabel.text = "需要照片访问权限"
            requestPhotoAccess()
        @unknown default:
            photoCountLabel.text = "未知权限状态"
            permissionDeniedLabel.isHidden = false
            testButton.isHidden = false
            photoCollectionView.isHidden = true
        }
    }
    
    @objc private func requestPhotoAccess() {
        photoCountLabel.text = "正在请求权限..."
        
        photoManager.requestPhotoPermission { [weak self] status in
            self?.handlePhotoPermissionStatus(status)
        }
    }
    
    private func loadAllPhotos() {
        photoCountLabel.text = "正在加载照片..."
        
        photoManager.fetchAllMedia { [weak self] allMedia in
            self?.photos = allMedia
            
            if allMedia.isEmpty {
                self?.photoCountLabel.text = "没有找到照片或视频\n请向图库添加一些内容！"
            } else {
                let photoCount = allMedia.filter { $0.mediaType == .image }.count
                let videoCount = allMedia.filter { $0.mediaType == .video }.count
                let livePhotoCount = allMedia.filter { $0.mediaSubtypes.contains(.photoLive) }.count
                
                var statusText = "共 \(allMedia.count) 个媒体文件"
                if photoCount > 0 { statusText += "\n📷 \(photoCount) 张照片" }
                if livePhotoCount > 0 { statusText += "\n🎬 \(livePhotoCount) 张实况照片" }
                if videoCount > 0 { statusText += "\n🎥 \(videoCount) 个视频" }
                
                self?.photoCountLabel.text = statusText
            }
            
            self?.photoCollectionView.reloadData()
        }
    }
    
    // MARK: - 颜色更新
    
    func updateColors() {
        // 使用兼容iOS 12的颜色方案
        if #available(iOS 13.0, *) {
            // iOS 13+ 支持系统颜色和深色模式
            view.backgroundColor = .systemBackground
            helloWorldLabel.textColor = .label
            photoCountLabel.textColor = .secondaryLabel
            permissionDeniedLabel.textColor = .systemRed
        } else {
            // iOS 12 使用固定的颜色
            view.backgroundColor = .white
            helloWorldLabel.textColor = .black
            photoCountLabel.textColor = .gray
            permissionDeniedLabel.textColor = .red
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionViewCell
        let asset = photos[indexPath.item]
        cell.configure(with: asset, photoManager: photoManager)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        // TODO: 实现全屏轮播功能
        print("选中了媒体文件: \(indexPath.item)")
    }
}

// MARK: - PhotoCollectionViewCell

class PhotoCollectionViewCell: UICollectionViewCell {
    private let imageView = UIImageView()
    private let typeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // 设置cell背景
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .systemGray6
        } else {
            contentView.backgroundColor = .lightGray
        }
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(typeLabel)
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 设置占位图
        imageView.backgroundColor = .systemGray4
        
        typeLabel.font = UIFont.systemFont(ofSize: 10)
        typeLabel.textColor = .white
        typeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        typeLabel.textAlignment = .center
        typeLabel.layer.cornerRadius = 8
        typeLabel.clipsToBounds = true
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            typeLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            typeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            typeLabel.widthAnchor.constraint(equalToConstant: 30),
            typeLabel.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func configure(with asset: PHAsset, photoManager: PhotoManager) {
        // 重置状态
        imageView.image = nil
        imageView.backgroundColor = .systemGray4
        
        // 设置类型标签
        switch asset.mediaType {
        case .image:
            if asset.mediaSubtypes.contains(.photoLive) {
                typeLabel.text = "LIVE"
                typeLabel.isHidden = false
            } else {
                typeLabel.isHidden = true
            }
        case .video:
            typeLabel.text = "视频"
            typeLabel.isHidden = false
        default:
            typeLabel.isHidden = true
        }
        
        // 加载缩略图，使用更大的尺寸确保质量
        let targetSize = CGSize(width: frame.width * 3, height: frame.height * 3) // 3x for retina
        
        print("开始加载缩略图，尺寸: \(targetSize), 资源类型: \(asset.mediaType.rawValue)")
        
        photoManager.getImage(for: asset, targetSize: targetSize) { [weak self] image in
            print("缩略图加载完成: \(image != nil)")
            self?.imageView.image = image
            if image != nil {
                self?.imageView.backgroundColor = .clear
            }
        }
    }
} 

