//
//  SwiftUI+Ext.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension BindableObject where Self.PublisherType.Output == Self, Self.PublisherType : Subject {
    func notifyUpdate() {
        self.didChange.send(self)
    }
}

extension View {
    func maximumWidth() -> Self.Modified<_FlexFrameLayout> {
        return self.frame(minWidth: 0, idealWidth: 12000, maxWidth: 12000)
    }
    func maximumHeight() -> Self.Modified<_FlexFrameLayout> {
        return self.frame(minHeight: 0, idealHeight: 12000, maxHeight: 12000)
    }
}

func resignFirstResponderForCurrentView() {
    resignFirstResponderRecursive(view: UIApplication.shared.windows[0])
}
private func resignFirstResponderRecursive(view: UIView) {
    for v in view.subviews {
        if v.isFirstResponder {
            v.resignFirstResponder()
            return
        }
        resignFirstResponderRecursive(view: v)
    }
}
