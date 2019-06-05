//
//  Area.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

struct Area: Identifiable {
    let id: String
    let name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
