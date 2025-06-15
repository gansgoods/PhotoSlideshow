import Foundation
import Photos
import UIKit

class PhotoManager {
    
    // 请求照片权限
    func requestPhotoPermission(completion: @escaping (PHAuthorizationStatus) -> Void) {
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    completion(status)
                }
            }
        }
    }
    
    // 检查当前照片权限状态
    func getCurrentPermissionStatus() -> PHAuthorizationStatus {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: .readWrite)
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }
    
    // 获取所有媒体文件（照片、实况照片和视频）
    func fetchAllMedia(completion: @escaping ([PHAsset]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // 不限制数量，获取所有媒体
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        
        DispatchQueue.main.async {
            completion(assets)
        }
    }
    
    // 获取所有照片（包括实况照片）- 更新为不限制数量
    func fetchPhotos(completion: @escaping ([PHAsset]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // 移除数量限制，获取所有照片
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        
        DispatchQueue.main.async {
            completion(assets)
        }
    }
    
    // 获取实况照片
    func fetchLivePhotos(completion: @escaping ([PHAsset]) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.predicate = NSPredicate(format: "mediaSubtypes & %d != 0", PHAssetMediaSubtype.photoLive.rawValue)
        
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        var livePhotos: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            livePhotos.append(asset)
        }
        
        DispatchQueue.main.async {
            completion(livePhotos)
        }
    }
    
    // 获取普通图片
    func getImage(for asset: PHAsset, targetSize: CGSize, completion: @escaping (UIImage?) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    // 获取实况照片
    @available(iOS 9.1, *)
    func getLivePhoto(for asset: PHAsset, targetSize: CGSize, completion: @escaping (PHLivePhoto?) -> Void) {
        let imageManager = PHImageManager.default()
        let options = PHLivePhotoRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.isNetworkAccessAllowed = true
        
        imageManager.requestLivePhoto(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { livePhoto, _ in
            DispatchQueue.main.async {
                completion(livePhoto)
            }
        }
    }
    
    // 检查是否为实况照片
    func isLivePhoto(_ asset: PHAsset) -> Bool {
        return asset.mediaSubtypes.contains(.photoLive)
    }
} 