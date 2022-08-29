//
//  LibraryAlbumsViewController.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 27.08.2022.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemOrange
        
        APIManager.shared.getSavedAlbums { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print(error)
                
            }
        }
    }

}
