//
//  APIService.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 03/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import Foundation

func getCategories(completion: @escaping (Result<Filter, Error>) -> ()) {
  let request = APIRequestConstructor.request(
    for: .filter,
    method: .get,
    excludeCache: false,
    ids: [],
    parameters: [
      APIParameter(type: .pregender, values: ["F"]),
      APIParameter(type: .preproducttype, values: ["Shoes"]),
      APIParameter(type: .filterType, values: ["category"]),
      //        APIParameter(type: .precategory, values: ["heels"]),
      //        APIParameter(type: .precategory, values: ["heels"])
    ],
    body: nil,
    pathSuffix: nil)
  
  
  let task = URLSession.shared.dataTask(with: request!, completionHandler: { (data, response, error) in
    
    do {
      let categories = try JSONDecoder().decode(Filter.self, from: data!)
      completion(Result.success(categories))
    } catch {
      
      print(error)
      
    }
    
  })
  
  task.resume()
}
