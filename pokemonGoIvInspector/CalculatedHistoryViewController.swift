//
//  CalculatedHistoryViewController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/17.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

class CalculatedHistoryViewController: UITableViewController {

    let cellCalcHisotryId = "cellCalcHistory"
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellCalcHisotryId)
        cell?.textLabel?.text = "test"
        return cell!
    }
}
