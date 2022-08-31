//
//  WelcomeViewController.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 10.08.2022.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.secondarySystemBackground.withAlphaComponent(0.9)
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
        
    }()
    private let backgroundImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.image = UIImage(named: "background")
        imageview.contentMode = .scaleToFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 75
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let listenLabel: UILabel = {
       let label = UILabel()
        label.text = "Listen to millions of songs"
        label.font = .systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to Spotify"
        
        view.backgroundColor = .black
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
        view.addSubview(listenLabel)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.heigth-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50
        )
        signInButton.layer.cornerRadius = 25
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        logoImageView.frame = CGRect(
            x: view.width/2 - 75,
            y: view.heigth / 2 - 75,
            width: 150, height: 150)
        listenLabel.frame = CGRect(
            x: 0,
            y: logoImageView.bottom + 10,
            width: view.width,
            height: 30)
    }
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
        vc.completionHandler = { success in
            DispatchQueue.main.async {
                self.handleSignIn(success: success)
            }
        }
    }
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(alert, animated: true)
            return
            
        }
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabBarVC, animated: true)
    }
}
