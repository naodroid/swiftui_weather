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
        return self.delay(for: 0.0, scheduler: MainThreadScheduler.shared)
            .eraseToAnyPublisher()
    }
}
