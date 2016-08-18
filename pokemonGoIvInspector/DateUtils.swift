//
//  DateUtils.swift
//  pokemonGoIvInspector
//
//  Created by David Chen on 2016/8/17.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import Foundation

class DateUtils {
    
    static let sharedInstance = DateUtils()
    
    func currentDate() -> String {
        
        let df = NSDateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let now = NSDate()
        return df.stringFromDate(now)
    }
}