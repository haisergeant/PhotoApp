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
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.imageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        self.scrollView.easy.layout(
            Top(),
            Left(),
            Bottom(),
            Width().like(self.view)
        )
        self.imageView.easy.layout(
            Edges(),
            Width().like(self.view),
            Height().like(self.scrollView)
        )
    }
    
    override func configureStyle() {
        super.configureStyle()
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 3
        self.scrollView.delegate = self
        
        self.imageView.contentMode = .scaleAspectFit
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

extension PhotoViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
