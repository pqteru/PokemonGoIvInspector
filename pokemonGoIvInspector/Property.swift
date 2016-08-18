//
//  Property.swift
//  BarcodeScanner
//
//  Created by davidchen on 2016/7/27.
//  Copyright © 2016年 rakuya. All rights reserved.
//

import Foundation

protocol PropertyNames {
    func propertyNames() -> [String]
}

extension PropertyNames
{
    func propertyNames() -> [String] {
        var count = UInt32()
        let classToInspect = NSURL.self
        let properties : UnsafeMutablePointer <objc_property_t> = class_copyPropertyList(classToInspect, &count)
        var propertyNames = [String]()
        let intCount = Int(count)
        for i in 0 ..< intCount {
            let property : objc_property_t = properties[i]
            guard let propertyName = NSString(UTF8String: property_getName(property)) as? String else {
                debugPrint("Couldn't unwrap property name for \(property)")
                break
            }
            
            propertyNames.append(propertyName)
        }
        
        free(properties)
        return propertyNames
    }
}