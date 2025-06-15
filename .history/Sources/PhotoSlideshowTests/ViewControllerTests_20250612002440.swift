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
    
    func test_view_shouldHaveSystemBackgroundColor() {
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
    }
    
    func test_view_shouldAdaptToLightMode() {
        viewController.overrideUserInterfaceStyle = .light
        viewController.updateColors()
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        XCTAssertEqual(viewController.helloWorldLabel.textColor, .label)
    }
    
    func test_view_shouldAdaptToDarkMode() {
        viewController.overrideUserInterfaceStyle = .dark
        viewController.updateColors()
        XCTAssertEqual(viewController.view.backgroundColor, .systemBackground)
        XCTAssertEqual(viewController.helloWorldLabel.textColor, .label)
    }
    
    func test_helloWorldLabel_shouldHaveLargeFont() {
        XCTAssertEqual(viewController.helloWorldLabel.font, UIFont.systemFont(ofSize: 32.0, weight: .bold))
    }
    
    func test_systemColorsProvideGoodContrast() {
        // 在浅色模式下测试对比度
        viewController.overrideUserInterfaceStyle = .light
        viewController.updateColors()
        XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor)
        
        // 在深色模式下测试对比度
        viewController.overrideUserInterfaceStyle = .dark
        viewController.updateColors()
        XCTAssertNotEqual(viewController.view.backgroundColor, viewController.helloWorldLabel.textColor)
    }
} 