import XCTest
@testable import PhotoSlideshow

class ViewControllerTests: XCTestCase {
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
    
    func test_whenViewDidLoad_shouldDisplayWelcomeLabel() {
        // Given
        let expectedText = "欢迎使用 PhotoSlideshow"
        
        // When
        sut.viewDidLoad()
        
        // Then
        let label = sut.view.subviews.first { $0 is UILabel } as? UILabel
        XCTAssertNotNil(label, "应该存在一个标签")
        XCTAssertEqual(label?.text, expectedText, "标签文本应该匹配预期文本")
        XCTAssertEqual(label?.textAlignment, .center, "文本应该居中对齐")
    }
} 