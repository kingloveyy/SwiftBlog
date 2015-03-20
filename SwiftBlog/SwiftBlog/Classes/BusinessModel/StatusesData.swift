//
//  StatusesData.swift
//  SwiftBlog
//
//  Created by King on 15/3/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

///  微博数据列表模型
class StatusesData: NSObject {
    ///  微博记录数组
    var statuses: [Status]?
    ///  微博总数
    var total_number: Int = 0
    ///  未读数辆
    var has_unread: Int = 0
}

///  微博模型
class Status: NSObject, DictModelProtocol {
    ///  微博创建时间
    var created_at: String?
    ///  微博ID
    var id: Int = 0
    ///  微博信息内容
    var text: String?
    ///  微博来源
    var source: String?
    ///  转发数
    var reposts_count: Int = 0
    ///  评论数
    var comments_count: Int = 0
    ///  表态数
    var attitudes_count: Int = 0
    ///  配图数组
    var pic_urls: [StatusPictureURL]?
    /// 用户信息
    var user: UserInfo?
    /// 转发微博
    var retweeted_status: Status?
    
    static func customeClassMapping() -> [String : String]? {
        return ["pic_urls": "\(StatusPictureURL.self)",
                    "user": "\(UserInfo.self)",
        "retweeted_status": "\(Status.self)"]

    }
}

///  微博配图模型
class StatusPictureURL: NSObject {
    ///  缩略图 URL
    var thumbnail_pic: String?
}
