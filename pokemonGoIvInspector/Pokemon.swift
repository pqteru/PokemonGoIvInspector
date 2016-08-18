//
//  Pokemon.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/12.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import ObjectMapper

class Pokemon: Mappable {
    
    var id: Int?
    var name: String?
    var type1: String?
    var type2: String?
    var stats: [String: AnyObject] = [:]
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id  <- map["id"]
        name <- map["name"]
        type1 <- map["type1"]
        type2 <- map["type2"]
        stats <- map["stats"]
    }
}

//"id": 1,
//"name": "BULBASAUR",
//"type1": "GRASS",
//"type2": "POISON",
//"stats": {
//    "stamina": 90,
//    "attack": 126,
//    "defense": 126
//},
//"candy": 25,
//"family": "FAMILY_BULBASAUR",
//"moves1": [
//{
//"Id": 221,
//"Name": "TACKLE_FAST",
//"Power": 12,
//"DurationMs": 1100,
//"Energy": 7,
//"DPS": 10.909090909090908
//},
//{
//"Id": 214,
//"Name": "VINE_WHIP_FAST",
//"Power": 7,
//"DurationMs": 650,
//"Energy": 7,
//"DPS": 13.46153846153846
//}
//],
//"moves2": [
//{
//"Id": 118,
//"Name": "POWER_WHIP",
//"Type": "GRASS",
//"Power": 70,
//"DurationMs": 2800,
//"Energy": -100,
//"DPS": 31.25
//},
//{
//"Id": 59,
//"Name": "SEED_BOMB",
//"Type": "GRASS",
//"Power": 40,
//"DurationMs": 2400,
//"Energy": -33,
//"DPS": 20.833333333333336
//},
//{
//"Id": 90,
//"Name": "SLUDGE_BOMB",
//"Type": "POISON",
//"Power": 55,
//"DurationMs": 2600,
//"Energy": -50,
//"DPS": 26.442307692307693
//}
//]
//},
