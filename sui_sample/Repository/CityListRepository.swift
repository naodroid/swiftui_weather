//
//  AreaListRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation

//type declaration
enum CityListError: Error {
    case resourceNotFount
    case parseError
}

struct CityFilterResult: Equatable {
    let keyword: String
    let cities: [City]
}

actor CityFilterResultSequence: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = CityFilterResult
    
    private var results: [CityFilterResult] = []

    func next() async -> CityFilterResult? {
        while results.isEmpty {
            if Task.isCancelled {
                return nil
            }
            await Task<Void, Never>.sleep(forSeconds: 0.1)
        }
        let f = results.first!
        results = Array(results.dropFirst())
        return f
    }
    func push(result: CityFilterResult) {
        results.append(result)
    }

    nonisolated func makeAsyncIterator() -> CityFilterResultSequence {
        self
    }
}

//
protocol CityListRepository {
    var cityList: CityFilterResultSequence { get }
    func setup() async
    func filter(by keyword: String) async
    func cancel() async
}

//implementation
actor CityListRepositoryImpl: CityListRepository {
    //
    let cityList = CityFilterResultSequence()
    
    //
    private var allCities = [City]()
    private var lastFilterTask: Task<Void, Never>?
    
    /// load city list from bundle
    func setup() async {
        do {
            if self.allCities.isEmpty {
                self.allCities = try await readJson()
                let result = CityFilterResult(keyword: "", cities: self.allCities)
                await self.cityList.push(result: result)
            }
        } catch {
        }
    }
    func filter(by keyword: String) async {
        lastFilterTask?.cancel()
        lastFilterTask = Task<Void, Never> {
            await setup()
            let k = keyword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            let result = allCities.filter { (c) -> Bool in
                return keyword.isEmpty || c.name.lowercased().contains(k)
            }
            let limit = (result.count >= 100)
                ? Array(result[..<100])
                : result
            let filtered = CityFilterResult(keyword: keyword, cities: limit)
            await cityList.push(result: filtered)
        }
    }
    func cancel() async {
        lastFilterTask?.cancel()
        lastFilterTask = nil
    }
    
    /// read all cities from json
    private func readJson() async throws -> [City] {
        guard let path = Bundle.main.path(forResource: "city_list.json", ofType: nil),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                print("Json read error. Please put city_list.json to asset folder.")
                throw CityListError.resourceNotFount
        }
        do {
            let cities = try JSONDecoder().decode([City].self, from: data)
            return cities
        } catch {
            throw CityListError.parseError
        }
    }
}


