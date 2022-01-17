//
//  SearchResultsController+CellDelegate.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/2/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

extension SearchResultsTableViewController: SearchResultsCellDelegate {
    func cardRequested(forContact contact: Contact, linked: Bool) {
        if linked {
            CustomAlert.autoDismiss(presentFrom: self, withTitle: "You are already linked with \(contact.firstname + " " + contact.lastname )", andMessage: "")
        } else {
            CustomAlert.autoDismiss(presentFrom: self, withTitle: "Linked with \(contact.firstname + " " + contact.lastname)!", andMessage: "")
        }
        
    }

}
