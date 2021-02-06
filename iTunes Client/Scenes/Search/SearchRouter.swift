//
//  SearchRouter.swift
//  iTunes Client
//
//  Created by Admin on 07.02.2021.
//

import UIKit

@objc protocol SearchRoutingLogic {
  func routeToDetail(segue: UIStoryboardSegue)
}

protocol SearchDataPassing {
  var dataStore: SearchDataStore? { get }
}

class SearchRouter: NSObject, SearchRoutingLogic, SearchDataPassing {

  // MARK: - Private

  // MARK: - Public

  weak var viewController: SearchViewController?
  var dataStore: SearchDataStore?

  // MARK: - SearchRoutingLogic

  func routeToDetail(segue: UIStoryboardSegue) {
      guard
        let homeDS = dataStore,
        let detailVC = segue.destination as? DetailViewController,
        var detailDS = detailVC.router?.dataStore
        else { fatalError("Fail route to detail") }

      passDataToDetail(source: homeDS, destination: &detailDS)
  }

  // MARK: - Passing data

  private func passDataToDetail(source: SearchDataStore, destination: inout DetailDataStore) {
    destination.collection = source.selectedCollection
  }
}
