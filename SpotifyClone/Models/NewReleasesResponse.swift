//
//  NewReleases.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 13.08.2022.
//

import Foundation


struct NewReleasesResponse: Codable {
    let albums: AlbumResponse
}

struct AlbumResponse: Codable {
    let items: [Album]
}
struct Album: Codable {
    let album_type: String
    let available_markets: [String]
    let id: String
    let images: [APIImage]
    let name: String
    let release_date: String
    let total_tracks: Int

}


   
