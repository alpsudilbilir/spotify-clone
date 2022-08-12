//
//  SettingsModels.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 12.08.2022.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}
struct Option {
    let title: String
    let handler: () -> Void
}
