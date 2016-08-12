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

class PokeIvCalculatorController: UITableViewController, UITextFieldDelegate, AutoCompleteDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pokemonSelection: UITextField!
    @IBOutlet weak var cpTextField: UITextField!
    @IBOutlet weak var hpTextField: UITextField!
    @IBOutlet weak var poweredSwitch: UISwitch!
    @IBOutlet weak var dustSelection: UITextField!
    var dustPickerView = UIPickerView()
    
    private var myContext = 0
    
    let pkmsAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: Pokemons)
    //let dustAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: StarDusts)
    
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
        
        // calculate pokemon perfection
        // CP = MAX(10, FLOOR(Stamina0.5 * Attack * Def0.5 / 10))
        
        //CP值計算方式：CP = floor((Base Attack + Attack IV) * (Base Defense + Defense IV)^0.5 * (Base HP + HP IV)^0.5 * (PowerUpValue^2) / 10 )
        
        let pkmName = self.pokemonSelection.text!.uppercaseString
        
        //let cp = Int(self.cpTextField.text!)
        //let hp = Int(self.hpTextField.text!)
        //let dust = Int(self.dustSelection.text!)
        //let isPowered = self.poweredSwitch.on
        
        //let ivs = evaluate(pkm, cp: cp!, hp: hp!, dust: dust!)
        
        let pkm = readPKMJson(pkmName)
        log.debug("pkm: \(pkm?.name)")
    }
    
    func evaluate(pkm: String, cp: Int, hp: Int, dust: Int) -> Int {
        
        //var baseStamia = hp * 2
        //var baseAttack =
        
        return 0
    }
    
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
        
        return StarDusts[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let txt = StarDusts[row] as String!
        self.dustSelection.text = txt
        dustSelection.resignFirstResponder()
    }
}


