//
//  DetailWorker.swift
//  iTunes Client
//
//  Created by Admin on 07.02.2021.
//

import Foundation

protocol DetailWorkingLogic {
  /// Request to API for loading tracks of collection
  func fetchTracks(collectionId: Int, _ complete: @escaping ([Track]?) -> Void)
}

class DetailWorker: DetailWorkingLogic {

  // MARK: - Private Properties

  private let networkWorker: NetworkWorkingLogic = NetworkWorker()
  private let tracksURL = URL(string: "https://itunes.apple.com/lookup")
  private var params = ["entity": "song"]

  // MARK: - DetailWorkingLogic

  func fetchTracks(collectionId: Int, _ completion: @escaping ([Track]?) -> Void) {
    guard let tracksURL = tracksURL else {
      completion(nil)
      return
    }
    
    params["id"] = String(collectionId)

    networkWorker.sendRequest(to: tracksURL, params: params) { (data, error) in
      guard let data = data else {
        completion(nil)
        return
      }

      let decoder = JSONDecoder()
      let trackListResults = try? decoder.decode(TrackListResults.self, from: data)
      let tracks = trackListResults?.results.tracks;

      completion(tracks)
    }
  }
}
