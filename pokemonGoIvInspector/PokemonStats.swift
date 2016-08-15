//
//  PokemonStats.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/15.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import Foundation

class PokemonStats {
    
    var lv: Int = 0
    var atk: Int = 0
    var def: Int = 0
    var sta: Int = 0
    var perfection: Double = 0.0
    
    func calcPerfection() {
        
        self.perfection = calcPrefection()
    }
    
    func calcPrefection() -> Double {
        
        //current
        let current = self.atk + self.def + self.sta
        
        // max
        let total = getMaxAtk() + getMaxDef() + getMaxSta();
        
        let pref = Double(current)/Double(total)
        //log.debug("pref: \(pref))")
        
        return pref.roundToPlaces(2)
    }
    
    func getMaxAtk() -> Int {
        return 15
    }
    
    func getMaxDef() -> Int {
        return 15
    }
    
    func getMaxSta() -> Int {
        return 15
    }
}

extension PokemonStats: Comparable {}

func ==(a: PokemonStats, b: PokemonStats) -> Bool {
    return a.perfection == b.perfection
}

func <(a: PokemonStats, b: PokemonStats) -> Bool {
    return a.perfection < b.perfection
}

func >(a: PokemonStats, b: PokemonStats) -> Bool {
    return a.perfection > b.perfection
}