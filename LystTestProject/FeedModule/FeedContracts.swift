//
//  FeedVCContracts.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 05/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

//Imported due to time constraint
//Only coordinators and presenters should be aware of the APIService
import LystAPIService

protocol FeedVCInterface {
  var data: FeedVCRepresentable? { get set }
}

protocol FeedPresenterInterface {
  func onViewDidLoad(view: FeedVCInterface, apiService: APIServiceType)
  func onFilterSelected(forCategory category: String)
}
