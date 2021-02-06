//
//  DetailViewController.swift
//  iTunes Client
//
//  Created by Admin on 02.02.2021.
//

import UIKit

protocol DetailDisplayLogic: class {
  func displayCollection(_ viewModel: DetailModels.ShowCollection.ViewModel)
  func displayFetchedTracks(_ viewModel: DetailModels.FetchTracks.ViewModel)
}

class DetailViewController: UIViewController {

  // MARK: - Public Properties

  var interactor: DetailBusinessLogic?
  var router: (DetailRoutingLogic & DetailDataPassing)?

  // MARK: - Private Properties

  private var tracks: [Track] = []
  
  // MARK: - Init

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  private func setup() {
    let interactor = DetailInteractor()
    let presenter = DetailPresenter()
    let router = DetailRouter()

    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.dataStore = interactor

    self.interactor = interactor
    self.router = router
  }

  // MARK: - UI
  
  @IBOutlet private weak var tableView: UITableView!
  
  @IBOutlet weak var collectionNameLabel: UILabel!
  @IBOutlet weak var artistNameLabel: UILabel!
  @IBOutlet weak var artworkImage: UIImageView!
  @IBOutlet weak var collectionPriceLabel: UILabel!
  @IBOutlet weak var trackCountLabel: UILabel!
  @IBOutlet weak var releaseDateLabel: UILabel!
  @IBOutlet weak var primaryGenreNameLabel: UILabel!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    showCollection()
    requestToFetchPosts()
  }
  
  // MARK: - Requests

  private func showCollection() {
    let request = DetailModels.ShowCollection.Request()
    interactor?.showCollection(request)
  }
  
  private func requestToFetchPosts() {
    let request = DetailModels.FetchTracks.Request()
    interactor?.fetchTracks(request)
  }
}

// MARK: - Detail Display Logic

extension DetailViewController: DetailDisplayLogic {
  func displayCollection(_ viewModel: DetailModels.ShowCollection.ViewModel) {
    if let collection = viewModel.collection {
      collectionNameLabel.text = collection.collectionName
      artistNameLabel.text = collection.artistName
      collectionPriceLabel.text = collection.collectionPriceText
      trackCountLabel.text = "Songs: \(collection.trackCount)"
      releaseDateLabel.text = "Released: \(collection.releaseDateText)"
      primaryGenreNameLabel.text = collection.primaryGenreName
      let artworkUrl = URL(string: collection.artworkUrl100)
      DispatchQueue.global().async {
        guard let data = try? Data(contentsOf: artworkUrl!) else { return }
        DispatchQueue.main.async {
          self.artworkImage.image = UIImage(data: data)
        }
      }
    }
  }

  func displayFetchedTracks(_ viewModel: DetailModels.FetchTracks.ViewModel) {
    tracks = viewModel.tracks
    tableView.reloadData()
  }
}

// MARK: - UITableViewDataSource

extension DetailViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tracks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TrackViewCell", for: indexPath) as! TrackViewCell
    let track = tracks[indexPath.row]
    
    cell.trackNameLabel.text = track.trackName
    cell.trackNumberLabel.text = String(track.trackNumber)
    cell.trackTimeLabel.text = track.trackTimeText
    cell.trackPriceLabel.text = track.trackPriceText
    
    return cell
  }
  
}
