//
//  NewPostTableController.swift
//  Foody
//
//  Created by Giovanni Lenguito on 07/12/2016.
//  Copyright © 2016 Giovanni Lenguito. All rights reserved.
//

import XCTest
@testable import Foody //Import the project

class NewPostTableController: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetAccount(){
        let newPostTableViewController = NewPostTableViewController()
        XCTAssertTrue(newPostTableViewController.getAccount())
    }
    
}
