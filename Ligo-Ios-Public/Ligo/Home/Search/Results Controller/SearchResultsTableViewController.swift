//
//  SearchResultsTableViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/28/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

class SearchResultsTableViewController: UITableViewController {
    
    let tableViewCellIdentifier = "ContactCell"
    
    // MARK: - Properties
    var filteredContacts: [Contact] = []
    
    // TODO: - Temporary — Find a way to properly display this later (Probably make this variable an IBOutlet)
    var resultsLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredContacts.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! SearchResultsTableViewCell
        let contact = filteredContacts[indexPath.row]
        
        cell.contact = contact
        cell.nameLabel.text = contact.firstname + " " + contact.lastname
        cell.delegate = self
        
        return cell
    }
}
