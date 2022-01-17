//
//  SearchResultsTableViewCell.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/2/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

protocol SearchResultsCellDelegate {
    func cardRequested(forContact contact: Contact, linked: Bool)
}

class SearchResultsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    var contact: Contact!
    var delegate: SearchResultsCellDelegate?
    
    @IBOutlet weak var bg: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var addBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.bg.backgroundColor = Theme.AlmostWhite
              self.bg.layer.cornerRadius = 8
              self.selectionStyle = .none
        addBtn.layer.cornerRadius = addBtn.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    ///Code to exchange cards between two people, it depends if the person is public or private
    @IBAction func exchangeButtonPressed() {
        let username = contact.username
        
        DataGrab.isConnectedTo(who: username) { (val) in
            if(val){
                self.delegate?.cardRequested(forContact: self.contact, linked: true)
            } else {
                DataGrab.exchangeCard(who: username) {}
                self.delegate?.cardRequested(forContact: self.contact, linked: false)
            }
        }
        
        Analytics.track(Analytics.Event.exhangeCard)
    }
    
}
