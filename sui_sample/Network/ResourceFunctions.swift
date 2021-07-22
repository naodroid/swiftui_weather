//
//  ResourceFunctions.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation


/// Mainily for debug usage,
/// use local resource instead of network access
/// to avoid API limit.
func resourceRequest(fileName: String) async throws -> Data {
    guard let path = Bundle.main.path(forResource: fileName, ofType: nil) else {
        throw HttpError.invalidURL
    }
    await Task<Void, Never>.sleep(forSeconds: 1.0)
    let url = URL(fileURLWithPath: path)
    guard let data = try? Data(contentsOf: url) else {
        throw HttpError.invalidURL
    }
    return data
}

func resourceRequestJson<T: Decodable>(fileName: String) async throws -> T {
    let data = try await resourceRequest(fileName: fileName)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try! JSONDecoder().decode(T.self, from: data)
}
