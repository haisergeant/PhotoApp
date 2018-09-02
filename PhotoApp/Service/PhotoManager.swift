//
//  DataManager.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/30/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhotoManager {
    static let shared = PhotoManager()
    private var fileUrls = [URL]()
    
    func save(image: UIImage, folder: String, name: String, completion: ((String) -> Void)? = nil) {
        if let data = UIImageJPEGRepresentation(image, 1.0) {
            self.save(with: data, folder: folder, fileName: name, completion: completion)
        }     
    }
    
    func retrievePhoto(folder: String) -> [URL] {
        do {
            let folderName = self.documentPath().appendingPathComponent(folder)
            let list = try FileManager.default.contentsOfDirectory(at: folderName,
                                                                   includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.contentModificationDateKey],
                                                                   options: .skipsHiddenFiles)
            
            let filterList = try list.filter { $0.pathExtension.lowercased() == "png" ||
                $0.pathExtension.lowercased() == "jpg" ||
                $0.pathExtension.lowercased() == "jpeg" }.sorted { (first, second) -> Bool in
                    guard let firstDate = try first.resourceValues(forKeys: [URLResourceKey.nameKey]).name,
                        let secondDate = try second.resourceValues(forKeys: [URLResourceKey.nameKey]).name else { return false }
                    return firstDate < secondDate
            }
            return filterList            
        } catch {
            print(error)
            return [URL]()
        }
    }
    
    private func documentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func save(with data: Data,
                      folder: String,
                      fileName: String,
                      completion: ((String) -> Void)? = nil) {
        do {
            let folderName = self.documentPath().appendingPathComponent(folder)
            try FileManager.default.createDirectory(at: folderName,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            let absoluteName = folderName.appendingPathComponent(fileName)
            try data.write(to: absoluteName)
            completion?(absoluteName.absoluteString)
        } catch {
            print(error)
        }
        
    }
}
