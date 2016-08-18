//
//  CalcPkmHistoryManager.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/17.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit
import CoreData

@objc(CalcPkmHistoryManager)
class CalcPkmHistoryManager: BaseManager {
    
    // 30 rows only
    static let maxLimit = 30
    
    static let sharedInstance = CalcPkmHistoryManager()
    
    func listHistoryFetchRequest() -> NSFetchRequest {
        
        let entity = NSEntityDescription.entityForName("CalcPkmHistory", inManagedObjectContext: moc)
        let sortDescriptor = NSSortDescriptor(key: "calc_at", ascending: false)
        let fetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
    
    func getHistoryCount() -> Int {
        
        let fetchRequest = listHistoryFetchRequest()
        var error: NSError? = nil
        let count = moc.countForFetchRequest(fetchRequest, error: &error)
        return count
    }
    
    func insertCalcPkmHistoryByParam(param: NSDictionary, completionHandler: ((Void)->Void)?) {
        
        log.debug("inserting CalcPkmHistory object...")
        log.debug("param: \(param)")
        
        // insert
        let obj = NSEntityDescription.insertNewObjectForEntityForName("CalcPkmHistory", inManagedObjectContext: self.moc) as! CalcPkmHistory
        obj.name = param["name"] as! String
        obj.image = param["image"] as! String
        obj.cp = param["cp"] as! Int
        obj.hp = param["hp"] as! Int
        obj.stardust = param["stardust"] as! Int
        obj.powered = param["powered"] as! Int
        obj.maxPerf = param["maxPerf"] as! String
        obj.avgPerf = param["avgPerf"] as! String
        obj.minPerf = param["minPerf"] as! String
        
        // setup calc time
        obj.calc_at = DateUtils.sharedInstance.currentDate()
        
        self.completionHandler = completionHandler
        self.saveObject()
        
        // if histroy exceed maxLimit then delete last record
        if getHistoryCount() > CalcPkmHistoryManager.maxLimit {
            deleteOldestCalcPkmHistory()
        }
    }
    
    func deleteOldestCalcPkmHistory() {
        
        log.debug("deleting last CalcPkmHistory...")
        
        let fetchRequest = listHistoryFetchRequest()
        do {
            let ary = try moc.executeFetchRequest(fetchRequest)
            let obj = ary.last as! CalcPkmHistory
            moc.deleteObject(obj)
            self.saveObject()
            
        } catch let error as NSError {
            log.error("error: \(error.localizedDescription)")
        }
        
    }
}
