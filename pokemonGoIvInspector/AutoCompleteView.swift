//
//  PkmsAutoCompleteView.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/10.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

protocol AutoCompleteDelegate {
    
    func autoCmpView(autoCmpView: AutoCompleteView, selectedOpt: AnyObject)
}

class AutoCompleteView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var autoCmpDelegate: AutoCompleteDelegate?
    var source: [String]?
    var options: [String] = []

    // MARK: - Initialize
    
    required override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.delegate = self
        self.dataSource = self
        
        let width = getMaxWidthWithOptions(options)
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.height)
    }
    
    convenience init(frame: CGRect, style: UITableViewStyle, options: [String]) {
        self.init(frame: frame, style: style)
        
        self.source = options
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
    
    func searchWithSubstring(subString: String) {
        
        let matches = self.source!.filter({(item: String) -> Bool in
            
            let stringMatch = item.lowercaseString.rangeOfString(subString.lowercaseString)
            return stringMatch != nil ? true : false
        })
        
        log.debug("matches: \(matches)")
        
        self.options = matches
        self.reloadData()
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        log.debug("autocmpData.count: \(options.count)")
        
        return options.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: cellId)
        }
        
        if let txt = options[indexPath.row] as String! {
            log.debug("txt: \(txt)")
            cell?.textLabel?.text = txt
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedOpt = options[indexPath.row]
        log.debug("selectedOpt: \(selectedOpt)")
        
        self.autoCmpDelegate?.autoCmpView(self, selectedOpt: selectedOpt)
        self.hidden = true
    }
}
