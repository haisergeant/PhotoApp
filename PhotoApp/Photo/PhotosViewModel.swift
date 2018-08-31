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
            PhotoManager.shared.save(image: image, folder: "Photos", name: name) { [weak self] in
                guard let images = self?.loadImage() else { return }
                self?.imageModels.onNext(images)
            }
        }        
    }
    
    func loadImage() -> [ImageViewModel] {
        let urls = PhotoManager.shared.retrievePhoto(folder: "Photos")
        let result = urls.map { ImageViewModel(url: $0) }
        return result
    }
}
