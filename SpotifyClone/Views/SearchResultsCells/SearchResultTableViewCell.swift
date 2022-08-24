//
//  SearchResultTableViewCell.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 24.08.2022.
//

import UIKit


class SearchResultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultTableViewCell"
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .thin)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(coverImageView)
        contentView.addSubview(label)
        contentView.addSubview(descriptionLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        coverImageView.frame = CGRect(
            x: 5,
            y: 5,
            width: contentView.heigth - 10,
            height: contentView.heigth - 10)
        coverImageView.layer.cornerRadius = (contentView.heigth - 10) / 2
        coverImageView.layer.masksToBounds = true
        
        label.frame = CGRect(
            x: coverImageView.rigth + 5,
            y: 0,
            width: contentView.width - contentView.heigth - 5,
            height: contentView.heigth / 2)
        
        descriptionLabel.frame = CGRect(
            x: coverImageView.rigth + 5,
            y: label.bottom + 2,
            width: contentView.width - contentView.heigth - 5,
            height: contentView.heigth / 2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coverImageView.image = nil
        label.text = nil
        descriptionLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultCellViewModel) {
        label.text = viewModel.title
        coverImageView.sd_setImage(with: URL(string: viewModel.imageURL))
        descriptionLabel.text = viewModel.description
    }
    
}
