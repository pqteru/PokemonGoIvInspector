//
//  PokemonMove.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/18.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import ObjectMapper

// example
//    "Id": 221,
//    "Name": "TACKLE_FAST",
//    "Power": 12,
//    "DurationMs": 1100,
//    "Energy": 7,
//    "DPS": 10.909090909090908

class PokemonMove: Mappable {

    var id: Int?
    var name: String?
    var power: Int?
    var durationMs: Int?
    var energy: Int?
    var dps: Double?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id  <- map["id"]
        name <- map["name"]
        power <- map["power"]
        durationMs <- map["durationMs"]
        energy <- map["energy"]
        dps <- map["dps"]
    }
}