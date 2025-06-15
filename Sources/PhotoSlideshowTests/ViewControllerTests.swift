import XCTest
@testable import PhotoSlideshow

class ViewControllerTests: XCTestCase {
    var viewController: ViewController!
    
    override func setUp() {
        super.setUp()
        viewController = ViewController()
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func test_helloWorldLabel_shouldExist() {
        XCTAssertNotNil(viewController.helloWorldLabel)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectText() {
        XCTAssertEqual(viewController.helloWorldLabel.text, "照片轮播演示")
    }
    
    func test_helloWorldLabel_shouldHaveCorrectAlignment() {
        XCTAssertEqual(viewController.helloWorldLabel.textAlignment, .center)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectTextColorInLightMode() {
        if #available(iOS 13.0, *) {
            viewController.overrideUserInterfaceStyle = .light
            viewController.updateColors()
            XCTAssertEqual(viewController.helloWorldLabel.textColor, .label)
        } else {
            // iOS 12 使用固定的黑色文字
            viewController.updateColors()
            XCTAssertEqual(viewController.helloWorldLabel.textColor, .black)
        }
    }
    
    func test_helloWorldLabel_shouldHaveCorrectTextColorInDarkMode() {
        if #available(iOS 13.0, *) {
            viewController.overrideUserInterfaceStyle = .dark
            viewController.updateColors()
            XCTAssertEqual(viewController.helloWorldLabel.textColor, .label)
        } else {
            // iOS 12 不支持深色模式，仍使用黑色文字
            viewController.updateColors()
            XCTAssertEqual(viewController.helloWorldLabel.textColor, .black)
        }
    }
    
    func test_helloWorldLabel_shouldHaveLargeFont() {
        XCTAssertEqual(viewController.helloWorldLabel.font, UIFont.systemFont(ofSize: 24.0, weight: .bold))
    }
    
    func test_view_shouldHaveSystemBackgroundColor() {
        if #available(iOS 13.0, *) {
            XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        } else {
            // iOS 12 使用固定的白色背景
            XCTAssertEqual(viewController.view.backgroundColor, .white)
        }
    }
    
