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
    var dataSource: [PokemonStats]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nibCell = UINib(nibName: "PkmStatsCell", bundle: nil)
        self.tableView.registerNib(nibCell, forCellReuseIdentifier: cellId)
        
        // test
        testCase()
    }
    
    // MARK: - Test
    
    func testCase() {
        
        //dataSource = [[17, 1, 2, 3, 60], [18, 4, 12, 15, 45]]
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        return PkmStatsHeader.fromNib()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataSource?.count {
            return count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PkmStatsCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId) as! PkmStatsCell
        let pkmStats = dataSource![indexPath.row]
        configureCell(cell, pokemonStats: pkmStats)
        return cell
    }
    
    func configureCell(cell: PkmStatsCell, pokemonStats: PokemonStats) {
        cell.labelLv.text = String(pokemonStats.lv)
        cell.labelAtk.text = String(pokemonStats.atk)
        cell.labelDef.text = String(pokemonStats.def)
        cell.labelSta.text = String(pokemonStats.sta)
        
        // perfection percentage
        cell.labelPerf.text = PkmIVCalc.instance.getPrefPercentageStr(pokemonStats.perfection)
    }
}
