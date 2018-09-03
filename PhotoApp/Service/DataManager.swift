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
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { [weak self] (timer) in
                self?.configureUploadOperation()
            })
        }
    }
    
    func saveUnuploadedList() {
        self.writeToFile(text: savingList.joined(separator: "\n"), fileName: "data.txt")
    }
    
    func addRecord(data: Data, filePath: String) {
        self.savingList.append(filePath)
        
        let fileName = URL(fileURLWithPath: filePath).lastPathComponent
        let operation = UploadOperation(data: data, fileName: fileName) { (success) in
            self.savingList = self.savingList.filter { $0 != filePath }
        }
        self.operationQueue.addOperation(operation)
    }
    
    private func configureUploadOperation() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            self?.savingList.forEach { (filePath) in
                guard let url = URL(string: filePath) else { return }
                do {
                    let data = try Data(contentsOf: url)
                    self?.addRecord(data: data, filePath: filePath)
                } catch {
                    print(error)
                }
                
            }
        }
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
    var completion: ((Bool) -> Void)?
    
    let sema = DispatchSemaphore(value: 0)
    let repository = ServerRepository.shared
    let disposeBag = DisposeBag()
    
    init(data: Data, fileName: String, completion: ((Bool) -> Void)? = nil) {
        self.data = data
        self.fileName = fileName
        self.completion = completion
    }
    
    override func main() {
        self.repository.uploadData(data: data, fileName: fileName)
            .subscribe(onNext: { [weak self] (success) in
                // Upload success, remove record
                guard let `self` = self else { return }
                self.completion?(success)
                self.sema.signal()
            }, onError: { (error) in
                // Upload fail, try again later
                self.sema.signal()
            }).disposed(by: disposeBag)
        sema.wait()
    }
}


