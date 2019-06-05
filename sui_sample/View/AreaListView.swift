//
//  ContentView.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/04.
//  Copyright © 2019 naodroid. All rights reserved.
//

import SwiftUI

//create wrapper view for making environment-binding easy
//It's similar to Fragment in android
struct AreaListView : View {
    var body: some View {
        AreaListViewInner().environmentObject(AreaListViewModel())
    }
}

private struct AreaListViewInner : View {
    @EnvironmentObject var viewModel: AreaListViewModel
    
    var body: some View {
        NavigationView {
            VStack() {
                if self.viewModel.loading {
                    Text("Loading")
                } else {
                    List(self.viewModel.areas, rowContent: { area in
                        AreaRow(area: area, action: {
                        })
                    })
                }
            }
            .navigationBarTitle(Text("地域選択"), displayMode: .large)
        }
        .onAppear {
            self.viewModel.fetch()
        }
        .onDisappear {
            self.viewModel.cancel()
        }
    }
}

private struct AreaRow : View {
    let area: Area
    let action: () -> Void
    
    var body: some View {
        NavigationButton(
        destination: ForecastView(area: self.area)) {
            Text(self.area.name)
        }
    }
}

#if DEBUG
struct AreaListView_Previews : PreviewProvider {
    static var previews: some View {
        AreaListView()
    }
}
#endif
