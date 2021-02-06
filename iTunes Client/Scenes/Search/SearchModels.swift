//
//  SearchModels.swift
//  iTunes Client
//
//  Created by Admin on 06.02.2021.
//

enum SearchModels {

  enum FetchCollections {
    struct Request {
      let searchText: String
    }

    struct Response {
      let collections: [Collection]
    }

    struct ViewModel {
      let collections: [Collection]
    }
  }

  enum SelectCollection {
    struct Request {
      let collection: Collection
    }
  }
}
