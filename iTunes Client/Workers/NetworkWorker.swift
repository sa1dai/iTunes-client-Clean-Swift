//
//  NetworkWorker.swift
//  iTunes Client
//
//  Created by Admin on 06.02.2021.
//

import Foundation
import UIKit

protocol NetworkWorkingLogic {
  /// Main request to API
  func sendRequest(to: URL, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

class NetworkWorker: NetworkWorkingLogic {

  // MARK: - Private Properties

  private let session = URLSession.shared
  private let application = UIApplication.shared

  // MARK: - NetworkWorkingLogic

  func sendRequest(to: URL, params: [String: String], completion: @escaping (Data?, Error?) -> Void) {
    guard var urlComponents = URLComponents(url: to, resolvingAgainstBaseURL: false) else {
      completion(nil, nil)
      return
    }

    urlComponents.queryItems = params.map {
      URLQueryItem(name: $0.key, value: $0.value)
    }

    guard let requestURL = urlComponents.url else {
      completion(nil, nil)
      return
    }

    let request = session.dataTask(with: requestURL) { (data, response, error) in
      OperationQueue.main.addOperation {
        self.application.isNetworkActivityIndicatorVisible = false
        
        if let error = error {
          completion(nil, error)
          return
        }

        completion(data, nil)
      }
    }

    application.isNetworkActivityIndicatorVisible = true
    request.resume()
  }
}
