//
//  PlayerControlsView.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 25.08.2022.
//

import Foundation
import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDİdTapForwardButton(_ playerControlsView: PlayerControlsView)
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView)
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float)
}

struct PlayerControlsViewViewModel {
    let title: String?
    let subtitle: String?
}

final class PlayerControlsView: UIView {
    private var isPlaying = true
    weak var delegate: PlayerControlsViewDelegate?
    
    private let volumeSlider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.tintColor = .systemGreen
        return slider
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .label
        label.text = "Ezhel"
        label.numberOfLines = 1
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.textColor = .label
        label.text = "Müptezhel"
        label.numberOfLines = 1
        return label
    }()
    
    private let backwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "arrowtriangle.left.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    
    let playPauseButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let imageName = PlaybackPresenter.shared.player?.timeControlStatus == .playing ? "pause.circle.fill" : "arrowtriangle.forward.fill"
        let image = UIImage(systemName: "pause.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 55, weight: .regular))
        button.setImage(image, for: .normal)
        button.layer.cornerRadius = 55 / 2
        button.layer.masksToBounds = true
        return button
    }()
    
    private let forwardButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "arrowtriangle.right.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .regular))
        button.setImage(image, for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        addSubview(volumeSlider)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(backwardButton)
        addSubview(playPauseButton)
        addSubview(forwardButton)
        
        backwardButton.addTarget(self, action: #selector(didTapBackward), for: .touchUpInside)
        forwardButton.addTarget(self, action: #selector(didTapForward), for: .touchUpInside)
        playPauseButton.addTarget(self, action: #selector(didTapPlayPause), for: .touchUpInside)
        volumeSlider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
      
    @objc private func didTapBackward() {
        delegate?.playerControlsViewDidTapBackButton(self)
    }
    @objc private func didTapForward() {
        delegate?.playerControlsViewDİdTapForwardButton(self)
    }
    @objc private func didTapPlayPause() {
        delegate?.playerControlsViewDidTapPlayPause(self)

        DispatchQueue.main.async {
            self.isPlaying.toggle()
            let imageName = self.isPlaying ?  "pause.circle.fill" : "arrowtriangle.forward.fill"
            self.playPauseButton.setImage(UIImage(systemName: imageName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 55, weight: .regular)), for: .normal)
        }


    }
    @objc private func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        delegate?.playerControlsView(self, didSlideSlider: value)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.frame = CGRect(
            x: 0,
            y: 10,
            width: width,
            height: 44 )
        subtitleLabel.frame  = CGRect(
            x: 0,
            y: nameLabel.bottom + 5,
            width: width,
            height: 44 )
        
        volumeSlider.frame = CGRect(
            x: 10,
            y: subtitleLabel.bottom + 20,
            width: width - 20,
            height: 44)
        
        let buttonSize: CGFloat = 60
        playPauseButton.frame = CGRect(
            x:  (width - buttonSize) / 2,
            y: volumeSlider.bottom + 30,
            width: buttonSize,
            height: buttonSize)
        backwardButton.frame = CGRect(
            x: playPauseButton.left - 60 - buttonSize,
            y: volumeSlider.bottom + 30,
            width: buttonSize,
            height: buttonSize)
        
        forwardButton.frame = CGRect(
            x: playPauseButton.rigth + 60,
            y: volumeSlider.bottom + 30,
            width: buttonSize,
            height: buttonSize)
    }
    func configure(with viewModel: PlayerControlsViewViewModel) {
        self.nameLabel.text = viewModel.title
        self.subtitleLabel.text = viewModel.subtitle
    }
}
