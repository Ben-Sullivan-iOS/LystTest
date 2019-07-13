//
//  FeedVCPresenter.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 05/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import Foundation
import LystAPIService

//  The primary role of a presenter is to request objects from the network
//  and create Representables to be passed to the view. It does not know
//  anything about the view other than the data it requires.
class FeedPresenter: FeedPresenterInterface {
  
  private var view: FeedVCInterface?
  private var apiService: APIServiceType?
  
  private var allCategories = [String]()
  
  func onViewDidLoad(view: FeedVCInterface, apiService: APIServiceType) {
    self.view = view
    self.apiService = apiService
    getCategories()
  }
  
  func onFilterSelected(forCategory category: String) {
    getProducts(forCategories: [ProductCategoryNetworkModel(value: category.lowercased())])
  }
  
  private func getCategories() {
    APIService().getShoeCategories(forGender: .female) { result in
      switch result {
      case .success(let networkResult):
        networkResult.productCategories.forEach { category in
          self.allCategories.append(category.value.firstUppercased)
        }
        self.getProducts(forCategories: networkResult.productCategories)
        
      case .failure(let error):
        print(error)
      }
    }
  }
  
  private func getProducts(forCategories categories: [ProductCategoryNetworkModel]) {
    apiService?.getProducts(forProductTypes: categories) { result in
      switch result {
      case .success(let productResult):
        
        DispatchQueue.main.async {
          
          var productRepresentables = [ProductRepresentable]()
          
          productResult.productResult.products.forEach { product in
            
            let rep = ProductRepresentable(price: product.price, name: product.title, image: product.image)
            productRepresentables.append(rep)
            
          }
          
          let category = categories.count > 1 ? "All Shoe Categories" : categories.first?.value ?? "Products"

          let representable = FeedVCRepresentable(allCategories: self.allCategories, category: category, products: productRepresentables)
          self.view?.data = representable
        }
        
      case .failure(let error):
        print(error)
      }
    }
    
  }
  
}
