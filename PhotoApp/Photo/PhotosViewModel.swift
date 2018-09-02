//
//  PhotosViewModel.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/30/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PhotosViewModel {
    var imageModels = BehaviorSubject<[ImageViewModel]>(value: [ImageViewModel]())
    let dataManager = DataManager.shared
    
    func save(image: UIImage, name: String) {
        DispatchQueue.global(qos: .background).async {
            guard let scaledImage = image.resized(to: 120) else { return }
            PhotoManager.shared.save(image: scaledImage, folder: "Thumbnails", name: name) { value in
                DispatchQueue.main.async { [weak self] in
                    guard let images = self?.loadImages() else { return }
                    self?.imageModels.onNext(images)
                }
            }
            PhotoManager.shared.save(image: image, folder: "Photos", name: name) { filePath in
                dataManager.addRecord(image: image, filePath: filePath)
            }
        }        
    }
    
    func retrieveImages() {
        self.imageModels.onNext(self.loadImages())
    }
    
    private func loadImages() -> [ImageViewModel] {
        let urls = PhotoManager.shared.retrievePhoto(folder: "Thumbnails")
        let result = urls.map { url -> ImageViewModel in
            let name = url.lastPathComponent
            let folderUrl = url.deletingLastPathComponent()
            let appUrl = folderUrl.deletingLastPathComponent()
            let fullNameUrl = appUrl.appendingPathComponent("Photos").appendingPathComponent(name)
            return ImageViewModel(name: url.lastPathComponent, thumbnailUrl: url, url: fullNameUrl) }
        return result
    }
}
