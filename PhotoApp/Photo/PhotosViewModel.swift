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
    
    func save(image: UIImage, name: String) {
        DispatchQueue.global(qos: .background).async {
            guard let scaledImage = image.resized(to: 80) else { return }
            PhotoManager.shared.save(image: scaledImage, folder: "Thumbnails", name: name) {
                DispatchQueue.main.async { [weak self] in
                    guard let images = self?.loadImages() else { return }
                    self?.imageModels.onNext(images)
                }
            }
            PhotoManager.shared.save(image: image, folder: "Photos", name: name)
        }        
    }
    
    func retrieveImages() {
        self.imageModels.onNext(self.loadImages())
    }
    
    private func loadImages() -> [ImageViewModel] {
        let urls = PhotoManager.shared.retrievePhoto(folder: "Thumbnails")
        let result = urls.map { ImageViewModel(url: $0) }
        return result
    }
}
