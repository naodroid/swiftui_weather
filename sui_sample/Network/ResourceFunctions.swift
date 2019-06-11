//
//  ResourceFunctions.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine


/// Mainily for debug usage,
/// use local resource instead of network access
/// to avoid API limit.
func resourceRequest(fileName: String) -> AnyPublisher<Data, Error> {
    AnyPublisher {(subscriber) in
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            subscriber.receive(completion: .failure(HttpError.invalidURL))
            return
        }

        let url = URL(fileURLWithPath: path)
        //Simulate delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) {
            guard let data = try? Data(contentsOf: url) else {
                subscriber.receive(completion: .failure(HttpError.invalidURL))
                return
            }
            _ = subscriber.receive(data)
            subscriber.receive(completion: .finished)
        }
    }
    .eraseToAnyPublisher()
}

func resourceRequestJson<T: Decodable>(fileName: String) -> AnyPublisher<T, Error> {
    resourceRequest(fileName: fileName)
        .eraseToAnyPublisher()
        .map { (data) -> T in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try! JSONDecoder().decode(T.self, from: data)
        }
        .eraseToAnyPublisher()
}
