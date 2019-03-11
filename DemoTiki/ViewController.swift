//
//  ViewController.swift
//  DemoTiki
//
//  Created by Minh Nguyen on 3/11/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

import UIKit

let urlDemo = "https://tiki-mobile.s3-ap-southeast-1.amazonaws.com/ios/keywords.json"
let items: [String] = [
  "Sim 3G/ 4G Vinaphone Nghe Gọi Tặng 3GB/ Ngày",
  "iphone",
  "Vé máy bay giá rẻ",
  "Combo Sách Đừng Để Lỡ Nhau (Tập 1 + 2)",
  "Macbook Pro 2018",
  "Gói TikiNow 1 năm",
  "Top sách ngoại văn giá rẻ, giảm tới 50%",
  "Linh kiện, phụ kiện máy tính"
]

class ViewController: UIViewController {
  @IBOutlet fileprivate weak var mainCollectionView: UICollectionView!
  
  var tikis: [TikiItemModel] = [] {
    didSet {
      mainCollectionView.reloadData()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 4
    layout.minimumInteritemSpacing = 4
    mainCollectionView.collectionViewLayout = layout
    loadData()
  }
  
  func loadData() {
    TikiItemModel.getList { [weak self] (list) in
      guard let welf = self else { return }
      welf.tikis = list
    }
  }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tikis.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductHotCell", for: indexPath) as! ProductHotCell
    cell.index = indexPath.row
    let item = tikis[indexPath.row]
    cell.fillData(item.keyword, imageUrl: item.icon)
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let text = tikis[indexPath.row].keyword ?? ""
    let text1 = text.split(line: 2).joined(separator: "\n")
    let lbl = UILabel()
    lbl.font = UIFont.systemFont(ofSize: 14)
    lbl.text = text1
    lbl.numberOfLines = 2
    let size: CGSize = lbl.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 50))
    return CGSize(width: max(size.width, 112) + 32, height: 170)
  }
}
