//
//  UIImageExtension.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/31/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(percentage: CGFloat) -> UIImage? {
        let newSize = CGSize(width: self.size.width * percentage, height: self.size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func resized(to newWidth: CGFloat) -> UIImage? {
        let newSize = CGSize(width: newWidth, height: newWidth / self.size.width * self.size.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
