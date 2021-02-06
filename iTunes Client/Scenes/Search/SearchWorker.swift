//
//  SearchWorker.swift
//  iTunes Client
//
//  Created by Admin on 06.02.2021.
//

import Foundation

protocol SearchWorkingLogic {
  /// Request to API for loading list of collections
  func fetchCollections(searchText: String, _ completion: @escaping ([Collection]?) -> Void)
}

class SearchWorker: SearchWorkingLogic {

  // MARK: - Private Properties

  private let networkWorker: NetworkWorkingLogic = NetworkWorker()
  private let collectionsURL = URL(string: "https://itunes.apple.com/search")
  private var params = ["media": "music", "entity": "album"]

  // MARK: - SearchWorkingLogic

  func fetchCollections(searchText: String, _ completion: @escaping ([Collection]?) -> Void) {
    guard let collectionsURL = collectionsURL else {
      completion(nil)
      return
    }
    
    params["term"] = searchText

    networkWorker.sendRequest(to: collectionsURL, params: params) { (data, error) in
      guard let data = data else {
        completion(nil)
        return
      }

      let decoder = JSONDecoder()
      let collectionListResults = try? decoder.decode(CollectionListResults.self, from: data)
      let collections = collectionListResults?.results;

      completion(collections)
    }
  }
}
