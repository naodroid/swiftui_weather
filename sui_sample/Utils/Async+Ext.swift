//
//  Async+Ext.swift
//  sui_sample
//
//  Created by 坂本尚嗣 on 2021/07/17.
//  Copyright © 2021 naodroid. All rights reserved.
//

import Foundation

extension Task {
    /// Currently Task.sleep(_:) causes crashes, so created own method to avoid this issue.
    /// https://bugs.swift.org/browse/SR-14375
    static func sleep(forSeconds seconds: TimeInterval) async {
        await AsyncSleeper().sleep(forSeconds: seconds)
    }
}


private struct AsyncSleeper {
    func sleep(forSeconds seconds: TimeInterval) async {
        typealias SleepContinuation = CheckedContinuation<Void, Error>
        do {
        try await withCheckedThrowingContinuation { (continuation:  SleepContinuation) in
                  DispatchQueue.global().asyncAfter(deadline: .now() + seconds) {
                      continuation.resume(with: .success(()))
              }
          }
        } catch {
        }
    }
}
