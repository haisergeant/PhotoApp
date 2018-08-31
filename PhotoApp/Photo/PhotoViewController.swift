//
//  PhotoViewController.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 9/1/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import EasyPeasy

class PhotoViewController: BaseViewController {
    let scrollView = UIScrollView()
    let contentView = UIView()
    let imageView = UIImageView()
    let imageModel: ImageViewModel
    init(imageModel: ImageViewModel) {
        self.imageModel = imageModel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureSubviews() {
        super.configureSubviews()
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(contentView)
        self.view.addSubview(imageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        self.scrollView.easy.layout(Edges())
        self.contentView.easy.layout(Edges(), Size())
        self.imageView.easy.layout(Edges())
    }
    
    override func configureStyle() {
        super.configureStyle()
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 3
        
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    override func shouldHideNavigationBar() -> Bool {
        return false
    }
    
    override func configureContent() {
        super.configureContent()
        imageView.image(for: imageModel.url)
    }
}
