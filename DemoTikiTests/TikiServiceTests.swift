//
//  TikiServiceTests.swift
//  DemoTikiTests
//
//  Created by Minh Nguyen on 3/12/19.
//  Copyright © 2019 Minh Nguyen. All rights reserved.
//

import UIKit
import Quick
import Nimble
@testable import DemoTiki

class TikiServiceTests: QuickSpec {
  override func spec() {
    beforeEach {
      // NOP
    }
    it("return tiki hot keyword products") {
      var listItem: [TikiItemModel]?
      waitUntil(action: { (done) in
        TikiItemModel.getList { (arr) in
          print(arr)
          listItem = arr
          done()
        }
      })
      
      expect(listItem).notTo(beNil())
      expect(listItem?.count ?? 0 > 0).to(beTrue())
    }
  }
}
