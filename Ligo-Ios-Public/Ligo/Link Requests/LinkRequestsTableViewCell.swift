//
//  LinkRequestsTableViewCell.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/2/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

protocol LinkRequestsCellDelegate {
    func respondedToRequest(_ cell: LinkRequestsTableViewCell)
}

class LinkRequestsTableViewCell: UITableViewCell {
    
    var contact: Contact!
    var delegate: LinkRequestsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - IBActions
    
    @IBAction func acceptButtonPressed() {
        DataGrab.acceptFriend(who: contact.username) {
            self.delegate?.respondedToRequest(self)
        }
    }
    
    @IBAction func declineButtonPressed() {
        DataGrab.declineFriend(who: contact.username) {
            self.delegate?.respondedToRequest(self)
        }
    }
    

}
