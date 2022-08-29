//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 25.08.2022.
//
import AVFoundation
import Foundation
import UIKit

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}
final class PlaybackPresenter {
    
    static let shared = PlaybackPresenter()
    
    
    private var track: AudioTrack?
    private var tracks = [AudioTrack]()
    
    
    var currentTrack: AudioTrack? {
        if let track = track, tracks.isEmpty {
            return track
        }
        else if let player = self.playerQueue,  !tracks.isEmpty {
            return tracks[index]
        }
        return nil
    }
    var playerVC: PlayerViewController?
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    var index = 0
    
    
    // Single Tracks
    func startPlayback(from viewController: UIViewController, track: AudioTrack) {
        
        guard let url = URL(string: track.preview_url ?? "") else { return }
        player = AVPlayer(url: url)
        player?.volume = 0.5
        self.track = track
        self.tracks = []
        
        let vc = PlayerViewController()
        vc.title = track.name
        vc.dataSource = self
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true) { [weak self] in
            self?.player?.play()
        }
        self.playerVC = vc
    }
    
    // Albums & Playlists
    func startPlayback(from viewController: UIViewController, tracks: [AudioTrack]) {
            self.tracks = tracks
            self.track = nil
            self.playerQueue = AVQueuePlayer(items: tracks.compactMap({
                if let url = URL(string: $0.preview_url ?? "") {
                    return AVPlayerItem(url: url)
                } else {
                    return nil
                }
                
            }))
            self.playerQueue?.volume = 0.5
            self.playerQueue?.play()
   

        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.present(navigationController, animated: true)
        self.playerVC = vc

        
    }
}
//MARK: - Data Source
extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        return currentTrack?.name
    }
    
    var subtitle: String? {
        return currentTrack?.artists.first?.name
    }
    
    var imageURL: URL? {
        return URL(string: currentTrack?.album?.images.first?.url ?? "")
    }
}

//MARK: - Delegate
extension PlaybackPresenter: PlayerViewControllerDelegate {
    
    
    func didTapForward() {
        if tracks.isEmpty {
            player?.pause()
        } else if let player = playerQueue {
            player.advanceToNextItem()
            if index < tracks.count - 1 {
                index += 1
            } else {
                index = 0
            }
            
            playerVC?.refreshUI()
        }
    }
    
    func didTapBackward() {
        if tracks.isEmpty {
            //Not playlist or album
            player?.pause()
            guard let url = URL(string: track?.preview_url ?? "") else { return }
            player = AVPlayer(url: url)
            player?.play()
        } else if let firstItem = playerQueue?.items().first {
            let randomTrack = tracks.randomElement()
            playerQueue?.pause()
            playerQueue?.removeAllItems()
            guard let url = URL(string: randomTrack?.preview_url ?? "-") else { return }
            playerQueue = AVQueuePlayer(items: [AVPlayerItem(url: url )])
            playerQueue?.play()
        }
        
    }
    
    func didTapPlayPause() {
        if let player = player {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
        else if let player = playerQueue {
            if player.timeControlStatus == .playing {
                player.pause()
            }
            else if player.timeControlStatus == .paused {
                player.play()
            }
        }
    }
    
    
    func didSlideSlider(_ value: Float) {
        player?.volume = value
    }
    
}
