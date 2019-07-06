//
//  FeedModels.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 06/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import UIKit

struct ProductRepresentable {
  let price: String
  let name: String
  let image: String
}

struct FeedVCRepresentable {
  let allCategories: [String]
  let category: String
  let products: [ProductRepresentable]
}

struct CellRepresentable {
  let name: String
  let price: String
  let imageURL: URL
}

protocol ProductCellInterface {
  var productImage: UIImage? { get set }
}
