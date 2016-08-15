//
//  PkmIVCalc.swift
//  pokemonGoIvInspector
//
//  Created by David Chen on 2016/8/13.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class PkmIVCalc {
    
    static let instance = PkmIVCalc()
    
    // Pkm 與 trainer 相差 lv 最高值
    let maxLvGap = 1.5
    
    // MARK: - Formula
    /*
     SpAtk -特殊攻擊 Spd – ?攻速?
     SpDef -特殊防禦
     Base Attack = 2 * ((Atk * SpAtk)^0.5 + Spd^0.5))
     Base Defense = 2 * ((Def * SpDef)^0.5 + Spd^0.5))
     Base Stamina = 2 * HP
     */
    
    func evaluate(pkm: Pokemon, cp: Double, hp: Int, dust: Int, isPowered: Bool) -> [Array<Int>]? {
        
        // calculate pokemon perfection
        // CP = floor((Base Attack + Attack IV) * (Base Defense + Defense IV)^0.5 * (Base HP + HP IV)^0.5 * (PowerUpValue^2) / 10 )
        
        log.debug("pkm.stats: \(pkm.stats)")
        
        let baseStamia = (pkm.stats["stamina"] as! NSNumber).integerValue
        let baseAttack = (pkm.stats["attack"] as! NSNumber).integerValue
        let baseDefense = (pkm.stats["defense"] as! NSNumber).integerValue
        
        // calculate hp first
        guard let lvs = getPkmLevel(dust, isPowered: isPowered) where lvs.count > 0 else {
            return nil
        }
        
        var ary = [Array<Int>]()
        
        for pkmLv in lvs {
            let lv = (pkmLv.level! + 1) / 2
            log.debug("lv: \(lv)")
            
            let TCpM = getTotalCpM(pkmLv)
            log.debug("TCpM: \(TCpM)")
            
            // HP = (Base Stam + Stam IV) * Lvl(CPScalar)
            guard let staIvs = getPossibleStaIvs(baseStamia, totalCpM: TCpM, hp: hp) else {
                return nil
            }
            log.debug("staIvs: \(staIvs)")
            
            for atkIv in 0...15 {
                let a = Double(baseAttack + atkIv)
                
                for defIv in 0...15 {
                    let b = pow(Double(baseDefense + defIv), 0.5)
                    
                    for staIv in staIvs {
                        let c = pow(Double(baseStamia + staIv), 0.5)
                        
                        let estCp = floor(a * b * c * pow(TCpM, 2) / 10)
                        
                        if cp == estCp {
                            //log.debug("estCp: \(estCp)")
                            
                            let cmb = [atkIv, defIv, staIv]
                            //print("cmb: \(cmb)")
                            ary.append(cmb)
                        }
                    }
                }
            }
        }
        
        return ary
    }
    
    // MARK: - Private
    
    func getPossibleStaIvs(baseSta: Int, totalCpM: Double, hp: Int) -> [Int]? {
        
        var ary = [Int]()
        var estSta = Int(floor(Double(hp) / totalCpM - Double(baseSta)))
        
        // (baseStamina + IndSta) * TCpM >= hp
        while Int((Double(baseSta) + Double(estSta)) * totalCpM) < hp+1 {
            let c = Int((Double(baseSta) + Double(estSta)) * totalCpM)
            log.debug("c: \(c)")
            log.debug("estSta: \(estSta)")
            
            if c >= hp {
                ary.append(estSta)
            }
            estSta += 1
        }
        log.debug("ary: \(ary)")
        
        return ary
    }
    
    func getPkmLevel(dust: Int, isPowered: Bool) -> [PokemonLevel]? {
        
        var ary = readPKMLevelsJson(dust)
        if ary?.count > 0 && isPowered == false {
            // 移除 .5 lv
            ary?.removeAtIndex(1)
            ary?.removeLast()
        }
        return ary
    }
    
    func getPrefections(ary: [Array<Int>]) -> [Double] {
        
        var a = [Double]()
        for comb in ary {
            let pref = calcPrefection(comb[0], def: comb[1], sta: comb[2])
            a.append(pref)
        }
        
        return a
    }
    
    func calcPrefection(atk: Int, def: Int, sta: Int) -> Double {
        
        //current
        let current = atk + def + sta
        
        // max
        let total = getMaxAtk() + getMaxDef() + getMaxSta();
        
        let pref = Double(current)/Double(total)
        //log.debug("pref: \(pref))")
        
        return pref.roundToPlaces(2)
    }
    
    func getTotalCpM(pkmLv: PokemonLevel) -> Double {
        
        // TotalCpMultiplier = CpMultiplier + AdditionalMultiplier (usually is 0)
        
        return pkmLv.cpScalar! + 0
    }
    
    func getAvgPrefection(ary: [Double]) -> Double {
        
        var total = 0.0
        for pref in ary {
            total += pref
        }
        log.debug("total: \(total)")
        
        let avg = total / Double(ary.count)
        log.debug("ary.count: \(ary.count)")
        
        return avg.roundToPlaces(2)
    }
    
    func getMaxAtk() -> Int {
        return 15
    }
    
    func getMaxDef() -> Int {
        return 15
    }
    
    func getMaxSta() -> Int {
        return 15
    }
    
    func getPrefPercentageStr(pref: Double) -> String {
        
        return "\(pref*100)%"
    }
    
    // MARK: - Read JSON
    
    func readPKMLevelsJson(dust: Int) -> [PokemonLevel]? {
        
        if let path = NSBundle.mainBundle().pathForResource("levels", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //print("jsonData:\(jsonObj)")
                    
                    let objs = jsonObj.filter({ (string, json) -> Bool in
                        return dust == json["dust"].int
                    })
                    
                    //log.debug("objs: \(objs[0].1.dictionary)")
                    
                    var pkmlvs = [PokemonLevel]()
                    for obj in objs {
                        let lv = Mapper<PokemonLevel>().map(obj.1.description)!
                        pkmlvs.append(lv)
                    }
                    
                    return pkmlvs
                    
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
    
    func readLevelToCpmJson(pkmLv: PokemonLevel) -> Double? {
        
        if let path = NSBundle.mainBundle().pathForResource("level-to-cpm", ofType: "json") {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let jsonObj = JSON(data: data)
                if jsonObj != JSON.null {
                    //print("jsonData: \(jsonObj)")
                    
                    let v = jsonObj.dictionary?.filter({ (ele) -> Bool in
                        //log.debug("ele: \(ele.0)")
                        //log.debug("ele: \(ele.1)")
                        return Int(ele.0) == pkmLv.level!
                    })
                    log.debug("v: \(v?.first?.1)")
                    
                    if let tcpm = (v?.first?.1.doubleValue)! as Double? {
                        return tcpm
                    }
                    return nil
                    
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
}