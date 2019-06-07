//
//  ColorTheme.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/07.
//  Copyright © 2019 naodroid. All rights reserved.
//

import UIKit
import SwiftUI
import Combine

// TO dispatch dark-mode-echanging, create ownVC and dispatch event through Observer
// I haven't found other methods to do same thing.
class TraitObservingViewController<T>: UIHostingController<T> where T: View {
    var theme: ColorTheme?

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if let t = self.theme {
            t.didChange.send(t)
        }
    }
}
class ColorTheme: BindableObject {
    let didChange = PassthroughSubject<ColorTheme, Never>()

    /// this color works when you switch dark-mode.
    /// but, the color will be reset to light-color after chaning tab
    /// .colorScheme(.dark) also won't work.
    var tabBgColor: Color {
        Color("tabBgColor")
    }
    var tabFrameColor: Color {
        Color("tabFrameColor")
    }
    var foregronud: Color {
        UIColor.label.toSwiftUI()
    }
    var foregronudLight: Color {
        UIColor.secondaryLabel.toSwiftUI()
    }
    var foregronudReversed: Color {
        UIColor.tertiaryLabel.toSwiftUI()
    }
    var background: Color {
        UIColor.systemBackground.toSwiftUI()
    }
}
//convert to SwiftUI-Color
extension UIColor {
    func toSwiftUI() -> Color {
        var r = CGFloat(1.0)
        var g = CGFloat(1.0)
        var b = CGFloat(1.0)
        var a = CGFloat(1.0)
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        //TODO: set correct ColorSpace
        return Color(Color.RGBColorSpace.sRGB,
                     red: Double(r),
                     green: Double(g),
                     blue: Double(b),
                     opacity: Double(a))
    }
}
