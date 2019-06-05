//
//  AreaRepository.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


//
class AreaListViewModel: BindableObject {
    
    let didChange = PassthroughSubject<AreaListViewModel, Never>()
    fileprivate(set) var loading = false
    fileprivate(set) var areas: [Area] = []
    //private
    private var cancellable: Cancellable?
    
    func fetch() {
        //Todo: fetch from network
        if self.loading {
            return
        }
        self.loading = true
        self.notifyUpdate()
        
        //wait for simulating networkaccess
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {[weak self] in
            guard let s = self else { return }
            s.loading = false
            s.areas = getDummyData()
            s.notifyUpdate()
        }
    }
    func cancel() {
        self.cancellable?.cancel()
        self.cancellable = nil
    }
}

func getDummyData() -> [Area] {
    return [
        Area(id: "016010", name: "札幌"),
        Area(id: "020010", name: "青森"),
        Area(id: "040010", name: "仙台"),
        Area(id: "060010", name: "山形"),
        Area(id: "090010", name: "宇都宮"),
        Area(id: "110010", name: "さいたま"),
        Area(id: "120010", name: "千葉"),
        Area(id: "130010" , name: "東京"),
        Area(id: "140010", name: "横浜"),
        Area(id: "160010", name: "富山"),
        Area(id: "170010", name: "金沢"),
        Area(id: "200010", name: "長野"),
        Area(id: "220010", name: "静岡")
    ]
}
