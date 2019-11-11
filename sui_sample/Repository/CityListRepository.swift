//
//  AreaListRepository.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import Combine

//type declaration

enum CityListError: Error {
    case resourceNotFount
    case parseError
}
private typealias CityListPublisher = AnyPublisher<[City], CityListError>
typealias CityFilterResultPublisher = AnyPublisher<CityFilterResult, Never>

struct CityFilterResult: Equatable {
    let keyword: String
    let cities: [City]
}

//
protocol CityListRepository {
    var cityList: CityFilterResultPublisher { get }
    
    func setup()
    func filter(by keyword: String)
    func cancel()
}

//implementation
final class CityListRepositoryImpl: CityListRepository {
    //
    private let _cityList = PassthroughSubject<CityFilterResult, Never>()
    var cityList: CityFilterResultPublisher { _cityList.eraseToAnyPublisher() }
    
    //
    private let _keyword : CurrentValueSubject<String, Never> = .init("")
    private let _allCities: CurrentValueSubject<[City], Never> = .init([City]())
    private var cancellableBag = CancellableBag()
    
    /// load city list from bundle
    func setup() {
        if self._allCities.value.isEmpty {
            readJson().sink(
                receiveCompletion: { _ in },
                receiveValue: self._allCities.send)
                .cancel(by: self.cancellableBag)
        }
        
        self._allCities
            .combineLatest(_keyword) { (cities, keyword) -> CityFilterResult in
                let k = keyword.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
                let result = cities.filter { (c) -> Bool in
                    return keyword.isEmpty || c.name.lowercased().contains(k)
                }
                let limit = (result.count >= 100)
                    ? Array(result[..<100])
                    : result
                return CityFilterResult(keyword: keyword, cities: limit)
        }
        .sink(receiveValue: self._cityList.send)
        .cancel(by: self.cancellableBag)
    }
    func filter(by keyword: String) {
        self._keyword.send(keyword)
    }
    func cancel() {
        self.cancellableBag.cancel()
    }
    
    /// read all cities from json
    private func readJson() -> CityListPublisher {
        Future<[City], CityListError> { (result) in
            DispatchQueue.global().async {
                guard let path = Bundle.main.path(forResource: "city_list.json", ofType: nil),
                    let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
                        print("Json read error. Please put city_list.json to asset folder.")
                        result(.failure(.resourceNotFount))
                        return
                }
                do {
                    let cities = try JSONDecoder().decode([City].self, from: data)
                    result(.success(cities))
                } catch {
                    result(.failure(.parseError))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


