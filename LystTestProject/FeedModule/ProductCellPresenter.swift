//
//  ProductCellPresenter.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 05/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import UIKit
import LystAPIService

protocol ProductCellPresenterInterface {
  func onViewConfigured(withURL url: URL, cell: ProductCellInterface)
}

class ProductCellPresenter: ProductCellPresenterInterface {
  
  var cell: ProductCellInterface?
  
  func onViewConfigured(withURL url: URL, cell: ProductCellInterface) {
    self.cell = cell
    APIService().downloadImageData(withURL: url) { result in
      switch result {
      case .success(let imageData):
        
        guard let image = UIImage(data: imageData) else { return }
        
        self.cell?.productImage = image
        
      default: break
      }
    }
  }
  
}
