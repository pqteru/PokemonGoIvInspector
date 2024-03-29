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
import Firebase

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
    
    // ad banner
    var bannerView = GADBannerView(adSize: kGADAdSizeBanner)
    
    var tempPkmStatsAry: [PokemonStats]?
    
    private var myContext = 0
    
    let pkmsAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: Pokemons)
    //let dustAutoCmpView = AutoCompleteView(frame: CGRectMake(0, 0, 200, 120), style: .Plain, options: StarDusts)
    
    let manager = CalcPkmHistoryManager.sharedInstance
    
    var toolbar: UIToolbar {
        get {
            let tb = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
            tb.barStyle = UIBarStyle.Default
            tb.items = [
                UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
                UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PkmIvCalculatorController.actionDone))]
            tb.sizeToFit()
            return tb
        }
    }
    
    // MARK: - Test
    
    func testUtils() {
        
        let now = DateUtils.sharedInstance.currentDate()
        log.debug("now: \(now)")
    }
    
    func fixPokemonName() {
        
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //print("jsonData:\(jsonObj)")
                    
                    //log.debug("jsonObj: \(jsonObj)")
                    
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
    }
    
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
        //fixPokemonName()
        //testCase()
        //testUtils()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // show ad
        bannerView.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // hide ad
        bannerView.hidden = true
    }
    
    deinit {
        
        //removeObservers()
    }
    
    // MARK: - Setup
    
    func setup() {
        
        self.title = "IV Calculator"
        self.tableView.allowsSelection = false
        
//        setupTableView()
        setupTextField()
        setupToolBar()
        setupAdBanner()
    }
    
