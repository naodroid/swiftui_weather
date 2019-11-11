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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theme?.currentTrait = self.traitCollection
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        self.theme?.currentTrait = self.traitCollection
    }
}
class ColorTheme: ObservableObject {
    let didChange = PassthroughSubject<ColorTheme, Never>()
    fileprivate var currentTrait: UITraitCollection? {
        didSet {
            self.didChange.send(self)
        }
    }
    
    private func resolve(_ color: UIColor) -> Color {
        guard let t = self.currentTrait else {
            return color.toSwiftUI()
        }
        return color.resolvedColor(with: t).toSwiftUI()
    }
    

    /// this color works when you switch dark-mode.
    /// but, the color will be reset to light-color after chaning tab
    /// .colorScheme(.dark) also won't work. so I created resolve function
    var tabBgColor: Color {
        self.resolve(UIColor(named: "tabBgColor")!)
    }
    var tabFrameColor: Color {
        self.resolve(UIColor(named: "tabFrameColor")!)
    }
    var foregronud: Color {
        self.resolve(UIColor.label)
    }
    var foregronudLight: Color {
        self.resolve(UIColor.secondaryLabel)
    }
    var foregronudReversed: Color {
        self.resolve(UIColor.tertiaryLabel)
    }
    var background: Color {
        self.resolve(UIColor.systemBackground)
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
