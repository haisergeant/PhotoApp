//
//  BaseCollectionViewCell.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/31/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
        
        self.configureSubviews()
        self.configureLayout()
        self.configureContent()
        self.configureStyle()
        self.configureActions()
    }
    
    func initialize() {}
    func configureSubviews() {}
    func configureLayout() {}
    func configureContent() {}
    func configureStyle() {}
    func configureActions() {}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
