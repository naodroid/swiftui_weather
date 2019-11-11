//
//  Combine+Ext.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine

extension Publisher {
    func onMainThread() -> AnyPublisher<Self.Output, Self.Failure> {
        return self.receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
