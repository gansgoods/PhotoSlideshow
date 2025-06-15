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
} 