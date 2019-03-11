//
//  CoreService.swift
//  DemoTiki
//
//  Created by Minh Nguyen on 3/11/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON
//import Result

let errorPlugIn = ErrorPlugin()
let moyaPlugins: [PluginType] = [
  NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter),
  errorPlugIn
]

// MARK: - Provider support
extension Moya.Response {
  func mapNSArray() throws -> NSArray {
    let any = try self.mapJSON()
    guard let array = any as? NSArray else {
      throw MoyaError.jsonMapping(self)
    }
    return array
  }
}

extension MoyaError {
  public var localizedDescription: String {
    return errorDescription ?? "Undefine error."
  }
}

extension String {
  var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

func JSONResponseDataFormatter(_ data: Data) -> Data {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return prettyData
  } catch {
    return data // fallback to original data if it can't be serialized.
  }
}

let defaultDownloadDestination: DownloadDestination = { temporaryURL, response in
  let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
  if !directoryURLs.isEmpty {
    guard let suggestedFilename = response.suggestedFilename else {
      fatalError("@Moya/contributor error!! We didn't anticipate this being nil")
    }
    return (directoryURLs[0].appendingPathComponent(suggestedFilename), [])
  }
  return (temporaryURL, [])
}

public final class ErrorPlugin: PluginType {
  public func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError> {
    switch result {
    case .success(let response):
      if (response.statusCode == 204 || response.statusCode == 200), response.data.count == 0 {
        // Response 200 or 204 with empty data
        let emptyData = "{}".data(using: String.Encoding.utf8)!
        let emptyResponse = Moya.Response(statusCode: response.statusCode, data: emptyData, request: response.request, response: response.response)
        return Result.success(emptyResponse)
      }
      do {
        let any = try response.mapJSON()
        if let json = any as? [String: Any], let error = json["error"] as? Bool, error {
          var userInfo: [String: Any] = [:]
          if let data = json["data"] as? [String: Any], let dataMessage = data["message"] as? String {
            userInfo[NSLocalizedDescriptionKey] = dataMessage
          }
          let mappedError = NSError(domain: (response.request?.url?.absoluteString)!, code: response.statusCode, userInfo: userInfo)
          let moyaError = MoyaError.underlying(mappedError, response)
          return Result.failure(moyaError)
        } else {
          return Result.success(response)
        }
      } catch {
        let moyaError = MoyaError.underlying(error, nil)
        return Result.failure(moyaError)
      }
    case .failure(let error):
      return Result.failure(error)
    }
  }
}
