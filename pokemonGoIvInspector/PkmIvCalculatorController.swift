//
//  PokeIvCalculatorController.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/9.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

enum SelectionType: Int {
    case Pokemons
    case StarDust
}

enum AutoCmpType: Int {
    case Pokemons
}

class PkmIvCalculatorController: UITableViewController, UITextFieldDelegate, AutoCompleteDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pokemonSelection: UITextField!
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var hpTextField: UITextField!
    @IBOutlet weak var poweredSwitch: UISwitch!
    @IBOutlet weak var dustSelection: UITextField!
    var dustPickerView = UIPickerView()
    
    var tempIvs: [Array<Int>]?
    
    private var myContext = 0
    
    let pkmsAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: Pokemons)
    //let dustAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: StarDusts)
    
    // MARK: - Test
    
    func testCase() {
        
        self.pokemonSelection.text = "PSYDUCK"
        self.cpTextField.text = "44"
        self.hpTextField.text = "18"
        self.dustSelection.text = "200"
        self.poweredSwitch.on = false
        
        actionFind(self)
        
        self.pokemonSelection.text = "PSYDUCK"
        self.cpTextField.text = "58"
        self.hpTextField.text = "21"
        self.dustSelection.text = "200"
        self.poweredSwitch.on = true
        
        actionRefind(self)
    }
    
    // MARK: - Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        //addObservers()
        
        // test
        //testCase()
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
    
    // MARK: - Validation
    
    func validate() -> Bool {
        
        let pkmName = self.pokemonSelection.text!
        let cp = self.cpTextField.text!
        let hp = self.hpTextField.text!
        let dust = self.dustSelection.text!
        
        guard pkmName != "" else {
            let alert = UIAlertController(message: "Please enter pokemon filed")
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        guard cp != "" else {
            let alert = UIAlertController(message: "Please enter cp filed")
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        guard hp != "" else {
            let alert = UIAlertController(message: "Please enter hp filed")
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        guard dust != "" else {
            let alert = UIAlertController(message: "Please select stardust filed")
            self.presentViewController(alert, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    // MARK: - Actions
    
    @IBAction func actionFind(sender: AnyObject) {
        
        if !validate() {
            return
        }
        
        let pkmName = self.pokemonSelection.text!.uppercaseString
        
        guard let pkm = readPKMJson(pkmName) as Pokemon! else {
            let alert = UIAlertController(message: "Please select stardust filed")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let cp = Double(self.cpTextField.text!)!
        let hp = Int(self.hpTextField.text!)!
        let dust = Int(self.dustSelection.text!)!
        let isPowered = self.poweredSwitch.on
        
        log.debug("cp: \(cp)")
        log.debug("hp: \(hp)")
        log.debug("dust: \(dust)")
        
        // evaluate each ivs combination
        guard let ivs = PkmIVCalc.instance.evaluate(pkm, cp: cp, hp: hp, dust: dust, isPowered: isPowered) where ivs.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "Cannot find any IV combination")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        log.debug("ivs: \(ivs)")
        
        // saved to temp
        tempIvs = ivs
        
        // get prefections
        let prefs = PkmIVCalc.instance.getPerfections(ivs)
        log.debug("prefs: \(prefs.count)")
        
        let max = prefs.maxElement()!
        let min = prefs.minElement()!
        let avg = PkmIVCalc.instance.getAvgPrefection(prefs)
        
        // calculate max avg min prefection %
        let maxPref = PkmIVCalc.instance.getPrefPercentageStr(max)
        let minPref = PkmIVCalc.instance.getPrefPercentageStr(min)
        let avgPref = PkmIVCalc.instance.getPrefPercentageStr(avg)
        
        let msg = "Max prefection: \(maxPref)\nAvg prefection: \(avgPref)\nMin prefection: \(minPref)"
        showPossibilityAlert(msg)
    }
    
    @IBAction func actionRefind(sender: AnyObject) {
        
        if !validate() {
            return
        }
        
        let pkmName = self.pokemonSelection.text!.uppercaseString
        
        guard let pkm = readPKMJson(pkmName) as Pokemon! else {
            let alert = UIAlertController(message: "Please select stardust filed")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let cp = Double(self.cpTextField.text!)!
        let hp = Int(self.hpTextField.text!)!
        let dust = Int(self.dustSelection.text!)!
        let isPowered = self.poweredSwitch.on
        
        log.debug("cp: \(cp)")
        log.debug("hp: \(hp)")
        log.debug("dust: \(dust)")
        
        // evaluate each ivs combination
        guard let ivs = PkmIVCalc.instance.evaluate(pkm, cp: cp, hp: hp, dust: dust, isPowered: isPowered) where ivs.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "Cannot find any IV combination!")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        log.debug("ivs: \(ivs)")

        guard let temp = tempIvs else {
            let alert = UIAlertController(title: "Error", message: "Please use find first!")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // get intersection possible IVs
        var res = [Array<Int>]()
        for obj in temp {
            for iv in ivs {
                if iv[0] == obj[0] && iv[1] == obj[1] && iv[2] == obj[2] {
                    let possIv = [iv[0], iv[1], iv[2]]
                    res.append(possIv)
                }
            }
        }
        log.debug("res: \(res)")
        
        // get prefections
        let prefs = PkmIVCalc.instance.getPerfections(res)
        log.debug("prefs: \(prefs.count)")
        
        let max = prefs.maxElement()!
        let min = prefs.minElement()!
        let avg = PkmIVCalc.instance.getAvgPrefection(prefs)
        
        // calculate max avg min prefection %
        let maxPref = PkmIVCalc.instance.getPrefPercentageStr(max)
        let minPref = PkmIVCalc.instance.getPrefPercentageStr(min)
        let avgPref = PkmIVCalc.instance.getPrefPercentageStr(avg)
        
        let msg = "Max prefection: \(maxPref)\nAvg prefection: \(avgPref)\nMin prefection: \(minPref)"
        showPossibilityAlert(msg)
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
    
    // MARK: - UIPickerDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return StarDusts.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(StarDusts[row])"
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let txt = "\(StarDusts[row])"
        self.dustSelection.text = txt
        dustSelection.resignFirstResponder()
    }
    
    // MARK: - Private
    
    func readPKMJson(name: String) -> Pokemon? {
        
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //print("jsonData:\(jsonObj)")
                    
                    let obj = jsonObj.filter({ (string, json) -> Bool in
                        return name == json["name"].string
                    })
                    
                    log.debug("obj: \(obj[0].1.description)")
                    
                    return Mapper<Pokemon>().map(obj[0].1.description)!
                    
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return nil
    }
    
    func showPossibilityAlert(message: String?) {
        
        let alert = UIAlertController(title: "Info", message: message, preferredStyle: .Alert)
        let actOk = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        let actDetail = UIAlertAction(title: "Detail", style: .Default) { (alert) in
            // to detail view
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PkmPossibleStatsViewController") {
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        alert.addAction(actOk)
        alert.addAction(actDetail)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
