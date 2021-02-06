//
//  DetailPresenter.swift
//  iTunes Client
//
//  Created by Admin on 07.02.2021.
//

import Foundation

protocol DetailPresentationLogic {
  func presentCollection(_ response: DetailModels.ShowCollection.Response)
  func presentFetchedTracks(_ response: DetailModels.FetchTracks.Response)
}

class DetailPresenter: DetailPresentationLogic {
  // MARK: - Public Properties

  weak var viewController: DetailDisplayLogic?

  // MARK: - DetailPresentationLogic

  func presentCollection(_ response: DetailModels.ShowCollection.Response) {
    let viewModel = DetailModels.ShowCollection.ViewModel(collection: response.collection)

    viewController?.displayCollection(viewModel)
  }
  
  func presentFetchedTracks(_ response: DetailModels.FetchTracks.Response) {
    let viewModel = DetailModels.FetchTracks.ViewModel(tracks: response.tracks)

    viewController?.displayFetchedTracks(viewModel)
  }
}
