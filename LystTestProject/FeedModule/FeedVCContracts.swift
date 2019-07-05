//
//  FeedVCContracts.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 05/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import Foundation
//Only imported due to time constraint, should only be in coordinator
import LystAPIService

public struct ProductRepresentable {
  public let price: String
  public let name: String
  public let image: String
}

struct FeedVCRepresentable {
  let allCategories: [String]
  let category: String
  let products: [ProductRepresentable]
}

protocol FeedVCInterface {
  var data: FeedVCRepresentable? { get set }
}

protocol FeedVCPresenterInterface {
  func onViewDidLoad(view: FeedVCInterface, apiService: APIServiceType)
  func onFilterSelected(forCategory category: String)
}
