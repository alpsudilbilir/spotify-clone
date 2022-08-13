//
//  FeaturedPlaylistsResponse.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 13.08.2022.
//

import Foundation

struct FeaturedPlaylistsResponse: Codable {
    let playlists: PlaylistResponse
}
struct PlaylistResponse: Codable {
    let items: [Playlist]
}


struct User: Codable {
    let display_name: String
    let external_urls: [String : String]
    let id: String
}

