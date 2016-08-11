//
//  PokeIvCalculatorController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/9.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

enum SelectionType: Int {
    case Pokemons
    case StarDust
}

enum AutoCmpType: Int {
    case Pokemons
}

class PokeIvCalculatorController: UITableViewController, UITextFieldDelegate, AutoCompleteDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pokemonSelection: UITextField!
    @IBOutlet weak var dustSelection: UITextField!
    var dustPickerView = UIPickerView()
    
    private var myContext = 0
    
    let pkmsAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: Pokemons)
    let dustAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: StarDusts)
    
    // MARK: - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //addObservers()
    }
    
    deinit {
        
        //removeObservers()
    }
    
    // MARK: - Setup
    
    func setup() {
        
        self.tableView.allowsSelection = false
        
        setupPkmsAutoCmp()
        pokemonSelection.tag = SelectionType.Pokemons.rawValue
        pokemonSelection.delegate = self
        
        setupStarDustField()
        
        //dustSelection.tag = SelectionType.StarDust.rawValue
        //dustSelection.delegate = self
    }
    
    func setupPkmsAutoCmp() {
        
        pkmsAutoCmpView.frame = CGRectOffset(pkmsAutoCmpView.frame,
                                             CGRectGetMinX(pokemonSelection.frame),
                                             CGRectGetMaxY(pokemonSelection.frame) + 30)
        pkmsAutoCmpView.hidden = true
        pkmsAutoCmpView.tag = AutoCmpType.Pokemons.rawValue
        pkmsAutoCmpView.autoCmpDelegate = self
        self.view.addSubview(pkmsAutoCmpView)
    }
    
    func setupStarDustField() {
        
        dustPickerView.frame = CGRectMake(0, self.view.bounds.height - 320, self.view.bounds.width, 320)
        dustPickerView.delegate = self
        dustPickerView.dataSource = self
        
        dustSelection.inputView = dustPickerView
        dustSelection.tag = SelectionType.StarDust.rawValue
        dustSelection.delegate = self
        
        /*
         dustAutoCmpView.frame = CGRectOffset(dustAutoCmpView.frame,
         CGRectGetMinX(dustSelection.frame),
         CGRectGetMaxY(dustSelection.frame) + 30)
         dustAutoCmpView.hidden = true
         dustAutoCmpView.tag = AutoCmpType.StarDust.rawValue
         dustAutoCmpView.autoCmpDelegate = self
         self.view.addSubview(dustAutoCmpView)
         */
    }
    
    //    // MARK: - Observer
    //
    //    func addObservers() {
    //
    //        log.debug("")
    //
    //        pkmsAutoCmpView.addObserver(self, forKeyPath: "selectedPkm", options: .New, context: &myContext)
    //    }
    //
    //    func removeObservers() {
    //
    //        pkmsAutoCmpView.removeObserver(self, forKeyPath: "selectedPkm", context: &myContext)
    //    }
    //
    //    // MARK: - Observer Handler
    //
    //    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
    //
    //        log.debug("change: \(change)")
    //
    //        if context == &myContext {
    //
    //            if let newValue = change?[NSKeyValueChangeNewKey] {
    //                log.debug("value changed: \(newValue)")
    //
    //                self.pokemonSelection.text = newValue as? String
    //            }
    //        } else {
    //            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
    //        }
    //    }
    
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
        
        let userEnteredString = textField.text
        let newString = (userEnteredString! as NSString).stringByReplacingCharactersInRange(range, withString: string) as String
        
        log.debug("newString: \(newString)")
        
        switch textField.tag {
        case SelectionType.Pokemons.rawValue:
            pkmsAutoCmpView.hidden = false
            pkmsAutoCmpView.searchWithSubstring(newString)
            break
        case SelectionType.StarDust.rawValue:
            return false
        default:
            break
        }
        
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        pkmsAutoCmpView.hidden = true
    }
    
    //    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    //
    //        log.debug("")
    //
    //        if textField.tag == SelectionType.StarDust.rawValue {
    //            return false
    //        }
    //        return true;
    //    }
    
    // MARK: - AutoCompleteDelegate
    
    func autoCmpView(autoCmpView: AutoCompleteView, selectedOpt: AnyObject) {
        
        log.debug("selectedOpt: \(selectedOpt)")
        
        switch autoCmpView.tag {
        case AutoCmpType.Pokemons.rawValue:
            self.pokemonSelection.text = String(selectedOpt)
            break
        default:
            break
        }
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
    
    // MARK: - UIPickerDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return StarDusts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return StarDusts[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let txt = StarDusts[row] as String!
        self.dustSelection.text = txt
        dustSelection.resignFirstResponder()
    }
}


