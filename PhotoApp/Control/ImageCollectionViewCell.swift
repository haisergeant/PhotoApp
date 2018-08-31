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
    let name: String
    let thumbnailUrl: URL
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
            Edges(4)
        )
    }
    
    override func configureStyle() {
        super.configureStyle()
        imageView.layer.borderWidth = 1
        imageView.layer.cornerRadius = 4
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with model: ImageViewModel) {
        self.imageView.image(for: model.thumbnailUrl)        
    }
}
