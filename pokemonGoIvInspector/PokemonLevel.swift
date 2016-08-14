//
//  PokemonLevel.swift
//  pokemonGoIvInspector
//
//  Created by David Chen on 2016/8/14.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import ObjectMapper

class PokemonLevel: Mappable {
    
    var level: Int?
    var dust: Int?
    var candy: Int?
    var cpScalar: Double?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        level  <- map["level"]
        dust <- map["dust"]
        candy <- map["candy"]
        cpScalar <- map["cpScalar"]
    }
}