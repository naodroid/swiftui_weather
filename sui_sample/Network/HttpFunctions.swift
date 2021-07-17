//
//  HttpFunctions.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation

enum HttpError : Error {
    case invalidURL
    case jsonParseError(Error)
    case connectionError(Error)
    case unknownError
}


func httpRequest(url: String) async throws -> Data {
    guard let compnents = URLComponents(string: url),
          let urlObj = compnents.url else {
        throw HttpError.invalidURL
    }
    
    let (data, _) = try await URLSession.shared.data(from: urlObj)
    return data
}

func httpRequestJson<T: Decodable>(url: String,
                                   keyStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
    let data = try await httpRequest(url: url)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = keyStrategy
    return try! decoder.decode(T.self, from: data)
}

