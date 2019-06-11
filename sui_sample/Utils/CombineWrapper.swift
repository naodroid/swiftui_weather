//
//  CombineWrapper.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/11.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine


/// PropertyWrapper for reducing  boilerplate code in Repositories.
/// Motivation:
/// in repositories, I created some pairs of `CurrentValueState`(or Passthrough) and `AnyPublisher`.
/// CurrentStateValue : for storing value, private-variable
/// AnyPublisher: for listeners. public variable
/// and alwais connect 2 variables
///
/// This wrapper will create `CurrentStateValue` automatically.
/// and you can get/set value with `$vareName.get()/set(_)` methods.
///
/// Example
/// class Repository {
///     @WithValue(0) var count: AnyPublisher<Int, Never>
///     func countUp() {    self.$count.set(count.get() + 1) }
/// }
/// class ViewModel : BindableObject {
///     let repository = Repository()
///     var count: Int = 0
///
///     init {
///        repostiory.counter.sink(....)
///     }
///     func countUp()   {   self.repository.countUp() }
///  }
@propertyWrapper
struct WithValue<T: Publisher> {
    private let current: CurrentValueSubject<T.Output, T.Failure>
    private let publisher: AnyPublisher<T.Output, T.Failure>

    init(_ initialValue: T.Output) {
        self.current = CurrentValueSubject(initialValue)
        self.publisher = self.current.eraseToAnyPublisher()
    }
    
    func get() -> T.Output { self.current.value }
    func set(_ v: T.Output) { self.current.value = v }
    
    var value: T { self.publisher as! T }
}


/// Almost same as WithValue, but this create `PassthroughSubject.`
/// So this wrapper doesn't keep value, and doesn't have `get()` method
@propertyWrapper
struct WithPassthrough<T: Publisher> {
    private let passthrough: PassthroughSubject<T.Output, T.Failure>
    private let publisher: AnyPublisher<T.Output, T.Failure>
    
    init() {
        self.passthrough = PassthroughSubject()
        self.publisher = self.passthrough.eraseToAnyPublisher()
    }
    func set(_ v: T.Output) { self.passthrough.send(v) }
    
    var value: T { self.publisher as! T }
}
