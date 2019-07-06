//
//  ProductCell.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 05/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import UIKit

class ProductCell: UICollectionViewCell, ProductCellInterface {
  
  @IBOutlet weak var cardView: UIView!
  @IBOutlet weak var mainImage: UIImageView!
  @IBOutlet weak var priceLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  private let cornerRadius: CGFloat = 12
  
  private var presenter: ProductCellPresenterInterface?

  var productImage: UIImage? {
    didSet {
      self.mainImage.alpha = 0
      mainImage.image = productImage
      
      UIView.animate(withDuration: 0.3) {
        self.mainImage.alpha = 1
      }
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    mainImage.image = nil
    priceLabel.text = ""
    nameLabel.text = ""
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    styleCardView()
    styleMainImage()
    stylePriceLabel()
    styleNameLabel()
  }
  
  func configureView(representable: CellRepresentable, presenter: ProductCellPresenterInterface) {
    self.presenter = presenter
    priceLabel.text = representable.price
    nameLabel.text = representable.name
    
    self.presenter?.onViewConfigured(withURL: representable.imageURL, cell: self)
  }
  
  private func styleCardView() {
    cardView.layer.cornerRadius = cornerRadius
    
    cardView.layer.shadowColor = UIColor.gray.cgColor
    cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    cardView.layer.shadowRadius = 5
    cardView.layer.shadowOpacity = 0.5
  }
  
  private func stylePriceLabel() {
    priceLabel.textColor = .lightGray
    priceLabel.font = .systemFont(ofSize: 10)
  }
  
  private func styleMainImage() {
    if #available(iOS 11.0, *) {
      mainImage.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    } else {
      mainImage.layer.cornerRadius = 12
    }
    
    mainImage.clipsToBounds = true
    mainImage.layer.cornerRadius = cornerRadius
  }
  
  private func styleNameLabel() {
    nameLabel.textColor = .black
    nameLabel.font = .systemFont(ofSize: 14)
  }
  
}
