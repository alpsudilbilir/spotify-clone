//
//  AlbumDetailsHeaderViewModel.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 21.08.2022.
//

import Foundation

struct AlbumDetailsHeaderViewModel: Codable {
    let albumCoverImage: URL?
    let albumName: String
    let releaseDate: String
    let artistName: String
    
}
