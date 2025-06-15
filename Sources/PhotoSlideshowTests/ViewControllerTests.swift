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
        XCTAssertEqual(viewController.helloWorldLabel.font, UIFont.systemFont(ofSize: 32.0, weight: .bold))
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
} 