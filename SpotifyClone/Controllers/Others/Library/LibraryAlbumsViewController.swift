//
//  LibraryAlbumsViewController.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 27.08.2022.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    
    var albums: [Album] = []
    
    private let noAlbumsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        fetchAlbums()
    }
    override func viewWillAppear(_ animated: Bool) {
        fetchAlbums()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noAlbumsView.frame = CGRect(x: (view.width - 150) / 2, y: (view.heigth - 150) / 2, width: 150, height: 150)
        noAlbumsView.center = view.center
    }
    private func setupNoAlbumsView() {
        view.addSubview(noAlbumsView)
        noAlbumsView.configure(with: ActionLabelViewViewModel(
            text: "You don't have any saved albums yet",
            actionTitle: ""))

    }
    
    private func fetchAlbums() {
        APIManager.shared.getSavedAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.tableView.reloadData()
                    self?.tableView.isHidden = false
                case .failure(let error):
                    print(error)
                }
            }
    
        }
        
    }
    
    private func updateUI() {
        if albums.isEmpty {
            noAlbumsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noAlbumsView.isHidden = true
            tableView.isHidden = false
        }
    }
}

//MARK: - Table View

extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let album = albums[indexPath.row]
        cell.configure(with: SearchResultCellViewModel(
            title: album.name,
            imageURL: album.images.first?.url ?? "",
            description: album.artists.first?.name))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let vc = AlbumViewController(album: albums[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    
}
