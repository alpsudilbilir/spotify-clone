//
//  SearchResultResponse.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 24.08.2022.
//

import Foundation
struct SearchResultResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
}
struct SearchAlbumResponse: Codable {
    let items: [Album]
}
struct SearchArtistsResponse: Codable {
    let items: [Artist]
}
struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]
}
struct SearchTracksResponse: Codable {
    let items: [AudioTrack]
}
