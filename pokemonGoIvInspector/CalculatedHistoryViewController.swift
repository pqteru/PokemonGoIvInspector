//
//  CalculatedHistoryViewController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/17.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit
import CoreData

class CalculatedHistoryViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    static let cellIdentifier = "cellCalcHistory"
    
    let manager = CalcPkmHistoryManager.sharedInstance
    var frc: NSFetchedResultsController?
    let moc = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "History"
        setup()
    }
    
    // MARK: - Setup
    
    func setup() {
        
        self.setupFetchRequestController()
        
        // register nib file
        let nibName = UINib(nibName: "CalcPkmHistoryCell", bundle: nil)
        self.tableView.registerNib(nibName, forCellReuseIdentifier: CalculatedHistoryViewController.cellIdentifier)
    }
    
    func setupFetchRequestController() {
        
        log.info("seting up fetch request controller...")
        
        frc = NSFetchedResultsController(fetchRequest: manager.listHistoryFetchRequest(), managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc!.delegate = self
        
        do {
            try frc!.performFetch()
            
        } catch let error as NSError {
            log.debug("error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            break;
        case .Update:
            if let indexPath = indexPath {
                log.debug("")
                if let cell = tableView.cellForRowAtIndexPath(indexPath) as? CalcPkmHistoryCell {
                    configureCell(cell, atIndexPath: indexPath)
                }
            }
            break;
        case .Move:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }
            
            if let newIndexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([newIndexPath], withRowAnimation: .Fade)
            }
            break;
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = frc!.sections {
            let sectionInfo = sections[section]
            log.debug("rows count: \(sectionInfo.numberOfObjects)")
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CalcPkmHistoryCell {
        
        //log.debug("")
        
        let cell = tableView.dequeueReusableCellWithIdentifier(CalculatedHistoryViewController.cellIdentifier) as! CalcPkmHistoryCell
        configureCell(cell, atIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: CalcPkmHistoryCell, atIndexPath indexPath: NSIndexPath) {
        
        // Fetch Record
        let record = frc!.objectAtIndexPath(indexPath) as! CalcPkmHistory
        //log.debug("record: \(record)")
        
        // Update Cell
        cell.pkmImage.image = UIImage(named: record.image)
        cell.labelName.text = getPokemonName(record.name.lowercaseString.uppercaseFirst)
        cell.labelCp.text = String("CP: \(record.cp)")
        cell.labelHp.text = String("HP: \(record.hp)")
        cell.labelStardust.text = String("Stardust: \(record.stardust)")
        cell.labelPowered.text = String("Powered: \(Bool(record.powered) == false ? "NO" : "YES")")
        
        let str = "Max: \(record.maxPerf) Avg: \(record.avgPerf) Min: \(record.minPerf)"
        cell.labelPerf.text = str
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100.0
    }
    
    // MARK: - Private
    
    func getPokemonName(name: String) -> String {
        
        // special pokemon name: Nidoran♀, Nidoran♂, Mr. Mime, Farfetch'd
        if name == "Nidoran_female"{
            return "Nidoran♀"
        }
        
        if name == "Nidoran_male"{
            return "Nidoran♂"
        }
        
        if name == "Mr_mime"{
            return "Mr. Mime"
        }
        
        if name == "Farfetchd"{
            return "Farfetch'd"
        }
        
        return name
    }
}
