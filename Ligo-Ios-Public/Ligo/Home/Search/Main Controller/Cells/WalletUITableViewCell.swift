//
//  WalletCell.swift
//  Ligo
//
//  Created by Hassan Abbasi on 03/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit


class WalletUITableViewCell:UITableViewCell{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bg: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    //MARK: - Cell Setup
    fileprivate func setupCell(){
        self.bg.backgroundColor = Theme.AlmostWhite
        self.bg.layer.cornerRadius = 8
        self.selectionStyle = .none
    }
    
  
}
