//
//  SwiftUI+Ext.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension BindableObject where Self.PublisherType.Output == Self, Self.PublisherType : Subject {
    func notifyUpdate() {
        self.didChange.send(self)
    }
}
