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
import Photos

class PhotosViewController: BaseViewController {
    
    // UI components
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    let addButton = UIButton()
    
    // View Model
    let viewModel = PhotosViewModel()
    var list = [ImageViewModel]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        addButton.setTitle("Take photo", for: .normal)
        viewModel.imageModels.subscribe(onNext: { models in
            self.list = models
        }).disposed(by: rx.disposeBag)
        
        viewModel.loadImage()
    }
    
    override func configureActions() {
        super.configureActions()
        addButton.rx.controlEvent(.primaryActionTriggered).subscribe(onNext: { _ in
            let actionSheet = UIAlertController(title: "Add photo", message: "From", preferredStyle: .actionSheet)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraMediaType = AVMediaType.video
                let status = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
                if status != .authorized {
                    AVCaptureDevice.requestAccess(for: cameraMediaType, completionHandler: { (granted) in
                        if granted {
                            actionSheet.addAction(UIAlertAction(title: "From Camera", style: .default, handler: { (action) in
                                self.addPhoto(from: .camera)
                            }))
                        } else {
                            // TODO: show alert to let user change in Settings
                        }
                    })
                } else {
                    self.addPhoto(from: .camera)
                }
            }
            
            actionSheet.addAction(UIAlertAction(title: "From library", style: .default, handler: { (action) in
                let photos = PHPhotoLibrary.authorizationStatus()
                if photos != .authorized {
                    PHPhotoLibrary.requestAuthorization({status in
                        if status == .authorized{
                            self.addPhoto(from: .photoLibrary)
                        } else {
                            // TODO: show alert to let user change in Settings
                        }
                    })
                } else {
                    self.addPhoto(from: .photoLibrary)
                }
            }))
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            self.present(actionSheet, animated: true, completion: nil)
        }).disposed(by: rx.disposeBag)
    }
    
    private func addPhoto(from source: UIImagePickerControllerSourceType) {
        let controller = UIImagePickerController()
        controller.sourceType = source
        controller.allowsEditing = false
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
}

extension PhotosViewController: UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let fileName = String(Date().ticks) + ".png"
            self.viewModel.save(image: image, name: fileName)
        }
    }
}

extension PhotosViewController: UINavigationControllerDelegate {
    
}

extension PhotosViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            cell.configure(with: list[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
        
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width
        let cellWidth = width / 4.0
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 160, right: 0)
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

