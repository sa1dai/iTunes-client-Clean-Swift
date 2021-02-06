//
//  DetailModels.swift
//  iTunes Client
//
//  Created by Admin on 07.02.2021.
//

import Foundation

enum DetailModels {

  enum ShowCollection {
    struct Request {
    }

    struct Response {
      let collection: Collection?
    }

    struct ViewModel {
      let collection: Collection?
    }
  }
  
  // MARK: - Fetch collection tracks
  
  enum FetchTracks {
    struct Request {}

    struct Response {
      let tracks: [Track]
    }

    struct ViewModel {
      let tracks: [Track]
    }
  }
}
