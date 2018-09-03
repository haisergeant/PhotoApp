//
//  ImageCollectionViewCell.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/31/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import EasyPeasy
import PHDiff

struct ImageViewModel: Diffable {
    let name: String
    let thumbnailUrl: URL
    let url: URL
    
    var diffIdentifier: String {
        return name
    }
}

class ImageCollectionViewCell: BaseCollectionViewCell {
    let imageView = UIImageView()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.contentView.addSubview(self.imageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        self.imageView.easy.layout(
            Edges(4)
        )
    }
    
    override func configureStyle() {
        super.configureStyle()
        self.imageView.layer.borderWidth = 1
        self.imageView.layer.cornerRadius = 4
        self.imageView.layer.borderColor = UIColor.clear.cgColor
        self.imageView.layer.masksToBounds = true
        self.imageView.contentMode = .scaleAspectFill
    }
    
    func configure(with model: ImageViewModel) {
        self.imageView.image(for: model.thumbnailUrl)        
    }
}
