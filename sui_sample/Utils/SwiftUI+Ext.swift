//
//  SwiftUI+Ext.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func maximumWidth() -> some View {
        self.frame(minWidth: 0, idealWidth: 12000, maxWidth: 12000)
    }
    
    func maximumHeight() -> some View {
        self.frame(minHeight: 0, idealHeight: 12000, maxHeight: 12000)
    }
}
