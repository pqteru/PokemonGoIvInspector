//
//  PkmsAutoCompleteView.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/10.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

protocol PkmsAutoCompleteDelegate {
    
    func didSearchByString(string: String) -> Void
    func didSelectByIndexPath(indexPath: NSIndexPath) -> String
}

class PkmsAutoCompleteView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var autocmpDelegate: PkmsAutoCompleteDelegate?
    var autocmpData = Pokemons
    
    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func searchAutocompleteEntriesWithSubstring(subString: String) {
        
        let matches = Pokemons.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercaseString.rangeOfString(subString.lowercaseString)
            return stringMatch != nil ? true : false
        })
        
        log.debug("matches: \(matches)")
        
        self.autocmpData = matches
        self.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        log.debug("autocmpData.count: \(autocmpData.count)")
        
        return autocmpData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        log.debug("text: \(autocmpData[indexPath.row])")
        
        cell?.textLabel?.text = autocmpData[indexPath.row]
        
        return cell!
    }
}
