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
    var image: String?
    var moves1: [PokemonMove]?
    var moves2: [PokemonMove]?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        
        id  <- map["id"]
        name <- map["name"]
        type1 <- map["type1"]
        type2 <- map["type2"]
        stats <- map["stats"]
        image <- map["image"]
        moves1 <- map["moves1"]
        moves2 <- map["moves2"]
    }
}