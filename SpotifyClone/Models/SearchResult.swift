//
//  SearchResult.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 24.08.2022.
//

import Foundation

enum SearchResult {
    case artist(model: Artist)
    case album(model: Album)
    case track(model: AudioTrack)
    case playlist(model: Playlist)
}
