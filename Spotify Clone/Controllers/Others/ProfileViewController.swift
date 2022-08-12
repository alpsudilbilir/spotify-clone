//
//  ProfileViewController.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 10.08.2022.
//

import UIKit

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        APIManager.shared.getCurrentUserProfile { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                print(error.localizedDescription)
                break
            }
        }
    }
    


}
