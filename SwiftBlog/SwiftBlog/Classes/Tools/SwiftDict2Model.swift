//
//  SwiftDict2Model.swift
//  SwiftModel2Dict
//
//  Created by King on 15/3/13.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation


@objc protocol DictModelProtocol {
    
    ///  自定义类映射表
    ///
    ///  :returns: 返回可选映射关系字典
    static func customeClassMapping() -> [String: String]?
}


class SwiftDict2Model {
    
    static let instance = SwiftDict2Model()
    class var sharedManager: SwiftDict2Model {
        return instance
    }
    
    ///  字典转模型
    ///
    ///  :param: dict 数据字典
    ///  :param: cls  模型类
    ///
    ///  :returns: 模型对象
    func objectWithDictionary(dict: NSDictionary, cls: AnyClass) -> AnyObject? {
        
        let dictInfo = fullModelInfo(cls)
        
        //        println(dictInfo)
        
        let obj: AnyObject = cls.alloc()
        
        for (k, v) in dictInfo {
            if let value: AnyObject = dict[k] {
                if v.isEmpty && !(value === NSNull()) {
                    obj.setValue(value, forKey: k)
                } else {
                    let type = "\(value.classForCoder)"
                    if type == "NSDictionary" {
                        if let subObj: AnyObject = objectWithDictionary(value as! NSDictionary, cls: NSClassFromString(v)) {
                            obj.setValue(subObj, forKey: k)
                        }
                    } else if type == "NSArray" {
                        if let subObj: AnyObject = objectsWithArray(value as! NSArray, cls: NSClassFromString(v)) {
                            obj.setValue(subObj, forKey: k)
                        }
                    }
                }
            }
        }
        return obj
    }
    
    func objectsWithArray(array: NSArray, cls: AnyClass) -> NSArray? {
        
        var list = [AnyObject]()
        
        for value in array {
            let type = "\(value.classForCoder)"
            
            if type == "NSDictionary" {
                if let subObj: AnyObject = objectWithDictionary(value as! NSDictionary, cls: cls) {
                    list.append(subObj)
                }
            } else if type == "NSArray" {
                if let subObj: AnyObject = objectsWithArray(value as! NSArray, cls: cls) {
                    list.append(subObj)
                }
            }
        }
        
        if list.count > 0 {
            return list
        } else {
            return nil
        }
    }
    
    var modelCache = [String: [String: String]]()
    
    ///  加载完整类信息
    ///
    ///  :param: cls 模型类
    ///
    ///  :returns: 返回模型完整信息
    func fullModelInfo(cls: AnyClass) -> [String: String] {
        
        // 检测缓冲池
        if let cache = modelCache["\(cls)"] {
            return cache
        }
        
        var currentCls: AnyClass = cls
        
        var infoDict = [String: String]()
        while let parent: AnyClass = currentCls.superclass() {
            infoDict.merge(modelInfo(currentCls))
            currentCls = parent
        }
        
        modelCache["\(cls)"] = infoDict
        
        return infoDict
    }
    
    ///  加载类信息
    ///
    ///  :param: cls 模型类
    ///
    ///  :returns: 模型类信息
    func modelInfo(cls: AnyClass) -> [String: String] {
        
        // 检测缓冲池
        if let cache = modelCache["\(cls)"] {
            return cache
        }
        
        var count: UInt32 = 0
        let properties = class_copyPropertyList(cls, &count)
        
        // 检查类是否实现协议
        var mappingDict: [String: String]?
        if cls.respondsToSelector("customeClassMapping") {
            mappingDict = cls.customeClassMapping()
        }
        
        var infoDict = [String: String]()
        for i in 0..<count {
            let property = properties[Int(i)]
            
            // 获取属性名称
            let name = String.fromCString(property_getName(property))
            let type = mappingDict?[name!] ?? ""
            
            infoDict[name!] = type
        }
        
        free(properties)
        
        modelCache["\(cls)"] = infoDict
        
        return infoDict
    }
}

extension Dictionary {
    mutating func merge<K, V>(dict: [K: V]) {
        for (k, v) in dict {
            self.updateValue(v as! Value, forKey: k as! Key)
        }
    }
}
