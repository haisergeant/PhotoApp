//
//  DataManager.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/30/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    func save(image: UIImage, name: String) {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            save(with: data, fileName: name)
        }        
    }
    
    private func documentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func save(with data: Data, fileName: String) {
        do {
            let absoluteName = documentPath().appendingPathComponent(fileName)
            try data.write(to: absoluteName)
        } catch {
            print(error)
        }
        
    }
}
