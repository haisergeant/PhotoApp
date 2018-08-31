//
//  ImageCollectionViewCell.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/31/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import EasyPeasy

struct ImageViewModel {
    let url: URL
}

class ImageCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(imageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        self.imageView.easy.layout(
            Edges()
        )
    }
    
    func configure(with model: ImageViewModel) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: model.url)
                DispatchQueue.main.async { [weak self] in
                    self?.imageView.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
    }
}
