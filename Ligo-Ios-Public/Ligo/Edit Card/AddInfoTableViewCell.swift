//
//  AddInfoTableViewCe;;.swift
//  Ligo
//
//  Created by Cyrus Illick on 31/10/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit

class AddInfoTableViewCell:UITableViewCell{
    @IBOutlet weak var btn:UIButton!
    var didAddSite:(() -> Void)?
    
    @IBAction func addSite(){
        didAddSite?()
    }
    
    func disable( _ disable:Bool){
        btn.alpha = disable ? 0.5 : 1
        btn.isUserInteractionEnabled = !disable
    }
    
}
