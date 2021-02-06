//
//  ViewController.swift
//  iTunes Client
//
//  Created by Admin on 29.01.2021.
//

import UIKit

protocol SearchDisplayLogic: class {
  func displayFetchedCollections(_ viewModel: SearchModels.FetchCollections.ViewModel)
}

class SearchViewController: UIViewController {

  // MARK: - Public Properties

  var interactor: SearchBusinessLogic?
  var router: (NSObjectProtocol & SearchRoutingLogic & SearchDataPassing)?

  // MARK: - Private Properties

  private var collections: [Collection] = []
 
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
    let interactor = SearchInteractor()
    let presenter = SearchPresenter()
    let router = SearchRouter()

    interactor.presenter = presenter
    presenter.viewController = self
    router.viewController = self
    router.dataStore = interactor

    self.interactor = interactor
    self.router = router
  }
  
  // MARK: - UI
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet private weak var collectionView: UICollectionView!
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    configure()
  }
  
  private func configure() {
    let width = view.frame.size.width
    let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    layout.itemSize = CGSize(width: width, height: 60)
  }
  
  override func viewWillAppear(_ animated: Bool){
    super.viewWillAppear(animated)
   
    self.navigationController?.isNavigationBarHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool){
    super.viewWillDisappear(animated)
    
    self.navigationController?.isNavigationBarHidden = false
  }

  // MARK: - Requests

  private func requestToFetchCollections(_ searchText: String) {
    let request = SearchModels.FetchCollections.Request(searchText: searchText)
    interactor?.fetchCollections(request)
  }

  private func requestToSelectCollection(by indexPath: IndexPath) {
    guard !collections.isEmpty && indexPath.row < collections.count else { return }
    
    let collection = collections[indexPath.row]
    let request = SearchModels.SelectCollection.Request(collection: collection)
    interactor?.selectCollection(request)
  }
}

// MARK: - Search Display Logic

extension SearchViewController: SearchDisplayLogic {

  func displayFetchedCollections(_ viewModel: SearchModels.FetchCollections.ViewModel) {
    collections = viewModel.collections
    collectionView.reloadData()
  }
}

// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    dismissKeyboard()
    if let searchText = searchBar.text {
      requestToFetchCollections(searchText)
    }
  }
  
  @objc func dismissKeyboard() {
    searchBar.resignFirstResponder()
  }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collections.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    let collection = collections[indexPath.row]
    cell.artistNameLabel.text = collection.artistName
    cell.collectionNameLabel.text = collection.collectionName
    cell.collectionPriceLabel.text = collection.collectionPriceText
    let artworkUrl = URL(string: collection.artworkUrl60)
    DispatchQueue.global().async {
      guard let data = try? Data(contentsOf: artworkUrl!) else { return }
      DispatchQueue.main.async {
        cell.artworkImage.image = UIImage(data: data)
      }
    }
    return cell
  }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    requestToSelectCollection(by: indexPath)
    performSegue(withIdentifier: "Detail", sender: indexPath)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
}
