//
//  DateExtension.swift
//  PhotoApp
//
//  Created by Hai Le Thanh on 8/30/18.
//  Copyright © 2018 Hai Le Thanh. All rights reserved.
//

import UIKit

extension Date {
    var ticks: UInt64 {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }
}
