//
//  ProductHotCell.swift
//  DemoTiki
//
//  Created by Minh Nguyen on 3/11/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

import UIKit

let colors = [
  UIColor(rgb: 0x16702e),
  UIColor(rgb: 0x005a51),
  UIColor(rgb: 0x996c00),
  UIColor(rgb: 0x5c0a6b),
  UIColor(rgb: 0x006d90),
  UIColor(rgb: 0x974e06),
  UIColor(rgb: 0x99272e),
  UIColor(rgb: 0x89221f),
  UIColor(rgb: 0x00345d)
]

class ProductHotCell: UICollectionViewCell {
  @IBOutlet fileprivate weak var lblTitle: UILabel!
  @IBOutlet fileprivate weak var ivProduct: UIImageView!
  @IBOutlet fileprivate weak var vBorder: UIView!
  
  var index: Int = 0
  
  override func prepareForReuse() {
    super.prepareForReuse()
    lblTitle.text = nil
    ivProduct.image = nil
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    lblTitle.textColor = .white
    lblTitle.numberOfLines = 2
    lblTitle.font = UIFont.systemFont(ofSize: 14)
    
    lblTitle.preferredMaxLayoutWidth = 100
    
    vBorder.layer.cornerRadius = 4
    vBorder.clipsToBounds = true
  }
  
  func fillData(_ title: String?, imageUrl: String?) {
    lblTitle.text = title
    if let imageUrl = imageUrl {
      ivProduct.kf.setImage(with: URL(string: imageUrl))
    }
    vBorder.backgroundColor = colors[index % colors.count]
  }
}
