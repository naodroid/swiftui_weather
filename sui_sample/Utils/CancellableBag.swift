//
//  CancellableBag.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine

class CancellableBag {
    private var cancellables: [Cancellable] = []
    
    deinit {
        self.cancel()
    }
    
    func add(_ cancellable: Cancellable) {
        self.cancellables.append(cancellable)
    }
    func cancel() {
        let c = self.cancellables
        self.cancellables = []
        c.forEach { $0.cancel() }
    }
}

extension Cancellable {
    func cancel(by bag: CancellableBag) {
        bag.add(self)
    }
}

