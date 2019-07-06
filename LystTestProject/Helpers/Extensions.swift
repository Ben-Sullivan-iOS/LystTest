//
//  Extensions.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 05/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
  static var identifier: String {
    return String(describing: self.self)
  }
}

extension StringProtocol {
  var firstUppercased: String {
    return prefix(1).uppercased()  + dropFirst()
  }
  var firstCapitalized: String {
    return prefix(1).capitalized + dropFirst()
  }
}
