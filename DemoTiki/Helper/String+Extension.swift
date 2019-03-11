//
//  String+Extension.swift
//  DemoTiki
//
//  Created by Minh Nguyen on 3/11/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

import UIKit

extension String {
  func split(line: Int, seperator: String = " ") -> [String] {
    let len = self.count/line
    var result = [String]()
    var collectedWords = [String]()
    collectedWords.reserveCapacity(len)
    var count = 0
    let words = self.components(separatedBy: seperator)
    for word in words {
      count += word.count + 1
      if (count > len) {
        // Reached the desired length
        if result.count < line - 1 {
          result.append(collectedWords.map { String($0) }.joined(separator: seperator) )
          collectedWords.removeAll(keepingCapacity: true)
        }
        count = word.count
        collectedWords.append(word)
      } else {
        collectedWords.append(word)
      }
    }
    
    // Append the remainder
    if !collectedWords.isEmpty {
      result.append(collectedWords.map { String($0) }.joined(separator: seperator))
    }
    
    return result
  }
}
