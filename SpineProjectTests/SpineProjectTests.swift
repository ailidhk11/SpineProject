//
//  SpineProjectTests.swift
//  SpineProjectTests
//
//  Created by Ailidh Kinney on 08/08/2022.
//

import XCTest
@testable import SpineProject

class SpineProjectTests: XCTestCase {
    
    var model: ViewModel!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      model = ViewModel()
    }
    
    func testHandleAddToCRWorks() {
        // Given
        //var expected: Int = 0
        
        // When
       // expected = model.currentlyReading.count
        
//        // Then
//        XCTAssert(expected ==
        
    }

    override func tearDown()  {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        model = nil
    }

    func spineBooksShouldNotBeEmpty() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
   
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
