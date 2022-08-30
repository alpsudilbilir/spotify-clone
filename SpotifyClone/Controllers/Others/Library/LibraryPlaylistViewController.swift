//
//  LibraryPlaylistViewController.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 27.08.2022.
//

import UIKit

class LibraryPlaylistViewController: UIViewController {
    var playlists = [Playlist]()
    
    var selectionHandler: ((Playlist) -> Void)?
    private let noPlaylistsView = ActionLabelView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setNoPlaylistView()
        fetchPlaylists()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapDismiss))
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noPlaylistsView.frame = CGRect(
            x: 0,
            y: 0,
            width: 150,
            height: 150)
        noPlaylistsView.center = view.center
    }
    @objc private func didTapDismiss() {
        dismiss(animated: true)
    }
    private func setNoPlaylistView() {
        view.addSubview(noPlaylistsView)
        noPlaylistsView.configure(with: ActionLabelViewViewModel(text: "You don't have any playlists yet.", actionTitle: "Create"))
        noPlaylistsView.delegate = self
    }
    
    func fetchPlaylists() {
        APIManager.shared.getCurrentUserPlaylist { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlist):
                    self?.playlists = playlist
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI() {
        if playlists.isEmpty {
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            tableView.isHidden = false
            noPlaylistsView.isHidden = true
        }
    }
    func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlist namee", preferredStyle: .alert)
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first, let text = field.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APIManager.shared.createPlaylist(with: text) { [weak self] success in
                DispatchQueue.main.async {
                    if success {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.fetchPlaylists()
                        self?.tableView.isHidden = false
                        self?.tableView.reloadData()
                    } else {
                        HapticsManager.shared.vibrate(for: .error)
                        print("Failed to create playlist.")
                    }
                }
                
                
            }
        }))
        present(alert, animated: true)
    }
}


extension LibraryPlaylistViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}

//MARK: - Table View

extension LibraryPlaylistViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultCellViewModel(title: playlist.name, imageURL: playlist.images.first?.url  ?? "", description: playlist.owner.display_name))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let playlist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true)
            return
        }
        let vc = PlayListViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let playlistToUnfollow = playlists[indexPath.row]
        let config = UIContextMenuConfiguration(identifier: playlistToUnfollow.id as NSString, previewProvider: nil) { _ in
            let deleteAction = UIAction(
                title: "Unfollow",
                image: UIImage(systemName: "minus.circle")) { [weak self] action in
                    APIManager.shared.unfollowPlaylist(playlist: playlistToUnfollow) { success in
                        DispatchQueue.main.async {
                            if success {
                                self?.playlists.remove(at: indexPath.row)
                                self?.tableView.reloadData()
                            } else {
                                print("Failed to unfollow")
                            }
                            
                        }
                    }
                }
            return UIMenu(title: "", children: [deleteAction])
        }
        return config
    }
    
}
