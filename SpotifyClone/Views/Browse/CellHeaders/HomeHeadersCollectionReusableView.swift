//
//  HomeHeadersCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 21.08.2022.
//

import UIKit

class HomeHeadersCollectionReusableView: UICollectionReusableView {
    static let identifier = "HomeHeadersCollectionReusableView"
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        headerLabel.frame = CGRect(
            x: 5,
            y: 5,
            width: width,
            height: heigth)
    }
    func configure(with title: String) {
        headerLabel.text = title
    }
}
