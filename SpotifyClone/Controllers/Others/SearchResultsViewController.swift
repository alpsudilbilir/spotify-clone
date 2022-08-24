//
//  SearchResultsViewController.swift
//  Spotify Clone
//
//  Created by Alpsu Dilbilir on 10.08.2022.
//

import UIKit
struct SearchSection {
    let title: String
    let results: [SearchResult]
}
protocol SearchresultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}
class SearchResultsViewController: UIViewController {
    
    weak var delegate: SearchresultsViewControllerDelegate?
    private var sections: [SearchSection] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.isHidden = true
        return tableView
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.register(SearchResultTableViewCell.self,
                           forCellReuseIdentifier: SearchResultTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
     
    func update(with results: [SearchResult]) {
        let artists = results.filter({
            switch $0 {
            case .artist: return true
            default: return false
            }
        })
        let albums = results.filter({
            switch $0 {
            case .album: return true
            default: return false
            }
        })
        let playlists = results.filter({
            switch $0 {
            case .playlist: return true
            default: return false
            }
        })
        let tracks = results.filter({
            switch $0 {
            case .track: return true
            default: return false
            }
        })
        
        self.sections = [
            SearchSection(title: "Songs", results: tracks),
            SearchSection(title: "Artists", results: artists),
            SearchSection(title: "Albums", results: albums),
            SearchSection(title: "Playlists", results: playlists)
        ]
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
}

//MARK: - Table View

extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let result = sections[indexPath.section].results[indexPath.row]
        guard let customCell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultTableViewCell.identifier, for: indexPath) as? SearchResultTableViewCell else {
            return UITableViewCell()
        }
        switch result {
        case .artist(let artist):
            let viewModel = SearchResultCellViewModel(
                title: artist.name,
                imageURL: artist.images?.first?.url ?? "",
                description: nil)
            customCell.configure(with: viewModel)
            return customCell
        case .album(let album):
            let viewModel = SearchResultCellViewModel(
                title: album.name,
                imageURL: album.images.first?.url ?? "",
                description: album.artists.first?.name ?? "-")
            customCell.configure(with: viewModel)
            return customCell
        case .playlist(let playlist):
            let viewModel = SearchResultCellViewModel(
                title: playlist.name,
                imageURL: playlist.images.first?.url ?? "",
                description: playlist.owner.display_name)
            customCell.configure(with: viewModel)
            return customCell

        case .track(let song):
            let viewModel = SearchResultCellViewModel(
                title: song.name,
                imageURL: song.album?.images.first?.url ?? "",
                description: song.artists.first?.name ?? "-")
            customCell.configure(with: viewModel)
            return customCell
        }
        return customCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].results[indexPath.row]
        delegate?.didTapResult(result)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
    
}