//    func setupTableView() {
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(actionDone))
//        self.tableView.addGestureRecognizer(tap)
//    }
    
    func setupToolBar() {
        
        self.cpTextField.inputAccessoryView = self.toolbar
        self.hpTextField.inputAccessoryView = self.toolbar
    }
    
    func setupTextField() {
        
        setupPkmsAutoCmp()
        setupStardustField()
        
        self.cpTextField.delegate = self
        self.cpTextField.tag = 99
        
        self.hpTextField.delegate = self
        self.hpTextField.tag = 99
    }
    
    func setupPkmsAutoCmp() {
        
        pkmsAutoCmpView.frame = CGRectOffset(pkmsAutoCmpView.frame,
                                             CGRectGetMinX(pokemonSelection.frame),
                                             CGRectGetMaxY(pokemonSelection.frame))
        pkmsAutoCmpView.hidden = true
        pkmsAutoCmpView.tag = AutoCmpType.Pokemons.rawValue
        pkmsAutoCmpView.autoCmpDelegate = self
        self.tableView.addSubview(pkmsAutoCmpView)
        
        pokemonSelection.tag = SelectionType.Pokemons.rawValue
        pokemonSelection.delegate = self
        
        pokemonSelection.tag = SelectionType.Pokemons.rawValue
        pokemonSelection.delegate = self
    }
    
    func setupStardustField() {
        
        dustPickerView.frame = CGRectMake(0, self.view.bounds.height - 320, self.view.bounds.width, 320)
        dustPickerView.delegate = self
        dustPickerView.dataSource = self
        
        dustSelection.inputView = dustPickerView
        dustSelection.tag = SelectionType.StarDust.rawValue
        dustSelection.delegate = self
    }
    
    func setupAdBanner() {
        
        print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.frame = CGRectOffset(bannerView.frame, 0,
                                        CGRectGetHeight(self.view.frame) - CGRectGetHeight(bannerView.frame))
        self.navigationController?.view.addSubview(bannerView)
        
        #if DEBUG
        // test only
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        #else
        bannerView.adUnitID = "ca-app-pub-5608297010244358/1164195027"
        #endif
    
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
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
        
        guard let pkm = readPKMJson(pkmName) as Pokemon? else {
            let alert = UIAlertController(message: "Cannot find any pokemon!")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        log.debug("pkm: \(pkm)")
        
        for move in pkm.moves1! {
            log.debug("move.name: \(move.name)")
        }
        
        let cp = Double(self.cpTextField.text!)!
        let hp = Int(self.hpTextField.text!)!
        let dust = Int(self.dustSelection.text!)!
        let isPowered = self.poweredSwitch.on
        
        log.debug("cp: \(cp)")
        log.debug("hp: \(hp)")
        log.debug("dust: \(dust)")
        
        // evaluate each ivs combination
        guard let pkmStatsAry = PkmIVCalc.instance.evaluate(pkm, cp: cp, hp: hp, dust: dust, isPowered: isPowered) where pkmStatsAry.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "Cannot find any IV combination")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        log.debug("pkmStatsAry count: \(pkmStatsAry.count)")
        
        // saved to temp for refine to do intersect
        tempPkmStatsAry = pkmStatsAry
        
        // sort
        let sortedAry = pkmStatsAry.sort(>)
        let perfs = getPerfections(sortedAry)
        let maxPerf = perfs["maxPerf"] as String!
        let minPerf = perfs["minPerf"] as String!
        let avgPerf = perfs["avgPerf"] as String!
        
        // save to core data
        saveToHistory(pkm.name!, img: (pkm.image ?? "") as String, cp: Int(cp), hp: Int(hp), stardust: Int(dust), powered: Int(isPowered), maxPerf: maxPerf, avgPerf: avgPerf, minPerf: minPerf)
        
//        let move = (pkm.moves1?.first)! as PokemonMove
//        let moveMsg = move.name
        
        // show alert
        let msg = "Max perfection: \(maxPerf)\nAvg perfection: \(avgPerf)\nMin perfection: \(minPerf))"
        showPossibilityAlert(sortedAry, message: msg)
    }
    
    @IBAction func actionRefind(sender: AnyObject) {
        
        if !validate() {
            return
        }
        
        let pkmName = self.pokemonSelection.text!.uppercaseString
        
        guard let pkm = readPKMJson(pkmName) as Pokemon! else {
            let alert = UIAlertController(message: "Cannot find any pokemon!")
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
        guard let pkmStatsAry = PkmIVCalc.instance.evaluate(pkm, cp: cp, hp: hp, dust: dust, isPowered: isPowered) where pkmStatsAry.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "Cannot find any IV combination")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        log.debug("pkmStatsAry count: \(pkmStatsAry.count)")
        
        guard let temp = tempPkmStatsAry else {
            let alert = UIAlertController(title: "Error", message: "Please use find first!")
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        // get intersection possible IVs
        var res = [PokemonStats]()
        for obj in temp {
            for stats in pkmStatsAry {
                if stats.atk == obj.atk && stats.def == obj.def && stats.sta == obj.sta {
                    res.append(stats)
                }
            }
        }
        log.debug("res: \(res)")
        
        // sort
        let sortedAry = res.sort(>)
        let perfs = getPerfections(sortedAry)
        let maxPerf = perfs["maxPerf"] as String!
        let minPerf = perfs["minPerf"] as String!
        let avgPerf = perfs["avgPerf"] as String!
        
        // save to core data
        saveToHistory(pkm.name!, img: (pkm.image ?? "") as String, cp: Int(cp), hp: Int(hp), stardust: Int(dust), powered: Int(isPowered), maxPerf: maxPerf, avgPerf: avgPerf, minPerf: minPerf)
        
        // show alert
        let msg = "Max perfection: \(maxPerf)\nAvg perfection: \(avgPerf)\nMin perfection: \(minPerf)"
        showPossibilityAlert(sortedAry, message: msg)
    }
    
    func actionDone() {
        
        log.debug("")
        
        self.pokemonSelection.resignFirstResponder()
        self.cpTextField.resignFirstResponder()
        self.hpTextField.resignFirstResponder()
        self.dustSelection.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " {
            return false
        }
        
        log.debug("range: \(range)")
        
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        pokemonSelection.resignFirstResponder()
        return false
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
        log.debug("txt: \(txt)")
        
        self.dustSelection.text = txt
        dustSelection.resignFirstResponder()
    }
    
    // MARK: - Private
    
    func readPKMJson(name: String) -> Pokemon? {
        
        log.debug("name: \(name)")
        
        if let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //print("jsonData:\(jsonObj)")
                    
                    let obj = jsonObj.filter({ (string, json) -> Bool in
                        
                        let pkmName = json["name"].string
                        log.debug("pkmName: \(pkmName)")
                        
                        // special case: Nidoran♀, Nidoran♂, Mr. Mime, Farfetch'd
                        if name == "NIDORAN♀" && pkmName == "NIDORAN_FEMALE"{
                            return true
                        }
                        
                        if name == "NIDORAN♂" && pkmName == "NIDORAN_MALE"{
                            return true
                        }
                        
                        if name == "MR. MIME" && pkmName == "MR_MIME"{
                            return true
                        }
                        
                        if name == "FARFETCH'D" && pkmName == "FARFETCHD"{
                            return true
                        }
                        
                        return name == pkmName
                    })
                    
                    if obj.count > 0 {
                        log.debug("obj: \(obj[0].1.description)")
                        return Mapper<Pokemon>().map(obj[0].1.description)!
                    } else {
                        return nil
                    }
                    
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
    
    func getPerfections(data: [PokemonStats]) -> [String: String] {
        
        let max = (data.first! as PokemonStats).perfection
        let min = (data.last! as PokemonStats).perfection
        let avg = PkmIVCalc.instance.getAvgPrefection(data)
        
        // calculate max avg min prefection %
        let maxPerf = PkmIVCalc.instance.getPrefPercentageStr(max)
        let minPerf = PkmIVCalc.instance.getPrefPercentageStr(min)
        let avgPerf = PkmIVCalc.instance.getPrefPercentageStr(avg)
        
        return ["maxPerf": maxPerf, "minPerf": minPerf, "avgPerf": avgPerf]
    }
    
    func showPossibilityAlert(data: [PokemonStats], message: String) {
        
        let alert = UIAlertController(title: "perfection Info", message: message, preferredStyle: .Alert)
        let actOk = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        let actDetail = UIAlertAction(title: "Detail", style: .Default) { (alert) in
            // to detail view
            if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PkmPossibleStatsViewController") as? PkmPossibleStatsViewController {
                vc.dataSource = data
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        alert.addAction(actOk)
        alert.addAction(actDetail)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - Save
    
    func saveToHistory(name: String, img: String, cp: Int, hp: Int, stardust: Int, powered: Int, maxPerf: String, avgPerf: String, minPerf: String) {
        
        let param = [
            "name": name,
            "image": img,
            "cp": cp,
            "hp": hp,
            "stardust": stardust,
            "powered": powered,
            "maxPerf": maxPerf,
            "avgPerf": avgPerf,
            "minPerf": minPerf
        ]
        
        manager.insertCalcPkmHistoryByParam(param, completionHandler: nil)
    }
}
