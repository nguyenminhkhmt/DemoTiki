//
//  TikiService.swift
//  DemoTiki
//
//  Created by Minh Nguyen on 3/11/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

let tikiProvider = MoyaProvider<TikiService>(plugins: moyaPlugins)
enum TikiService {
  case checkHotKeyword
}

extension TikiService: TargetType {
  var baseURL: URL {
    return URL(string: "https://tiki-mobile.s3-ap-southeast-1.amazonaws.com")!
  }
  
  var path: String {
    return "ios/keywords.json"
  }
  
  var method: Moya.Method {
    return .get
  }
  
  var headers: [String : String]? {
    return nil
  }
  
  var sampleData: Data {
    return Data()
  }
  
  var task: Task {
    return .requestPlain
  }
}
