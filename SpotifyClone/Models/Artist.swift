//
//  Artist.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 10.08.2022.
//

import Foundation

struct Artist: Codable {
    let id: String
    let name: String
    let type: String
    let images: [APIImage]?
    let external_urls: [String : String]

}
       
