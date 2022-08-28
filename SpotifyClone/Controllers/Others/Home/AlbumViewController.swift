//
//  AlbumViewController.swift
//  SpotifyClone
//
//  Created by Alpsu Dilbilir on 18.08.2022.
//

import UIKit

class AlbumViewController: UIViewController {
    
    private let album: Album
    private var viewModels = [AlbumDetailsCellViewModel]()
    private var tracks = [AudioTrack]()

    private let collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: AlbumViewController.createLayout())
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(AlbumDetailsCollectionViewCell.self,
                                forCellWithReuseIdentifier: AlbumDetailsCollectionViewCell.identifier)
        collectionView.register(AlbumHeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier)
    
        APIManager.shared.getAlbumDetails(album: album) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.tracks = model.tracks.items
                    self.viewModels = model.tracks.items.compactMap({
                        return AlbumDetailsCellViewModel(
                            trackName: $0.name,
                            artistName: $0.artists.first?.name ?? "-")
                    })
                    self.collectionView.reloadData()
                case .failure(let error):
                    break
                }
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
}
extension AlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let track = tracks[indexPath.row]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: AlbumDetailsCollectionViewCell.identifier,
            for: indexPath) as? AlbumDetailsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: AlbumHeaderCollectionReusableView.identifier,
            for: indexPath) as? AlbumHeaderCollectionReusableView,
              kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let headerViewModel = AlbumDetailsHeaderViewModel(
            albumCoverImage: URL(string: album.images.first?.url ?? "-"),
            albumName: album.name,
            releaseDate: "Release Date: \(String.formattedDate(string: album.release_date))",
            artistName: album.artists.first?.name ?? "-")
        header.configure(with: headerViewModel)
        header.delegate = self
        return header
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        let supplementaryHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(1)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        //Item
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        //Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)),
            subitem: item,
            count: 1)
        //Section
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [supplementaryHeader]
        return UICollectionViewCompositionalLayout(section: section)
    }
}
extension AlbumViewController: AlbumHeaderCollectionReusableViewDelegate {
    func albumHeaderCollectionReusableViewDidTapPlayAll(_ header: AlbumHeaderCollectionReusableView) {
        let tracksWithAlbum: [AudioTrack] = tracks.compactMap( {
            var track = $0
            track.album = self.album
            return track
        })

        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracksWithAlbum)
    }
    
    
}
