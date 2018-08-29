//
//  PhotosViewController.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/29/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import EasyPeasy
import RxSwift
import RxCocoa
import NSObject_Rx

class PhotosViewController: BaseViewController {
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 80, height: 80)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    let addButton = UIButton()
    
    override func configureSubviews() {
        super.configureSubviews()
        view.addSubview(collectionView)
        view.addSubview(addButton)
    }
    
    override func configureLayout() {
        super.configureLayout()
        collectionView.easy.layout(
            Edges()
        )
        
        addButton.easy.layout(
            Bottom(40),
            Height(40),
            CenterX()
        )
    }
    
    override func configureContent() {
        super.configureContent()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addButton.setTitle("Take photo", for: .normal)
    }
    
    override func configureActions() {
        super.configureActions()
        addButton.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { _ in
            
        }).disposed(by: rx.disposeBag)
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
        
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

