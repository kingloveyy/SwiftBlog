//
//  NetWorkManager.swift
//  SwiftBlog
//
//  Created by King on 15/3/10.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
import SwiftNetWorking

class NetWorkManager {
    
    private static let instance = NetWorkManager()
    class var sharedManager: NetWorkManager {
        return instance
    }
    
    ///  定义闭包
    typealias Completion = ((resule: AnyObject?, error: NSError?)->())
    
    ///  请求JSON
    func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]?, completion: Completion) {
        net.requestJSON(method, urlString, params, completion: completion)
        
    }
    
    ///  定义全局网络实例
    private let net = SwiftNetWorking()
    
}
