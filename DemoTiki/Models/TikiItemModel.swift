//
//  TikiItemModel.swift
//  DemoTiki
//
//  Created by Minh Nguyen on 3/11/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

import UIKit
import ObjectMapper

class TikiItemModel: Mappable {
  var keyword: String?
  var icon: String?
  
  required init?(map: Map) {
  }
  
  func mapping(map: Map) {
    keyword <- map["keyword"]
    icon <- map["icon"]
  }
}

extension TikiItemModel {
  class func getList(completedBlock: @escaping ([TikiItemModel])  -> Void) {
    tikiProvider.request(.checkHotKeyword) { (result) in
      switch result {
      case .failure(let error):
        print(error.localizedDescription)
        completedBlock([])
      case .success(let response):
        print(response)
        if let json = try! response.mapJSON() as? [String: Any], let keywords = json["keywords"] as? [[String: Any]] {
          var result: [TikiItemModel] = []
          for each in keywords {
            if let item = Mapper<TikiItemModel>().map(JSON: each) {
              result.append(item)
            }
          }
          completedBlock(result)
        } else {
          completedBlock([])
        }
      }
    }
  }
}
