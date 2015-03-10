//
//  SwiftNetWorkingTests.swift
//  SwiftNetWorkingTests
//
//  Created by King on 15/3/9.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import XCTest

class SwiftNetWorkingTests: XCTestCase {
    
    let net = SwiftNetWorking()
    let urlString = "http://httpbin.org/get"
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    ///  请求json
    func testRequestJSON() {

        let expectation = expectationWithDescription(urlString)
        
        net.requestJSON(.GET, urlString, nil) { (result, error) -> () in
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(10.0, handler: { (error) -> Void in
            XCTAssertNil(error)
        })
    }
    
    ///  测试 POST 请求
    func testPostRequest() {
        var r = net.request(.POST, urlString, nil)
        XCTAssertNil(r, "请求应该为 nil")
        
        r = net.request(.POST, urlString, ["name": "zhang"])
        XCTAssert(r!.HTTPMethod == "POST", "访问方法不正确")
        // 测试数据体
        XCTAssert(r!.HTTPBody! == "name=zhang".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true), "数据体不正确")
    }
    
    /// 测试错误的网络请求
    func testErrorRequest() {
        net.requestJSON(.GET, "", nil) { (resule, error) -> () in
            XCTAssertNotNil(error, "必须返回错误")
        }
    }
    
    ///  测试 GET 请求
    func testGetRequest() {

        var r = net.request(.GET, "", nil)
        XCTAssertNil(r, "请求应该为空")
        
        r = net.request(.GET, urlString, nil)
        XCTAssertNotNil(r, "请求应该被建立")
        XCTAssert(r!.URL!.absoluteString == urlString, "返回的 URL 不正确")
        
        r = net.request(.GET, urlString, ["name": "zhangsan"])
        XCTAssert(r!.URL!.absoluteString == urlString + "?name=zhangsan", "返回的 URL 不正确")
    }

    
    func testQueryString() {

        net.queryString(["name":"zhangsan"])
        XCTAssertNil(net.queryString(nil), "查询参数应该为空")
        XCTAssert(net.queryString(["name": "zhangsan"])! == "name=zhangsan")
        XCTAssert(net.queryString(["name": "zhangsan", "title": "boss"])! == "title=boss&name=zhangsan")
        // 测试百分号转义
        println(net.queryString(["name": "zhangsan", "book": "ios 8.0"])!)
        XCTAssert(net.queryString(["name": "zhangsan", "book": "ios 8.0"])! == "book=ios%208.0&name=zhangsan")
    }
    
   
    
}
