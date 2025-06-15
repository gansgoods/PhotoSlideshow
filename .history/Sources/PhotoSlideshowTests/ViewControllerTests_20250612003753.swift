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
        XCTAssertEqual(viewController.helloWorldLabel.text, "Hello World")
    }
    
    func test_helloWorldLabel_shouldHaveCorrectAlignment() {
        XCTAssertEqual(viewController.helloWorldLabel.textAlignment, .center)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectTextColorInLightMode() {
        viewController.overrideUserInterfaceStyle = .light
        viewController.updateColors()
        XCTAssertEqual(viewController.helloWorldLabel.textColor, .label)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectTextColorInDarkMode() {
        viewController.overrideUserInterfaceStyle = .dark
        viewController.updateColors()
        XCTAssertEqual(viewController.helloWorldLabel.textColor, .label)
    }
    
    func test_helloWorldLabel_shouldHaveLargeFont() {
        XCTAssertEqual(viewController.helloWorldLabel.font, UIFont.systemFont(ofSize: 32.0, weight: .bold))
    }
    
    func test_view_shouldHaveSystemBackgroundColor() {
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
    }
    
    func test_view_shouldAdaptToLightMode() {
        viewController.overrideUserInterfaceStyle = .light
        viewController.updateColors()
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
    }
    
    func test_view_shouldAdaptToDarkMode() {
        viewController.overrideUserInterfaceStyle = .dark
        viewController.updateColors()
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
    }
    
    func test_systemColorsProvideGoodContrast() {
        // 验证系统颜色提供了良好的对比度
        viewController.overrideUserInterfaceStyle = .light
        viewController.updateColors()
        XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor, "浅色模式下背景色和文字颜色应该不同")
        
        viewController.overrideUserInterfaceStyle = .dark
        viewController.updateColors()
        XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor, "深色模式下背景色和文字颜色应该不同")
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
} 