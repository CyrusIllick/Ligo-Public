//
//  LinkRequestsTableViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/2/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

class LinkRequestsTableViewController: UITableViewController {
    
    let tableViewCellIdentifier = "LinkRequestCell"
    
    var dataSource: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateDataSource()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! LinkRequestsTableViewCell
        
        cell.textLabel?.text = dataSource[indexPath.row].firstname + " " + dataSource[indexPath.row].lastname
        cell.contact = dataSource[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    
    func populateDataSource() {
        DataGrab.getRequests { (people) in
            DataGrab.usernamesToNames(usernames: people) { (contacts) in
                self.dataSource = contacts
                self.tableView.reloadData()
            }
            
        }
        
        
    }
}
