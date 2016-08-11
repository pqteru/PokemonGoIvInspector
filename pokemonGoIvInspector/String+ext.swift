//
//  String+ext.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/11.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import Foundation

extension String {
    
    /*
     Get length
     */
    var length: Int {
        return characters.count
    }
    
    /*
     Range from NSRange
     */
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
    
    
}