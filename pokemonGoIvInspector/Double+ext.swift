//
//  Double+ext.swift
//  pokemonGoIvInspector
//
//  Created by David Chen on 2016/8/13.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import Foundation

extension Double {
    
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}