//
//  DetailRouter.swift
//  iTunes Client
//
//  Created by Admin on 07.02.2021.
//

import UIKit

@objc protocol DetailRoutingLogic {

}

protocol DetailDataPassing {
  var dataStore: DetailDataStore? { get }
}

class DetailRouter: NSObject, DetailRoutingLogic, DetailDataPassing {

  // MARK: - Private

  // MARK: - Public

  weak var viewController: DetailViewController?
  var dataStore: DetailDataStore?

  // MARK: - DetailRoutingLogic

  // MARK: - Navigation

  // MARK: - Passing data
}

