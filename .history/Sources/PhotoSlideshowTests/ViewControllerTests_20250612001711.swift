import XCTest
@testable import PhotoSlideshow

final class ViewControllerTests: XCTestCase {
    var sut: ViewController!
    
    override func setUp() {
        super.setUp()
        sut = ViewController()
        sut.loadViewIfNeeded()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_helloWorldLabel_shouldExist() {
        XCTAssertNotNil(sut.helloWorldLabel)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectText() {
        XCTAssertEqual(sut.helloWorldLabel.text, "Hello World")
    }
    
    func test_helloWorldLabel_shouldHaveCorrectAlignment() {
        XCTAssertEqual(sut.helloWorldLabel.textAlignment, .center)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectTextColorInLightMode() {
        // 设置浅色模式
        sut.overrideUserInterfaceStyle = .light
        
        // 触发视图更新
        sut.view.layoutIfNeeded()
        
        // 验证文本颜色
        XCTAssertEqual(sut.helloWorldLabel.textColor, .black)
    }
    
    func test_helloWorldLabel_shouldHaveCorrectTextColorInDarkMode() {
        // 设置深色模式
        sut.overrideUserInterfaceStyle = .dark
        
        // 触发视图更新
        sut.view.layoutIfNeeded()
        
        // 验证文本颜色
        XCTAssertEqual(sut.helloWorldLabel.textColor, .white)
    }
    
    func test_view_shouldHaveCorrectBackgroundColorInLightMode() {
        sut.overrideUserInterfaceStyle = .light
        sut.traitCollectionDidChange(nil)
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
    }
    
    func test_view_shouldHaveCorrectBackgroundColorInDarkMode() {
        sut.overrideUserInterfaceStyle = .dark
        sut.traitCollectionDidChange(nil)
        XCTAssertEqual(sut.view.backgroundColor, .systemBackground)
    }
    
    // 新添加的测试用例：验证强制颜色设置
    func test_view_shouldHaveForceWhiteBackground() {
        // 强制设置白色背景，不管系统模式如何
        sut.setForceWhiteBackground()
        
        XCTAssertEqual(sut.view.backgroundColor, .white)
    }
    
    func test_helloWorldLabel_shouldHaveForceBlackText() {
        // 强制设置黑色文字，不管系统模式如何
        sut.setForceBlackText()
        
        XCTAssertEqual(sut.helloWorldLabel.textColor, .black)
    }
    
    func test_viewShouldHaveVisibleColors() {
        // 测试视图有明显的可见颜色对比
        sut.setHighContrastColors()
        
        // 验证背景是白色，文字是黑色，确保有强烈对比
        XCTAssertEqual(sut.view.backgroundColor, .white)
        XCTAssertEqual(sut.helloWorldLabel.textColor, .black)
        
        // 额外验证：确保标签有足够大的字体
        XCTAssertGreaterThanOrEqual(sut.helloWorldLabel.font.pointSize, 24.0)
    }
} 