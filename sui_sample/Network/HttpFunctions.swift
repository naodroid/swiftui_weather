//
//  HttpFunctions.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine


enum HttpError : Error {
    case invalidURL
    case jsonParseError(Error)
    case connectionError(Error)
    case unknownError
}


func httpRequest(url: String) -> AnyPublisher<Data, Error> {
    return AnyPublisher {(subscriber) in
        guard let compnents = URLComponents(string: url) else {
            subscriber.receive(completion: .failure(HttpError.invalidURL))
            return
        }
        let url = compnents.url
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                _ = subscriber.receive(data)
                subscriber.receive(completion: .finished)
            } else if let e = error {
                subscriber.receive(completion: .failure(HttpError.connectionError(e)))
            } else {
                subscriber.receive(completion: .failure(HttpError.unknownError))
            }
        }
        task.resume()
    }
    .eraseToAnyPublisher()
}

func httpRequestJson<T: Decodable>(url: String) -> AnyPublisher<T, Error> {
    return httpRequest(url: url)
        .eraseToAnyPublisher()
        .map { (data) -> T in
            print(String(data: data, encoding: .utf8)!)
            return try! JSONDecoder().decode(T.self, from: data)
        }
        .eraseToAnyPublisher()
}

