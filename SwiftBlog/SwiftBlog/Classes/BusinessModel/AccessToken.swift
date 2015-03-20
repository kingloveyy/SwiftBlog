//
//  AccessToken.swift
//  SwiftBlog
//
//  Created by King on 15/3/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class AccessToken: NSObject,NSCoding {
   
    ///  用于调用access_token，接口获取授权后的access token。
    var access_token: String?
    ///  access_token的生命周期，单位是秒数。
    var expires_in: NSNumber? {
        didSet {
            expiresDate = NSDate(timeIntervalSinceNow: expires_in!.doubleValue)
//            println("过期日期 \(expiresDate)")
        }
    }
    
    ///  token过期日期
    var expiresDate: NSDate?
    /// 是否过期
    var isExpired: Bool {
        return expiresDate?.compare(NSDate()) == NSComparisonResult.OrderedAscending
    }
    
    ///  access_token的生命周期（该参数即将废弃，开发者请使用expires_in）。
    var remind_in: NSNumber?
    ///  当前授权用户的UID
    var uid : Int = 0
    
    init(dict: NSDictionary) {
        super.init()
        self.setValuesForKeysWithDictionary(dict as [NSObject : AnyObject])
    }
    
    ///  将数据保存到沙盒
    func saveAccessToken() {
        NSKeyedArchiver.archiveRootObject(self, toFile: AccessToken.tokenPath())
    }
    
    ///  从沙盒读取 token 数据
    func loadAccessToken() -> AccessToken? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(AccessToken.tokenPath()) as? AccessToken
    }
    
    ///  返回保存在沙盒的路径
    class func tokenPath() -> String {
        var path =  NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).last as! String
        path = path.stringByAppendingPathComponent("token.plist")
        println(path)
        return path
    }
    
    // MARK: - 归档&接档
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(access_token)
        aCoder.encodeObject(access_token)
        aCoder.encodeObject(expiresDate)
        aCoder.encodeInteger(uid, forKey: "uid")
    }
    
    required init(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject() as? String
        expiresDate = aDecoder.decodeObject() as? NSDate
        uid = aDecoder.decodeIntegerForKey("uid")
    }

}
