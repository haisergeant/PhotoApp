//
//  Repository.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 9/2/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol Repository {
    func uploadData(data: Data, fileName: String) -> Observable<Bool>
}
