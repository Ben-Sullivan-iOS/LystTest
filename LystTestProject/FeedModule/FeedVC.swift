//
//  ViewController.swift
//  LystTestProject
//
//  Created by Ben Sullivan on 03/07/2019.
//  Copyright © 2019 Ben Sullivan. All rights reserved.
//

import UIKit
import LystAPIService

class FeedVC: UIViewController, FeedVCInterface {
  
  var presenter: FeedVCPresenterInterface?
  
  var data: FeedVCRepresentable? {
    didSet {
      title = data?.category ?? "Products"
      collectionView.reloadData()
    }
  }
  
  private var selectedCategory = ""
  
  private lazy var numberOfCellsAcross: CGFloat = 2
  private lazy var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
  
  private var cellSize: CGSize {
    
    var cellWidth: CGFloat = 0.0
    if #available(iOS 11.0, *) {
      cellWidth = ((view.safeAreaLayoutGuide.layoutFrame.width - (edgeInsets.left * (numberOfCellsAcross + 1))) / numberOfCellsAcross).rounded(.down)
    } else {
      cellWidth = ((view.frame.width - (edgeInsets.left * (numberOfCellsAcross + 1))) / numberOfCellsAcross).rounded(.down)
    }
    return CGSize(width: cellWidth,
                  height: cellWidth)
  }

  
  lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collection = UICollectionView(frame: view.frame, collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    collection.backgroundColor = .white
    collection.translatesAutoresizingMaskIntoConstraints = false
    collection.isScrollEnabled = true
    return collection
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    //Time constraint - Should be initialised by a coordinator
    //Have had to import LystApiService to this file to allow for dependency injection without a coordinator
    presenter = FeedVCPresenter()
    presenter?.onViewDidLoad(view: self, apiService: APIService())
    
    setNumberOfCellsAcross(withSize: view.intrinsicContentSize)
    
    configureCollectionView()
    
    filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))
    navigationItem.rightBarButtonItem = filterButton
    
  }
  var filterButton: UIBarButtonItem?
  
  @objc func filterTapped() {
    guard let data = data, !data.allCategories.isEmpty else { return }
    
    filterButton?.isEnabled = false
    
    let picker = UIPickerView()
    picker.dataSource = self
    picker.delegate = self
    
    let dummy = UITextField(frame: CGRect.zero)
    dummy.doneAccessory = true
    view.addSubview(dummy)
    dummy.delegate = self
    dummy.inputView = picker
    dummy.becomeFirstResponder()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(true)
    
    collectionView.dataSource = self
    collectionView.delegate = self
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    
    setNumberOfCellsAcross(withSize: size)
    collectionView.collectionViewLayout.invalidateLayout()
    
  }
  
  private func configureCollectionView() {
    collectionView.register(UINib(nibName: ProductCell.identifier, bundle: nil), forCellWithReuseIdentifier: ProductCell.identifier)
    view.addSubview(collectionView)
    layoutCollectionView()
  }
  
  private func layoutCollectionView() {
    if #available(iOS 11.0, *) {
      collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
      collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
      collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
      collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    } else {
      collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
      collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
  }
  
  private func setNumberOfCellsAcross(withSize size: CGSize) {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone:
      if size.width > size.height {
        numberOfCellsAcross = 3
      } else {
        numberOfCellsAcross = 2
      }
    case .pad:
      numberOfCellsAcross = 4
    default: break
    }
  }
}

extension FeedVC: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return data?.products.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
    
    
    if let product = data?.products[indexPath.row], let imageURL = URL(string: product.image) {
      let representable = CellRepresentable(name: product.name, price: product.price, imageURL: imageURL)
      cell.configureView(representable: representable, presenter: ProductCellPresenter())
    }
    
    return cell
  }
  
}

extension FeedVC: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return edgeInsets
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return cellSize
  }
}

extension FeedVC: UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return data?.allCategories.count ?? 0
  }
}

extension FeedVC: UIPickerViewDelegate {
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return data?.allCategories[row] ?? ""
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    selectedCategory = data?.allCategories[row] ?? ""
  }
}

extension FeedVC: UITextFieldDelegate {
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    presenter?.onFilterSelected(forCategory: selectedCategory)
    filterButton?.isEnabled = true
    return true
    
  }
}
