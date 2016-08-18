//
//  UIAlertController+ext.swift
//  pokemonGoIvInspector
//
//  Created by David Chen on 2016/8/13.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    convenience init(title: String?, message: String?) {
        self.init(title: title, message: message, preferredStyle: .Alert)
        self.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
    
    convenience init(message: String?) {
        self.init(title: nil, message: message, preferredStyle: .Alert)
        self.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
    }
}