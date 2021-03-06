//
//  CitySelectView.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

/// manegement lifecycle, di and so on
/// This is similar to Android-Fragment, so I named this as Fragment
struct CitySelectFragment: View {
    init() {
    }
    
    var body: some View {
        let list = CityListRepositoryImpl()
        let location = LocationRepositoryImpl()
        let viewModel = CitySelectViewModel(
            listRepository: list,
            locationRepository: location
        )
        return CitySelectView()
            .environmentObject(viewModel)
            .navigationBarTitle(Text("City Selection"))
            .onAppear { viewModel.setup() }
            .onDisappear { viewModel.cancel() }
    }
}

/// just rendering view.
struct CitySelectView: View {
    @EnvironmentObject  var viewModel: CitySelectViewModel
    @State var text: String = ""
    @EnvironmentObject var theme: ColorTheme
    
    private var lat: Double {
        self.viewModel.pin?.latitude ?? 0
    }
    private var lon: Double {
        self.viewModel.pin?.longitude ?? 0
    }
    private var isList: Bool {
        self.viewModel.selectedTab == .cityList
    }
    
    //------------------------
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 1) {
                TabButton(text: "List", selected: self.isList, action:{
                    self.viewModel.changeTab(to: .cityList)
                }).layoutPriority(1)
                TabButton(text: "Map", selected: !self.isList, action: {
                    self.viewModel.changeTab(to: .map)
                }).layoutPriority(1)
            }.padding(EdgeInsets.init(top: 0, leading: 2, bottom: 0, trailing: 2))
            if self.isList {
                self.cityList
            } else {
                self.map
            }
        }
    }
    
    private var cityList: some View {
        VStack {
            HStack {
                TextField("", text: $text, onEditingChanged: { (_) in
                    
                }, onCommit: {
                    self.viewModel.filter(by: self.text)
                    resignFirstResponderForCurrentView()
                })
                    .frame(height: 28)
                    .padding([.leading, .trailing], 8)
                    .background(self.theme.background)
                    .cornerRadius(4.0)
            }
            .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            .background(self.theme.tabBgColor)
            
            List(viewModel.cities, rowContent: {city in
                CityRow(city: city)
            })
        }
    }
    
    private var map: some View {
        ZStack {
            MapView(
                loc: self.viewModel.location,
                pin: self.viewModel.pin,
                onTap: {(pos) in
                    self.viewModel.setPin(pos: pos)
            })
            //buttons
            VStack {
                Text("Tap to select place")
                Spacer().layoutPriority(1)
                HStack {
                    Spacer()
                    Button(action: {
                        self.viewModel.startLocating()
                    }, label: {
                        Text("GPS")
                    })
                        .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        .background(self.theme.background)
                        .cornerRadius(8)
                    Spacer().frame(width: 8)
                }
                NavigationLink(destination: Weather5DayFragment(lat: self.lat, lon: self.lon)) {
                    Text("Use Here")
                        .foregroundColor(Color.blue)
                }
                .disabled(self.viewModel.pin == nil)
                .padding(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                .background(self.theme.background)
                .cornerRadius(8)
                .background(self.theme.background)
                .cornerRadius(8)
                
                Spacer().frame(height: 20)
            }
        }
    }
}

struct CityRow: View {
    let city: City
    
    var body: some View {
        NavigationLink(destination: Weather5DayFragment(city: city)) {
            Text(city.name + "(" + city.country + ")")
        }
    }
}


