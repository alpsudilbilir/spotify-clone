//
//  AlbumDetailsCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 21.08.2022.
//

import UIKit
import SDWebImage
class AlbumDetailsCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumDetailsCollectionViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
 
        trackNameLabel.frame = CGRect(
            x: 5,
            y: 5,
            width: contentView.width - 10,
            height: contentView.heigth / 2 - 10)
        artistNameLabel.frame = CGRect(
            x: 5,
            y: contentView.heigth - contentView.heigth / 2,
            width: contentView.width - 10,
            height: contentView.heigth / 2 - 10)
    }
    
    func configure(with viewModels: AlbumDetailsCellViewModel) {
        trackNameLabel.text = viewModels.trackName
        artistNameLabel.text = viewModels.artistName
    }
}
