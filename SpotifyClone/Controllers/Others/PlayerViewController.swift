//
//  PlayerViewController.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 10.08.2022.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapForward()
    func didTapBackward()
    func didSlideSlider(_ value: Float)
}
class PlayerViewController: UIViewController {
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    private let controlsView = PlayerControlsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        controlsView.delegate = self
        configureBarButtons()
        configure()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageView.frame = CGRect(
            x: 10,
            y: view.safeAreaInsets.top,
            width: view.width - 20,
            height: view.width - 20)
        
        controlsView.frame = CGRect(
            x: 10,
            y: imageView.bottom,
            width: view.width - 20,
            height: view.heigth - imageView.heigth - view.safeAreaInsets.top - view.safeAreaInsets.bottom - 15)
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .done,
            target: self,
            action: #selector(didTapClose))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapAction))
        navigationItem.leftBarButtonItem?.tintColor = .label
        navigationItem.rightBarButtonItem?.tintColor = .label
        
    }
    private func configure() {
        imageView.sd_setImage(with: dataSource?.imageURL)
        controlsView.configure(with:
                                PlayerControlsViewViewModel(
                                    title: dataSource?.songName,
                                    subtitle: dataSource?.subtitle))
    }
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func didTapAction() {
        //Action
    }
    func refreshUI() {
        configure()
    }
    
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsView(_ playerControlsView: PlayerControlsView, didSlideSlider value: Float) {
        delegate?.didSlideSlider(value)
    }
    
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        self.delegate?.didTapPlayPause()
    }
    
    func playerControlsViewDİdTapForwardButton(_ playerControlsView: PlayerControlsView) {
        self.delegate?.didTapForward()
    }
    
    func playerControlsViewDidTapBackButton(_ playerControlsView: PlayerControlsView) {
        self.delegate?.didTapBackward()
    }
    
    
}
