//
//  TabButton.swift
//  sui_sample
//
//  Created by naodroid on 2019/06/06.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

struct TabButton: View {
    let text: String
    let selected: Bool
    let action: () -> Void
    /// create var to change color when appearance changed
    @EnvironmentObject var theme: ColorTheme
    
    private var fillColorTop: Color {
        self.selected ? self.theme.tabFrameColor : self.theme.background
    }
    private var fillColorBottom: Color {
        self.selected ? self.theme.tabBgColor : self.theme.background
    }
    private var textColor: Color {
        self.selected ? theme.foregronud : theme.foregronudLight
    }
    
    var body: some View {
        return ZStack {
            RoundBg(
                strokeColor: theme.tabFrameColor,
                fillColorTop: self.fillColorTop,
                fillColorBottom: self.fillColorBottom
            )
                .colorScheme(.light)
            Button(action: self.action) {
                Text(self.text).foregroundColor(self.textColor)
            }
                //this resize code has problem.
                //Tap detecting area is still small, same as Text size
                .maximumWidth().maximumHeight()
        }.frame(height: 36.0)
    }
}

struct RoundBg: View {
    let strokeColor: Color
    let fillColorTop: Color
    let fillColorBottom: Color
    private let cornerRadius: CGFloat = 8.0
    
    var body: some View {
        GeometryReader {geometory in
            ZStack {
                self.createPath(for: geometory).fill(
                    LinearGradient(
                        gradient: .init(colors: [self.fillColorTop, self.fillColorBottom]),
                        startPoint: .init(x: 0.5, y: 0),
                        endPoint: .init(x: 0.5, y: 1.0)
                ))
                self.createPath(for: geometory).stroke(self.strokeColor)
            }
        }
    }
    private func createPath(for geometory: GeometryProxy) ->  Path {
        Path { path in
            path.move(to: CGPoint(
                x: 0,
                y: geometory.size.height
            ))
            path.addLine(to: CGPoint(
                x: 0,
                y: self.cornerRadius
            ))
            path.addQuadCurve(
                to: CGPoint(
                    x: self.cornerRadius,
                    y: 0
                ),
                control: CGPoint(
                    x: 0,
                    y: 0
                )
            )
            path.addLine(to: CGPoint(
                x: geometory.size.width - self.cornerRadius,
                y: 0
            ))
            path.addQuadCurve(
                to: CGPoint(
                    x: geometory.size.width,
                    y: self.cornerRadius
                ),
                control: CGPoint(
                    x: geometory.size.width,
                    y: 0
                )
            )
            path.addLine(to: CGPoint(
                x: geometory.size.width,
                y: geometory.size.height
            ))
        }
    }
}
