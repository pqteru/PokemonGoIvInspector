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
    
    private var myContext = 0
    
    let autocmpView = PkmsAutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain)
    
    // MARK: - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        addObservers()
    }
    
    deinit {
        
        removeObservers()
    }
    
    // MARK: - Setup
    
    func setup() {
        
        setupPkmsAutoCmp()
        
        self.tableView.allowsSelection = false
        
        pokemonSelection.delegate = self
    }
    
    func setupPkmsAutoCmp() {
        
        autocmpView.frame = CGRectOffset(autocmpView.frame, CGRectGetMinX(pokemonSelection.frame), CGRectGetMaxY(pokemonSelection.frame) + 30)
        autocmpView.hidden = true
        self.view.addSubview(autocmpView)
        autocmpView.layoutIfNeeded()
    }
    
    // MARK: - Observer
    
    func addObservers() {
        
        log.debug("")
        
        autocmpView.addObserver(self, forKeyPath: "selectedPkm", options: .New, context: &myContext)
    }
    
    func removeObservers() {
        
        autocmpView.removeObserver(self, forKeyPath: "selectedPkm", context: &myContext)
    }
    
    // MARK: - Observer Handler
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        log.debug("change: \(change)")
        
        if context == &myContext {
            
            if let newValue = change?[NSKeyValueChangeNewKey] {
                log.debug("value changed: \(newValue)")
                
                self.pokemonSelection.text = newValue as? String
            }
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func actionCal(sender: AnyObject) {
        
    }
    
    @IBAction func actionRecal(sender: AnyObject) {
        
    }
    
    // MARK: - UITextFieldDelegate
    
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


