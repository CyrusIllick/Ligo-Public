//
//  SearchMainController+DataSource.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/1/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

extension SearchMainTableViewController {
    func populateDataSource() {
        DataGrab.userListContacts {contacts in
            self.myCards = self.applyCondition(contacts)
            self.tableView.reloadData()
        }
    }
    
    
    fileprivate func applyCondition(_ contacts:[Contact]) -> [Contact]{
       return contacts.filter { (c) -> Bool in
        
        let alreadyFriends = me.friends?.filter({ (a) -> Bool in
            a == c.username
            }).first != nil
        
        return (c.username != username && (!alreadyFriends))
        }
        
    }

    
    

}


