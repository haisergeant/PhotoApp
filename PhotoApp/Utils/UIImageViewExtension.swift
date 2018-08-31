//
//  UIImageViewExtension.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 9/1/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

extension UIImageView {
    func image(for url: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async { [weak self] in
                    self?.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
    }
}
