//
//  RecommendedTrackCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 15.08.2022.
//

import UIKit
import SDWebImage
class RecommendedTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "RecommendedTrackCollectionViewCell"
    
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private let trackCoverView : UIImageView =  {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.clipsToBounds = true
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(trackCoverView)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        trackNameLabel.text = nil
        artistNameLabel.text = nil
        trackCoverView.image = nil
    }
    override func layoutSubviews() {
        trackNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        trackCoverView.sizeToFit()
        
        trackNameLabel.clipsToBounds = true
        artistNameLabel.clipsToBounds = true
        trackCoverView.clipsToBounds = true
        
        
        trackCoverView.frame = CGRect(
            x: 0,
            y: 0,
            width: contentView.width * 1/4,
            height: contentView.heigth)
        trackNameLabel.frame = CGRect(
            x: trackCoverView.rigth + 5,
            y: 0,
            width: contentView.width - (contentView.width * 1/4) - 10,
            height: contentView.heigth / 2)
        
        artistNameLabel.frame = CGRect(
            x: trackCoverView.rigth + 5,
            y: contentView.heigth / 2 ,
            width: contentView.width - (contentView.width * 1/4) - 10,
            height: contentView.heigth / 2)
    }
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        trackCoverView.sd_setImage(with: viewModel.artworkURL)
    }
    
}
