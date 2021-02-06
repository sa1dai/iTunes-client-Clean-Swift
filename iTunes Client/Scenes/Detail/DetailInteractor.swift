//
//  DetailInteractor.swift
//  iTunes Client
//
//  Created by Admin on 07.02.2021.
//

import Foundation

protocol DetailBusinessLogic {
  func showCollection(_ request: DetailModels.ShowCollection.Request)
  func fetchTracks(_ request: DetailModels.FetchTracks.Request)
}

protocol DetailDataStore {
  var collection: Collection? { get set }
  var tracks: [Track] { get }
}

class DetailInteractor: DetailBusinessLogic, DetailDataStore {

  // MARK: - Public Properties

  var presenter: DetailPresentationLogic?
  lazy var worker: DetailWorkingLogic = DetailWorker()

  var collection: Collection?
  var tracks: [Track] = []

  // MARK: - DetailBusinessLogic

  func showCollection(_ request: DetailModels.ShowCollection.Request) {
    let response = DetailModels.ShowCollection.Response(collection: collection)

    presenter?.presentCollection(response)
  }
  
  func fetchTracks(_ request: DetailModels.FetchTracks.Request) {
    guard let collection = collection else {
      return
    }

    worker.fetchTracks(collectionId: collection.collectionId) { tracks in
      let tracks = tracks ?? []
      let response = DetailModels.FetchTracks.Response(tracks: tracks)

      self.tracks = tracks
      self.presenter?.presentFetchedTracks(response)
    }
  }
}
