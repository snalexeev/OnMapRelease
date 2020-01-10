//
//  onMapTests.swift
//  onMapTests
//

import XCTest
@testable import onMap
//import

class onMapTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        //let test2 = LoginViewController()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let test = FirestoreMessengerTest()
        test.startTestAddChat(n: 30)
        XCTAssert(test.result, "создание чатов")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
