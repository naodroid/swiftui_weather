//
//  MainThreadScheduler.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine

/// extend for used in Scheduler
extension TimeInterval: SchedulerTimeIntervalConvertible {
    public static func seconds(_ s: Int) -> TimeInterval {
        return TimeInterval(s)
    }

    public static func seconds(_ s: Double) -> TimeInterval {
        return TimeInterval(s)
    }

    public static func milliseconds(_ ms: Int) -> TimeInterval {
        return TimeInterval(ms) / 1_000.0
    }

    public static func microseconds(_ us: Int) -> TimeInterval {
        return TimeInterval(us) / 1_000_000.0
    }

    public static func nanoseconds(_ ns: Int) -> TimeInterval {
        return TimeInterval(ns) / 1_000_000_000.0
    }
}
///
struct MainThreadScheduler: Scheduler {
    static let shared = MainThreadScheduler()

    var now: MainThreadScheduler.SchedulerTimeType {
        return SchedulerTimeType(value: Date().timeIntervalSince1970)
    }

    var minimumTolerance: MainThreadScheduler.SchedulerTimeType.Stride {
        return TimeInterval(0.01)
    }

    typealias SchedulerOptions = Never

    struct SchedulerTimeType: Strideable {
        typealias Stride = TimeInterval
        let value: TimeInterval

        func distance(to other: MainThreadScheduler.SchedulerTimeType) -> TimeInterval {
            return self.value - other.value
        }

        func advanced(by n: TimeInterval) -> MainThreadScheduler.SchedulerTimeType {
            return SchedulerTimeType(value: self.value + n)
        }
    }
    //
    func schedule(options: Never?, _ action: @escaping () -> Void) {
        if Thread.isMainThread {
            action()
        } else {
            DispatchQueue.main.sync {
                action()
            }
        }
    }
    func schedule(after date: MainThreadScheduler.SchedulerTimeType,
                  tolerance: TimeInterval,
                  options: Never?,
                  _ action: @escaping () -> Void) {
        let diff = date.value - MainThreadScheduler.shared.now.value
        if Thread.isMainThread {
            action()
            return
        }
        //when I used DisaptchQueue.main.async, nothing happend
        //in cction() method calling.
        //I can't understand. but it happened.
        //So I use sync method
        if diff > 0 {
            Thread.sleep(forTimeInterval: diff)
        }
        DispatchQueue.main.sync {
            action()
        }
    }
    func schedule(after date: MainThreadScheduler.SchedulerTimeType,
                  interval: TimeInterval,
                  tolerance: TimeInterval,
                  options: Never?,
                  _ action: @escaping () -> Void) -> Cancellable {
        var cancelled = false
        if Thread.isMainThread {
            action()
        } else {
            let diff = date.value - MainThreadScheduler.shared.now.value
            if diff > 0 {
                Thread.sleep(forTimeInterval: diff)
            }
            if !cancelled {
                DispatchQueue.main.sync {
                    action()
                }
            }
        }
        return AnyCancellable {
            cancelled = true
        }
    }
}
