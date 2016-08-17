//
//  BaseManager.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/17.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit
import CoreData

class BaseManager: NSObject {

    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var completionHandler: ((Void)->Void)?
    
    func saveObject() {
        
        do {
            // save
            try moc.save()
            log.debug("saved!")
            completionHandler?()
            
        } catch let error as NSError {
            log.error("error: \(error.localizedDescription)")
        }
    }
}
