//
//  SearchPresenter.swift
//  iTunes Client
//
//  Created by Admin on 06.02.2021.
//

protocol SearchPresentationLogic {
  func presentFetchedCollections(_ response: SearchModels.FetchCollections.Response)
}

class SearchPresenter: SearchPresentationLogic {

  // MARK: - Public

  weak var viewController: SearchDisplayLogic?

  // MARK: - SearchPresentationLogic

  func presentFetchedCollections(_ response: SearchModels.FetchCollections.Response) {
    let sortedCollections = response.collections.sorted { $0.collectionName.lowercased() < $1.collectionName.lowercased() }
    let viewModel = SearchModels.FetchCollections.ViewModel(collections: sortedCollections)

    viewController?.displayFetchedCollections(viewModel)
  }
}
