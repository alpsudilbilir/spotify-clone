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
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Welcome to Spotify"
        view.backgroundColor = .systemGreen
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        view.addSubview(signInButton)
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
    }
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { success in
            DispatchQueue.main.async {
                self.handleSignIn(success: success)
            }
            
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
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
