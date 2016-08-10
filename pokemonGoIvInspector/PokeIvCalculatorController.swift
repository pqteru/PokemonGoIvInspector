//
//  PokeIvCalculatorController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/9.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

class PokeIvCalculatorController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var pokemonSelection: UITextField!
    
    let autocmpView = PkmsAutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        autocmpView.frame = CGRectOffset(autocmpView.frame, CGRectGetMinX(pokemonSelection.frame), CGRectGetMaxY(pokemonSelection.frame) + 30)
        autocmpView.hidden = true
        self.view.addSubview(autocmpView)
        autocmpView.layoutIfNeeded()
        
        pokemonSelection.delegate = self
    }
    
    @IBAction func actionCal(sender: AnyObject) {
        
    }
    
    @IBAction func actionRecal(sender: AnyObject) {
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        self.autocmpView.hidden = false
        
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).stringByReplacingCharactersInRange(range, withString: string) as String
        
        log.debug("newString: \(newString)")
        self.autocmpView.searchAutocompleteEntriesWithSubstring(newString)
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        self.autocmpView.hidden = true
    }
    
    //    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //
    //        if let count = self.autocmpData?.count where count > 0 {
    //            return count
    //        }
    //
    //        return 0
    //    }
    //
    //    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //
    //        let cellId = "cell"
    //        let cell = tableView.dequeueReusableCellWithIdentifier(cellId)
    //
    //        if let data = self.autocmpData {
    //            cell?.textLabel?.text = data[indexPath.row]
    //        }
    //
    //        return cell!
    //    }
}

extension String {
    func rangeFromNSRange(nsRange : NSRange) -> Range<String.Index>? {
        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
        if let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) {
            return from ..< to
        }
        return nil
    }
}
