//
//  SwiftNetWorking.swift
//  SwiftNetWorking
//
//  Created by King on 15/3/9.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

public class SwiftNetWorking {
    
    ///  定义闭包
    public typealias Completion = ((resule: AnyObject?, error: NSError?)->())
    
    ///  请求JSON
    public func requestJSON(method: HTTPMethod, _ urlString: String, _ params: [String: String]?, completion: Completion) {
        if let request = request(method, urlString, params) {
            session?.dataTaskWithRequest(request, completionHandler: { (data, _, error) -> Void in
                
                if error != nil {
                    completion(resule: nil, error: error)
                    return
                }
                
                // 反序列化 -> 字典或者数组
                let json: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: nil)
                
                if json == nil {
                    let error = NSError(domain: SwiftNetWorking.errorDomain, code: -1, userInfo: ["error": "反序列化失败"])
                }else {
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        completion(resule: json, error: nil)
                    })
                }
            }).resume()
            return
        }

        let error = NSError(domain: SwiftNetWorking.errorDomain, code: -1, userInfo: ["error": "请求建立失败"])
        completion(resule: nil, error: error)
    }
    
    static let errorDomain = "com.king.error"
    
    ///  获取网络请求
    ///
    ///  :param: method    请求方法
    ///  :param: urlString urlString
    ///  :param: params    可选字典参数
    ///
    ///  :returns: 返回网络请求
    func request(method: HTTPMethod, _ urlString: String, _ params: [String: String]?) -> NSURLRequest? {
        
        if urlString.isEmpty {
            return nil
        }
        
        var urlstr = urlString
        var req: NSMutableURLRequest?
        
        if method == .GET {
            if let query = queryString(params) {
                urlstr += "?" + query
            }
            
            req = NSMutableURLRequest(URL: NSURL(string: urlstr)!)
        }else {
            if let query = queryString(params) {
                req = NSMutableURLRequest(URL: NSURL(string: urlString)!)
                
                req?.HTTPMethod = method.rawValue
                req?.HTTPBody = query.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            }
        }
        
        return req
    }
    
    ///  生成查询字符串
    ///
    ///  :param: params 可选字典参数
    ///
    ///  :returns: 拼接字符串
    func queryString(params: [String: String]?)->String? {
        
        if params == nil {
            return nil
        }
        
        var array = [String]()
        
        for (k, v) in params! {
            let str = k + "=" + v.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            array.append(str)
        }
        
        return join("&", array)
    }
    
    /// 全局网络会话
    lazy var session: NSURLSession? = {
        return NSURLSession.sharedSession()
    }()
    
}