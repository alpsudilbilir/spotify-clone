//
//  Category.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 23.08.2022.
//

import Foundation

struct CategoryItems: Codable {
    let items: [Category]
    
}

struct Category: Codable {
    let id: String
    let name: String
    let icons: [APIImage]
}
