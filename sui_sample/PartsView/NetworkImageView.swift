//
//  NetworkImageView.swift
//  sui_sample
//
//  Created by nadroid on 2019/06/05.
//  Copyright © 2019 naodroid. All rights reserved.
//

import Foundation
import SwiftUI

struct NetworkImage: View {
    let url: String
    let placeHolder: String
    
    @State var image: UIImage? = nil
    
    init(url: String, placeHolder: String) {
        self.url = url
        self.placeHolder = placeHolder
    }
    
    var body: some View {
        ZStack {
            if self.image != nil {
                Image(uiImage: self.image!)
            } else {
                Image(self.placeHolder)
                    .onAppear {
                        async {
                            do {
                                let data = try await httpRequest(url: self.url)
                                let image = UIImage(data: data)
                                self.image = image
                            } catch {
                            }
                        }
                }.onDisappear {
                }
            }
        }
    }
}
