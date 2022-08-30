//
//  SavedAlbumsResponse.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 29.08.2022.
//

import Foundation

struct LibraryAlbumResponse: Codable {
    let items: [UserAlbumResponse]
}

struct UserAlbumResponse: Codable {
    let album: Album
    let added_at: String
}
