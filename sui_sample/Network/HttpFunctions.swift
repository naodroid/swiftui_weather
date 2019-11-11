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
    Future<Data, Error> { (result) in
        guard let compnents = URLComponents(string: url) else {
            result(.failure(HttpError.invalidURL))
            return
        }
        let url = compnents.url
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let data = data {
                result(.success(data))
            } else if let e = error {
                result(.failure(HttpError.connectionError(e)))
            } else {
                result(.failure(HttpError.unknownError))
            }
        }
        task.resume()
    }
    .eraseToAnyPublisher()
}

func httpRequestJson<T: Decodable>(url: String,
                                   keyStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> AnyPublisher<T, Error> {
    httpRequest(url: url)
        .eraseToAnyPublisher()
        .map { (data) -> T in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = keyStrategy
            return try! decoder.decode(T.self, from: data)
    }
    .eraseToAnyPublisher()
}

