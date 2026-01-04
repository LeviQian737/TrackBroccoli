//
//  Item.swift
//  Let's学
//
//  Created by Qian dede on 1/4/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
