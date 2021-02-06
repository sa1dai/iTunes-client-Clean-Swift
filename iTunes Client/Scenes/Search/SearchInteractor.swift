//
//  SearchInteractor.swift
//  iTunes Client
//
//  Created by Admin on 06.02.2021.
//

protocol SearchBusinessLogic {
  func fetchCollections(_ request: SearchModels.FetchCollections.Request)
  func selectCollection(_ request: SearchModels.SelectCollection.Request)
}

protocol SearchDataStore {
  var collections: [Collection] { get }
  var selectedCollection: Collection? { get }
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {

  // MARK: - Public

  var presenter: SearchPresentationLogic?
  lazy var worker: SearchWorkingLogic = SearchWorker()

  var collections: [Collection] = []
  var selectedCollection: Collection?

  // MARK: - SearchBusinessLogic

  func fetchCollections(_ request: SearchModels.FetchCollections.Request) {
    worker.fetchCollections(searchText: request.searchText) { collections in
      let collections = collections ?? []
      let response = SearchModels.FetchCollections.Response(collections: collections)

      self.collections = collections
      self.presenter?.presentFetchedCollections(response)
    }
  }

  func selectCollection(_ request: SearchModels.SelectCollection.Request) {
    selectedCollection = request.collection
  }
}

