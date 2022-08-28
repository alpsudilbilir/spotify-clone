//
//  LibraryToggleView.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 27.08.2022.
//

import UIKit

protocol LibraryToggleViewDelegate: AnyObject {
    func libraryToggleViewDidTapPlaylist()
    func libraryToggleViewDidTapAlbums()
}
class LibraryToggleView: UIView {
    
    enum State {
        case playlist
        case album
    }
    var state: State = .playlist
    weak var delegate: LibraryToggleViewDelegate?
    private let playlistButton: UIButton = {
        let button = UIButton()
        button.setTitle("Playlists", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let albumsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Albums", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(albumsButton)
        addSubview(playlistButton)
        addSubview(indicatorView)
        
        playlistButton.addTarget(self, action: #selector(didTapPlaylist), for: .touchUpInside)
        albumsButton.addTarget(self, action: #selector(didTapAlbums), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc private func didTapPlaylist() {
        state = .playlist
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }

        self.delegate?.libraryToggleViewDidTapPlaylist()

    }
    @objc private func didTapAlbums() {
        state = .album
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
        self.delegate?.libraryToggleViewDidTapAlbums()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        playlistButton.frame = CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 40)
        albumsButton.frame = CGRect(
            x: playlistButton.rigth,
            y: 0,
            width: 100,
            height: 40)
        layoutIndicator()
     
  
    }
    func layoutIndicator() {
        switch state {
        case .playlist:
            indicatorView.frame = CGRect(
                x: 5,
                y: playlistButton.bottom,
                width: 100,
                height: 4)
        case .album:
            indicatorView.frame = CGRect(
                x: playlistButton.rigth + 5,
                y: albumsButton.bottom,
                width: 100,
                height: 4)
        }
    }
    func update(for state: State) {
        self.state = state
        UIView.animate(withDuration: 0.2) {
            self.layoutIndicator()
        }
    }
}
