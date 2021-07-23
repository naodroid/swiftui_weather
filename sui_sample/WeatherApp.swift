//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by nao on 2021/07/23.
//  Copyright © 2021 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        let theme = ColorTheme()
        let contentView = RootView().environmentObject(theme)
        let root = TraitObservingViewController(rootView: contentView)
        root.theme = theme
        return WindowGroup {
            contentView
        }
    }
}
