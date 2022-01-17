//
//  IndexCollectionViewCell.swift
//  Ligo
//
//  Created by Cyrus Illick on 06/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit


protocol IndexProtocol:AnyObject {
    func selected(section:Int)
}

class IndexCollectionViewCell:UICollectionViewCell{
    
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate:IndexProtocol?
    
    var section:Int!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.makeButton(withAction: #selector(didSelectItem), andTarget: self)
    }
    
    func setSelected(bool:Bool){
        self.nameLabel.font = bool ? Theme.mainFontBoldLarge : Theme.mainFontBoldMedium
        
        self.nameLabel.textColor = bool ? .white : Theme.AlmostWhite

    }
    
   @objc fileprivate func didSelectItem(){
    delegate?.selected(section: section)

    }
    

    
}

