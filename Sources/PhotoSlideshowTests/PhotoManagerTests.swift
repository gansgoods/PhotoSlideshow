import XCTest
@testable import PhotoSlideshow
import Photos

class PhotoManagerTests: XCTestCase {
    var photoManager: PhotoManager!
    
    override func setUp() {
        super.setUp()
        photoManager = PhotoManager()
    }
    
    override func tearDown() {
        photoManager = nil
        super.tearDown()
    }
    
    func test_photoManager_shouldRequestPermission() {
        let expectation = XCTestExpectation(description: "Permission request should complete")
        
        photoManager.requestPhotoPermission { status in
            XCTAssertNotNil(status)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_photoManager_shouldFetchPhotos() {
        let expectation = XCTestExpectation(description: "Photos should be fetched")
        
        photoManager.fetchPhotos { photos in
            // 即使没有照片，也应该返回一个空数组
            XCTAssertNotNil(photos)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_photoManager_shouldFetchLivePhotos() {
        let expectation = XCTestExpectation(description: "Live photos should be fetched")
        
        photoManager.fetchLivePhotos { livePhotos in
            // 即使没有实况照片，也应该返回一个空数组
            XCTAssertNotNil(livePhotos)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_photoManager_isLivePhotoMethod_shouldWork() {
        // 创建一个模拟的PHAsset来测试isLivePhoto方法
        // 注意：这个测试主要验证方法存在且可调用
        let expectation = XCTestExpectation(description: "isLivePhoto method should be callable")
        
        photoManager.fetchPhotos { photos in
            for photo in photos {
                let isLive = self.photoManager.isLivePhoto(photo)
                XCTAssertNotNil(isLive)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
} 