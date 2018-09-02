//
//  ServerRepository.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 9/2/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import RxSwift
import RxCocoa

enum APIError: Error {
    case uploadFail
    case unavailableNetwork
}

class ServerRepository: Repository {
    static let shared = ServerRepository()
    
    func uploadData(data: Data, fileName: String) -> Observable<Bool> {
        return Observable.create{ observer -> Disposable in
            DispatchQueue.global(qos: .background).async {
                let seconds = UInt32(arc4random_uniform(10) + 1)
                sleep(seconds)
                if seconds > 5 {
                    observer.onError(APIError.uploadFail)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
    }
}
