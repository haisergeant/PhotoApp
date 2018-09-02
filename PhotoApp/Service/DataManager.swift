//
//  DataManager.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 9/2/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DataManager {
    static let shared = DataManager()
    var savingList = [String]()
    let operationQueue = OperationQueue()
    
    init() {
        self.readFromFile(fileName: "data.txt") { (result) in
            self.savingList.append(contentsOf: result)
        }
    }
    
    func saveUnuploadedList() {
        self.writeToFile(text: savingList.joined(separator: "\n"), fileName: "data.txt")
    }
    
    func addRecord(image: UIImage, filePath: String) {
        guard let data = UIImageJPEGRepresentation(image, 1.0) else { return }
        self.savingList.append(filePath)
        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        let operation = UploadOperation(data: data, fileName: fileName)
        operation.completionBlock = {
            self.savingList = self.savingList.filter { $0 == filePath }
        }
        self.operationQueue.addOperation(operation)
    }
    
    private func documentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private func writeToFile(text: String, fileName: String, completion: (() -> Void)? = nil) {
        do {
            let fullPath = self.documentPath().appendingPathComponent(fileName)
            try text.write(to: fullPath, atomically: false, encoding: String.Encoding.utf8)
            completion?()
        } catch {
            print(error)
        }
    }
    
    private func readFromFile(fileName: String, completion: (([String]) -> Void)) {
        do {
            let fullPath = self.documentPath().appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: fullPath.absoluteString) {
                let content = try String(contentsOf: fullPath)
                let list = content.components(separatedBy: CharacterSet.newlines)
                completion(list)
            }
        } catch {
            print(error)
        }
    }
}

class UploadOperation: Operation {
    let data: Data
    let fileName: String
    
    let repository = ServerRepository.shared
    let disposeBag = DisposeBag()
    
    init(data: Data, fileName: String) {
        self.data = data
        self.fileName = fileName
    }
    
    override func main() {
        self.repository.uploadData(data: data, fileName: fileName)
            .subscribe(onNext: { (success) in
                // Upload success, remove record
            }, onError: { (error) in
                // Upload fail, try again later
            }).disposed(by: disposeBag)
    }
}


