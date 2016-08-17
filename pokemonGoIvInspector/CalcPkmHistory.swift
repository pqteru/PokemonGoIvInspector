//
//  CalcPkmHistory.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/17.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import CoreData
import Foundation

class CalcPkmHistory: NSManagedObject, PropertyNames {

    @NSManaged var name: String
    @NSManaged var cp: Int
    @NSManaged var hp: Int
    @NSManaged var stardust: Int
    @NSManaged var calc_at: String
    @NSManaged var image: String
    @NSManaged var powered: Int
    
    func toDict() -> [String: AnyObject] {
        
        var dict = [String: AnyObject]()
        dict.updateValue(self.name, forKey: "name")
        dict.updateValue(self.cp, forKey: "cp")
        dict.updateValue(self.hp, forKey: "hp")
        dict.updateValue(self.stardust, forKey: "stardust")
        dict.updateValue(self.calc_at, forKey: "calc_at")
        dict.updateValue(self.image, forKey: "image")
        dict.updateValue(self.powered, forKey: "powered")
        
        return dict
    }
}
