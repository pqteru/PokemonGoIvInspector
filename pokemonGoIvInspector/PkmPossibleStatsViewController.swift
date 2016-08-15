//
//  PkmPossibleStatsViewController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/15.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

class PkmPossibleStatsViewController: UITableViewController {
    
    let cellId = "cellIV"
    var ivs: [Array<Int>]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: "PkmStatsCell", bundle: nil)
        self.tableView.registerNib(nibCell, forCellReuseIdentifier: cellId)
        
        // test
        testCase()
    }
    
    // MARK: - Test
    
    func testCase() {
        
        ivs = [[17, 1, 2, 3, 60], [18, 4, 12, 15, 45]]
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return PkmStatsHeader.fromNib()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = ivs?.count {
            return count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PkmStatsCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! PkmStatsCell
        let iv = ivs![indexPath.row]
        configureCell(cell, ary: iv)
        return cell
    }
    
    func configureCell(cell: PkmStatsCell, ary: [Int]) {
        cell.labelLv.text = String(ary[0])
        cell.labelAtk.text = String(ary[1])
        cell.labelDef.text = String(ary[2])
        cell.labelSta.text = String(ary[3])
        cell.labelPerf.text = String(ary[4])
    }
}
