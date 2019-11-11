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
    Future<Data, Error> { (result) in
        guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
            result(.failure(HttpError.invalidURL))
            return
        }
        
        let url = URL(fileURLWithPath: path)
        //Simulate delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.8) {
            guard let data = try? Data(contentsOf: url) else {
                result(.failure(HttpError.invalidURL))
                return
            }
            result(.success(data))
        }
    }.eraseToAnyPublisher()
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