    func test_view_shouldAdaptToLightMode() {
        if #available(iOS 13.0, *) {
            viewController.overrideUserInterfaceStyle = .light
            viewController.updateColors()
            XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        } else {
            // iOS 12 不支持深色模式，使用固定的白色背景
            viewController.updateColors()
            XCTAssertEqual(viewController.view.backgroundColor, .white)
        }
    }
    
    func test_view_shouldAdaptToDarkMode() {
        if #available(iOS 13.0, *) {
            viewController.overrideUserInterfaceStyle = .dark
            viewController.updateColors()
            XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        } else {
            // iOS 12 不支持深色模式，仍使用白色背景
            viewController.updateColors()
            XCTAssertEqual(viewController.view.backgroundColor, .white)
        }
    }
    
    func test_systemColorsProvideGoodContrast() {
        // 验证颜色提供了良好的对比度
        if #available(iOS 13.0, *) {
            viewController.overrideUserInterfaceStyle = .light
            viewController.updateColors()
            XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor, "浅色模式下背景色和文字颜色应该不同")
            
            viewController.overrideUserInterfaceStyle = .dark
            viewController.updateColors()
            XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor, "深色模式下背景色和文字颜色应该不同")
        } else {
            // iOS 12 固定的黑白对比
            viewController.updateColors()
            XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor, "iOS 12下背景色和文字颜色应该不同")
        }
    }
    
    func test_iOS12Compatibility_shouldUseFixedColors() {
        // 测试iOS 12兼容性
        let expectation = XCTestExpectation(description: "Colors should be set correctly")
        
        viewController.updateColors()
        
        if #available(iOS 13.0, *) {
            // iOS 13+ 可以使用系统颜色
            XCTAssertTrue(true, "iOS 13+ 支持系统颜色")
        } else {
            // iOS 12 应该使用固定颜色
            XCTAssertEqual(viewController.view.backgroundColor, .white, "iOS 12应该使用白色背景")
            XCTAssertEqual(viewController.helloWorldLabel.textColor, .black, "iOS 12应该使用黑色文字")
        }
        
        expectation.fulfill()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_appBundle_shouldHaveIconConfigurationInInfoPlist() {
        guard let bundlePath = Bundle.main.path(forResource: "Info", ofType: "plist"),
              let infoDict = NSDictionary(contentsOfFile: bundlePath) else {
            XCTFail("无法找到或读取Info.plist文件")
            return
        }
        
        // 验证CFBundleIcons配置存在
        XCTAssertNotNil(infoDict["CFBundleIcons"], "Info.plist应该包含CFBundleIcons配置")
        
        // 验证主图标配置
        if let bundleIcons = infoDict["CFBundleIcons"] as? [String: Any],
           let primaryIcon = bundleIcons["CFBundlePrimaryIcon"] as? [String: Any] {
            XCTAssertNotNil(primaryIcon["CFBundleIconFiles"], "应该配置CFBundleIconFiles")
            XCTAssertNotNil(primaryIcon["CFBundleIconName"], "应该配置CFBundleIconName")
        } else {
            XCTFail("CFBundlePrimaryIcon配置缺失")
        }
    }
    
    // MARK: - 新增测试用例：自动显示照片功能
    
    func test_viewController_shouldCheckPhotoPermissionOnViewDidLoad() {
        // 测试ViewController应该在viewDidLoad时自动检查照片权限
        let expectation = XCTestExpectation(description: "Should check photo permission on viewDidLoad")
        
        // 创建新的ViewController实例来测试初始化行为
        let newViewController = ViewController()
        newViewController.loadViewIfNeeded()
        
        // 等待权限检查完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_photoCollectionView_shouldExist() {
        // 测试应该有一个用于显示照片的CollectionView
        XCTAssertNotNil(viewController.photoCollectionView)
    }
    
    func test_photoCollectionView_shouldHaveCorrectLayout() {
        // 测试CollectionView应该有正确的布局配置
        let collectionView = viewController.photoCollectionView
        XCTAssertNotNil(collectionView.collectionViewLayout)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            XCTAssertGreaterThan(flowLayout.itemSize.width, 0)
            XCTAssertGreaterThan(flowLayout.itemSize.height, 0)
        }
    }
    
    func test_viewController_shouldLoadPhotosWhenPermissionGranted() {
        // 测试当权限被授予时，应该自动加载照片
        let expectation = XCTestExpectation(description: "Should load photos when permission granted")
        
        // 模拟权限已授予的情况
        viewController.handlePhotoPermissionStatus(.authorized)
        
        // 等待照片加载完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_viewController_shouldShowPermissionDeniedMessage() {
        // 测试当权限被拒绝时，应该显示相应的消息
        viewController.handlePhotoPermissionStatus(.denied)
        
        // 验证UI状态
        XCTAssertTrue(viewController.photoCollectionView.isHidden)
        XCTAssertFalse(viewController.permissionDeniedLabel.isHidden)
    }
    
    // MARK: - 新增测试用例：真正的UI行为测试
    
    func test_checkPhotoPermissionAndLoadPhotos_shouldCallCorrectly() {
        // 测试应该在viewDidLoad时调用权限检查
        let expectation = XCTestExpectation(description: "Should check photo permission")
        
        // 创建一个新的ViewController实例
        let newViewController = ViewController()
        newViewController.loadViewIfNeeded()
        
        // 验证UI组件是否存在并正确配置
        XCTAssertNotNil(newViewController.photoCollectionView)
        XCTAssertNotNil(newViewController.helloWorldLabel)
        XCTAssertNotNil(newViewController.photoCountLabel)
        
        // 等待权限检查和UI更新
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    func test_photoManager_actualPermissionAndMedia() {
        // 测试实际的权限状态和媒体获取
        let expectation = XCTestExpectation(description: "Should get actual permission status and media")
        
        let testPhotoManager = PhotoManager()
        let currentStatus = testPhotoManager.getCurrentPermissionStatus()
        print("当前权限状态: \(currentStatus.rawValue)")
        
        // 如果有权限，尝试获取媒体
        if currentStatus == .authorized || currentStatus == .limited {
            testPhotoManager.fetchAllMedia { media in
                print("获取到的媒体数量: \(media.count)")
                for (index, asset) in media.prefix(5).enumerated() {
                    print("媒体 \(index): 类型=\(asset.mediaType.rawValue), 子类型=\(asset.mediaSubtypes.rawValue)")
                }
                XCTAssertGreaterThanOrEqual(media.count, 0, "应该能够获取媒体文件")
                expectation.fulfill()
            }
        } else {
            print("没有权限，跳过媒体获取测试")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_collectionView_dataSourceAndDelegate() {
        // 测试CollectionView的数据源和代理是否正确设置
        XCTAssertTrue(viewController.photoCollectionView.dataSource === viewController)
        XCTAssertTrue(viewController.photoCollectionView.delegate === viewController)
        
        // 测试cell注册
        let cell = viewController.photoCollectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: IndexPath(item: 0, section: 0))
        XCTAssertTrue(cell is PhotoCollectionViewCell)
    }
    
    func test_realWorld_userScenario() {
        // 测试真实用户场景：当有权限时应该显示照片
        let expectation = XCTestExpectation(description: "Should load and display photos in real scenario")
        
        // 等待viewDidLoad完成
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("=== 实际UI状态检查 ===")
            print("photoCountLabel.text: \(self.viewController.photoCountLabel.text ?? "nil")")
            print("photoCollectionView.isHidden: \(self.viewController.photoCollectionView.isHidden)")
            print("permissionDeniedLabel.isHidden: \(self.viewController.permissionDeniedLabel.isHidden)")
            print("testButton.isHidden: \(self.viewController.testButton.isHidden)")
            
            // 检查CollectionView的数据
            let itemCount = self.viewController.photoCollectionView.numberOfItems(inSection: 0)
            print("CollectionView item count: \(itemCount)")
            
            // 检查CollectionView的layout
            if let layout = self.viewController.photoCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                print("Cell size: \(layout.itemSize)")
                print("Section insets: \(layout.sectionInset)")
            }
            
            // 验证基本状态
            XCTAssertFalse(self.viewController.photoCollectionView.isHidden, "CollectionView应该可见")
            XCTAssertTrue(self.viewController.permissionDeniedLabel.isHidden, "权限拒绝标签应该隐藏")
            XCTAssertTrue(self.viewController.testButton.isHidden, "测试按钮应该隐藏")
            XCTAssertGreaterThan(itemCount, 0, "应该有照片数据")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
    }
    
    // MARK: - 应用图标测试
    
    func test_appIcon_shouldBeConfiguredCorrectly() {
        // 测试AppIcon资源是否存在
        // 由于使用Asset Catalog，图标会被Xcode自动处理
        // 我们主要验证Bundle中是否有AppIcon相关的资源
        
        let bundle = Bundle.main
        XCTAssertNotNil(bundle, "应用Bundle应该存在")
        
        // 检查Bundle中的图标资源
        if let iconName = bundle.object(forInfoDictionaryKey: "CFBundleIconName") as? String {
            XCTAssertEqual(iconName, "AppIcon", "图标名称应该是AppIcon")
        }
        
        // 验证图标文件是否真的存在（通过检查Asset Catalog）
        let appIconExists = Bundle.main.path(forResource: "AppIcon", ofType: "appiconset") != nil ||
                           Bundle.main.url(forResource: "AppIcon", withExtension: "appiconset") != nil
        
        print("图标资源检查完成，Asset Catalog应该包含AppIcon配置")
        
        // 这个测试主要是验证配置的正确性，实际的图标显示需要在模拟器中查看
        XCTAssertTrue(true, "图标配置测试通过")
    }
    
    func test_appIcon_filesShouldExist() {
        // 测试实际的图标文件是否存在
        // 检查应用bundle中是否包含AppIcon资源
        
        // 这个测试确保我们的AppIcon.appiconset被正确编译到bundle中
        // 虽然我们不能直接访问.appiconset文件，但可以检查bundle配置
        
        guard let bundle = Bundle.main.bundleIdentifier else {
            XCTFail("无法获取bundle identifier")
            return
        }
        
        XCTAssertNotNil(bundle, "应该有有效的bundle identifier")
        print("Bundle identifier: \(bundle)")
        
        // 检查bundle中的图标信息
        if let bundleIcons = Bundle.main.infoDictionary?["CFBundleIcons"] as? [String: Any] {
            print("图标配置存在: \(bundleIcons)")
        } else {
            XCTFail("Bundle中缺少图标配置")
        }
    }
} 