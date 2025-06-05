import Foundation
import UIKit
import AVFoundation

// MARK: - 媒体管理服务
class MediaManager {
    static let shared = MediaManager()
    
    private let fileManager = FileManager.default
    private let mediaDirectory: URL
    private let thumbnailDirectory: URL
    
    private var mediaItems: [MediaItem] = []
    
    private init() {
        let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        mediaDirectory = documentsPath.appendingPathComponent("media")
        thumbnailDirectory = documentsPath.appendingPathComponent("thumbnails")
        
        createDirectoriesIfNeeded()
        loadMediaItems()
    }
    
    // MARK: - 目录管理
    private func createDirectoriesIfNeeded() {
        [mediaDirectory, thumbnailDirectory].forEach { directory in
            if !fileManager.fileExists(atPath: directory.path) {
                try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
            }
        }
    }
    
    // MARK: - 保存媒体
    func saveImage(_ image: UIImage, completion: @escaping (Result<MediaItem, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 生成文件名
                let timestamp = Int(Date().timeIntervalSince1970)
                let filename = "photo_\(timestamp).jpg"
                let fileURL = self.mediaDirectory.appendingPathComponent(filename)
                
                // 压缩并保存图片
                guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                    DispatchQueue.main.async {
                        completion(.failure(MediaError.compressionFailed))
                    }
                    return
                }
                
                try imageData.write(to: fileURL)
                
                // 创建缩略图
                let thumbnailFilename = self.createThumbnail(from: image, originalFilename: filename)
                
                // 获取宝宝年龄
                let babyAge = self.calculateBabyAge()
                
                // 创建媒体项目
                var mediaItem = MediaItem(
                    filename: filename,
                    type: .photo,
                    fileSize: Int64(imageData.count),
                    babyAge: babyAge
                )
                mediaItem.thumbnailPath = thumbnailFilename
                
                // 保存到列表
                DispatchQueue.main.async {
                    self.mediaItems.append(mediaItem)
                    self.saveMediaItems()
                    completion(.success(mediaItem))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func saveVideo(from url: URL, completion: @escaping (Result<MediaItem, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                // 生成文件名
                let timestamp = Int(Date().timeIntervalSince1970)
                let filename = "video_\(timestamp).mp4"
                let fileURL = self.mediaDirectory.appendingPathComponent(filename)
                
                // 复制视频文件
                try self.fileManager.copyItem(at: url, to: fileURL)
                
                // 获取文件大小
                let attributes = try self.fileManager.attributesOfItem(atPath: fileURL.path)
                let fileSize = attributes[.size] as? Int64 ?? 0
                
                // 创建视频缩略图
                let thumbnailFilename = self.createVideoThumbnail(from: fileURL, originalFilename: filename)
                
                // 获取宝宝年龄
                let babyAge = self.calculateBabyAge()
                
                // 创建媒体项目
                var mediaItem = MediaItem(
                    filename: filename,
                    type: .video,
                    fileSize: fileSize,
                    babyAge: babyAge
                )
                mediaItem.thumbnailPath = thumbnailFilename
                
                // 保存到列表
                DispatchQueue.main.async {
                    self.mediaItems.append(mediaItem)
                    self.saveMediaItems()
                    completion(.success(mediaItem))
                }
                
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - 缩略图创建
    private func createThumbnail(from image: UIImage, originalFilename: String) -> String? {
        let thumbnailSize = CGSize(width: 200, height: 200)
        
        UIGraphicsBeginImageContextWithOptions(thumbnailSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: thumbnailSize))
        let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let thumbnail = thumbnailImage,
              let thumbnailData = thumbnail.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        let thumbnailFilename = "thumb_\(originalFilename)"
        let thumbnailURL = thumbnailDirectory.appendingPathComponent(thumbnailFilename)
        
        do {
            try thumbnailData.write(to: thumbnailURL)
            return thumbnailFilename
        } catch {
            print("Failed to save thumbnail: \(error)")
            return nil
        }
    }
    
    private func createVideoThumbnail(from videoURL: URL, originalFilename: String) -> String? {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 1.0, preferredTimescale: 600)
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            let image = UIImage(cgImage: cgImage)
            return createThumbnail(from: image, originalFilename: originalFilename)
        } catch {
            print("Failed to create video thumbnail: \(error)")
            return nil
        }
    }
    
    // MARK: - 媒体获取
    func getAllMediaItems() -> [MediaItem] {
        return mediaItems.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getMediaItem(by id: UUID) -> MediaItem? {
        return mediaItems.first { $0.id == id }
    }
    
    func getImage(for mediaItem: MediaItem) -> UIImage? {
        guard mediaItem.type == .photo else { return nil }
        let fileURL = mediaItem.getFileURL()
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func getThumbnail(for mediaItem: MediaItem) -> UIImage? {
        guard let thumbnailURL = mediaItem.getThumbnailURL() else { return nil }
        return UIImage(contentsOfFile: thumbnailURL.path)
    }
    
    func getVideoURL(for mediaItem: MediaItem) -> URL? {
        guard mediaItem.type == .video else { return nil }
        return mediaItem.getFileURL()
    }
    
    // MARK: - 媒体更新
    func updateMediaItem(_ mediaItem: MediaItem) {
        if let index = mediaItems.firstIndex(where: { $0.id == mediaItem.id }) {
            mediaItems[index] = mediaItem
            saveMediaItems()
        }
    }
    
    func deleteMediaItem(_ mediaItem: MediaItem) -> Bool {
        do {
            // 删除主文件
            let fileURL = mediaItem.getFileURL()
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
            }
            
            // 删除缩略图
            if let thumbnailURL = mediaItem.getThumbnailURL(),
               fileManager.fileExists(atPath: thumbnailURL.path) {
                try fileManager.removeItem(at: thumbnailURL)
            }
            
            // 从列表中移除
            mediaItems.removeAll { $0.id == mediaItem.id }
            saveMediaItems()
            
            return true
        } catch {
            print("Failed to delete media item: \(error)")
            return false
        }
    }
    
    // MARK: - 筛选和搜索
    func getMediaItems(by type: MediaType) -> [MediaItem] {
        return mediaItems.filter { $0.type == type }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getMediaItems(with status: AnalysisStatus) -> [MediaItem] {
        return mediaItems.filter { $0.analysisStatus == status }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getFavoriteMediaItems() -> [MediaItem] {
        return mediaItems.filter { $0.isFavorite }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func searchMediaItems(with keyword: String) -> [MediaItem] {
        let lowercaseKeyword = keyword.lowercased()
        return mediaItems.filter { mediaItem in
            mediaItem.filename.lowercased().contains(lowercaseKeyword) ||
            mediaItem.tags.contains { $0.lowercased().contains(lowercaseKeyword) }
        }.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getMediaItems(in dateRange: DateInterval) -> [MediaItem] {
        return mediaItems.filter { dateRange.contains($0.createdAt) }.sorted { $0.createdAt > $1.createdAt }
    }
    
    // MARK: - 统计信息
    func getMediaStatistics() -> MediaStatistics {
        let photos = mediaItems.filter { $0.type == .photo }
        let videos = mediaItems.filter { $0.type == .video }
        let analyzed = mediaItems.filter { $0.analysisStatus == .completed }
        
        let totalSize = mediaItems.reduce(0) { $0 + $1.fileSize }
        
        return MediaStatistics(
            totalItems: mediaItems.count,
            photoCount: photos.count,
            videoCount: videos.count,
            analyzedCount: analyzed.count,
            totalSizeBytes: totalSize,
            favoriteCount: mediaItems.filter { $0.isFavorite }.count
        )
    }
    
    // MARK: - 辅助方法
    private func calculateBabyAge() -> Int? {
        // 从DataManager获取宝宝生日
        guard let babyProfile = DataManager.shared.babyProfile else { return nil }
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.month], from: babyProfile.birthDate, to: Date())
        return ageComponents.month
    }
    
    // MARK: - 数据持久化
    private func loadMediaItems() {
        if let data = UserDefaults.standard.data(forKey: "MediaItems"),
           let items = try? JSONDecoder().decode([MediaItem].self, from: data) {
            mediaItems = items
        }
    }
    
    private func saveMediaItems() {
        if let data = try? JSONEncoder().encode(mediaItems) {
            UserDefaults.standard.set(data, forKey: "MediaItems")
        }
    }
}

// MARK: - 媒体错误
enum MediaError: Error, LocalizedError {
    case compressionFailed
    case saveFailed
    case fileNotFound
    case unsupportedFormat
    case insufficientSpace
    
    var errorDescription: String? {
        switch self {
        case .compressionFailed:
            return "圖片壓縮失敗"
        case .saveFailed:
            return "保存失敗"
        case .fileNotFound:
            return "文件未找到"
        case .unsupportedFormat:
            return "不支持的文件格式"
        case .insufficientSpace:
            return "存儲空間不足"
        }
    }
}

// MARK: - 媒体统计
struct MediaStatistics {
    let totalItems: Int
    let photoCount: Int
    let videoCount: Int
    let analyzedCount: Int
    let totalSizeBytes: Int64
    let favoriteCount: Int
    
    var totalSizeMB: Double {
        return Double(totalSizeBytes) / (1024 * 1024)
    }
    
    var analysisProgress: Double {
        guard totalItems > 0 else { return 0 }
        return Double(analyzedCount) / Double(totalItems)
    }
} 