//
//  PkmStatsHeader.swift
//  pokemonGoIvInspector
//
//  Created by davidchen on 2016/8/15.
//  Copyright © 2016年 pqteru. All rights reserved.
//

import UIKit

class PkmStatsHeader: UIView {

    @IBOutlet weak var labelLv: UILabel!
    @IBOutlet weak var labelAtk: UILabel!
    @IBOutlet weak var labelDef: UILabel!
    @IBOutlet weak var labelSta: UILabel!
    @IBOutlet weak var labelPerf: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        log.debug("")
        
        self.backgroundColor = UIColor.blackColor()
        self.labelLv.textColor = UIColor.whiteColor()
        self.labelAtk.textColor = UIColor.whiteColor()
        self.labelDef.textColor = UIColor.whiteColor()
        self.labelSta.textColor = UIColor.whiteColor()
        self.labelPerf.textColor = UIColor.whiteColor()
    }
}
