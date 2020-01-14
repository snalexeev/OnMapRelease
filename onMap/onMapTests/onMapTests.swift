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
        
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        
        let bd = TestMessenger()
        var key = bd.testAddChat()
        XCTAssert(key, "Создание чата")
        key = bd.testSend()
        XCTAssert(key, "Отправка сообщения")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
