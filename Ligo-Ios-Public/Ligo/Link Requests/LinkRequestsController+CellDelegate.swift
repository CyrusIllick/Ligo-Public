//
//  LinkRequestsController+CellDelegate.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/3/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

extension LinkRequestsTableViewController: LinkRequestsCellDelegate {
    func respondedToRequest(_ cell: LinkRequestsTableViewCell) {
        let indexPath = tableView.indexPath(for: cell)
        guard let index = indexPath?.row else {return}
        dataSource.remove(at: index)
        tableView.reloadData()
    }
}
