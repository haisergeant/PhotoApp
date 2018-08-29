//
//  PhotosViewModel.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/30/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

struct PhotosViewModel {
    func save(image: UIImage, name: String) {
        DataManager.shared.save(image: image, name: name)
    }
}
