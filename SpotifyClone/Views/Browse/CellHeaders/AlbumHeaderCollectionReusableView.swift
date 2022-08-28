//
//  AlbumHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 21.08.2022.
//

import UIKit

protocol AlbumHeaderCollectionReusableViewDelegate: AnyObject {
    func albumHeaderCollectionReusableViewDidTapPlayAll(_ header: AlbumHeaderCollectionReusableView)
}
class AlbumHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "AlbumHeaderCollectionReusableView"
    
    weak var delegate: AlbumHeaderCollectionReusableViewDelegate?
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 1
        return label
    }()
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.tintColor = .black
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(albumNameLabel)
        addSubview(releaseDateLabel)
        addSubview(albumCoverImageView)
        addSubview(artistNameLabel)
        addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(didTapPlay), for: .touchUpInside)
    }
    @objc private func didTapPlay() {
        delegate?.albumHeaderCollectionReusableViewDidTapPlayAll(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = width * 2/3
        albumCoverImageView.frame = CGRect(
            x: (width - imageSize) / 2,
            y:  20,
            width: imageSize,
            height: imageSize)
        albumNameLabel.frame = CGRect(
            x: 10,
            y: albumCoverImageView.bottom + 10 ,
            width: width,
            height: 24)
        releaseDateLabel.frame = CGRect(
            x: 10,
            y: albumNameLabel.bottom + 2,
            width: width,
            height: 24)
        artistNameLabel.frame = CGRect(
            x: 10,
            y: releaseDateLabel.bottom + 2,
            width: width,
            height: 24)
        playAllButton.frame = CGRect(
            x: albumCoverImageView.rigth - 25,
            y: albumCoverImageView.bottom - 25,
            width: 50,
            height: 50)
    }
    
    func configure(with viewModel: AlbumDetailsHeaderViewModel) {
        albumCoverImageView.sd_setImage(with: viewModel.albumCoverImage)
        albumNameLabel.text = viewModel.albumName
        artistNameLabel.text = viewModel.artistName
        releaseDateLabel.text = viewModel.releaseDate
    }
    
}
