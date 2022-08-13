//
//  ViewController.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 24.07.2022.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        fetchData()
    }
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func fetchData() {
        APIManager.shared.getNewReleases { result in
            switch result {
            case .success(let model): break
            case .failure(let error): break
            }
        }
        APIManager.shared.getFeaturedPlaylists { result in
            switch result {
            case .success(let model): break
            case .failure(let error): break
            }
        }
        
        APIManager.shared.getRecommendedGenres { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                var seeds = Set<String>()
                while seeds.count < 5 {
                    if let random = genres.randomElement() {
                        seeds.insert(random)
                    }
                }
                APIManager.shared.getRecommendations(genres: seeds) { result in
                }
            case .failure(let error): break
            }
        }
    }
    
}



