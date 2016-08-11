//
//  PkmsAutoCompleteView.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/10.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

protocol PkmsAutoCompleteDelegate {
    
    func didSearchedByString(string: String) -> Void
    func didSelectedByIndexPath(indexPath: NSIndexPath) -> String
}

class PkmsAutoCompleteView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var autocmpDelegate: PkmsAutoCompleteDelegate?
    var autocmpData = Pokemons
    dynamic var selectedPkm = ""
    
    // MARK: - Initialize
    
    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        let width = getMaxWidthWithOptions(self.autocmpData)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layouts
    
    func getMaxWidthWithOptions(opts: [String]) -> CGFloat {
        
        var longestStr = ""
        for str in opts {
            longestStr = str.length > longestStr.length ? str : longestStr
        }
        
        //TODO: get max width size
        //        let rect = NSString(string: longestStr).boundingRectWithSize(CGSize(width: 120, height: DBL_MAX), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFontSize()], context: nil)
        //
        //        log.debug("max: \(rect.width)")
        
        return 200
    }
    
    // MARK: - Actions
    
    func searchAutocompleteEntriesWithSubstring(subString: String) {
        
        let matches = Pokemons.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercaseString.rangeOfString(subString.lowercaseString)
            return stringMatch != nil ? true : false
        })
        
        log.debug("matches: \(matches)")
        
        self.autocmpData = matches
        self.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.selectedPkm = self.autocmpData[indexPath.row]
        log.debug("self.selectedPkm: \(self.selectedPkm)")
        
        self.hidden = true
    }
}
