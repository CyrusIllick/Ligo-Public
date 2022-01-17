//
//  SearchMainTableViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/27/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit



class SearchMainTableViewController: UITableViewController {
    
    let tableViewCellIdentifier = "MyCardCell"
    let resultsVCIdentifier = "SearchResultsTableViewController"
    
    // MARK: - Properties
    
    var newContactAdded = false
    var delegate: ViewStateListener?
    var myCards: [Contact] = []
    var searchController: UISearchController!
    var didAdd = false
    
    private var resultsTableController: SearchResultsTableViewController!
    
    var restoredState = SearchControllerRestorableState()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        didAdd = false
        resultsTableController =
            self.storyboard?.instantiateViewController(withIdentifier: resultsVCIdentifier) as? SearchResultsTableViewController
        // This view controller is interested in table view row selections.
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.
        
        //searchController.searchBar.scopeButtonTitles = ["All", "My Wallet", "Others"]

        // Place the search bar in the navigation bar.
        
        //let headerView = UIView(frame:CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))
       
        searchController.searchBar.frame = CGRect(x: 8, y: 0, width: searchController.searchBar.frame.width - 16, height: searchController.searchBar.frame.height)

        
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = Theme.Rajah
        
        definesPresentationContext = false
        
        populateDataSource()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
//        if newContactAdded{
            delegate?.popUpViewDismissed()
            
//        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - UITableViewDataSource

extension SearchMainTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return myCards.count
        }
        return 0
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath) as! SearchResultsTableViewCell
        let contactName = myCards[indexPath.row].firstname + " " + myCards[indexPath.row].lastname
        cell.nameLabel.text = contactName
        cell.contact = myCards[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UISearchBarDelegate

extension SearchMainTableViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateSearchResults(for: searchController)
    }
}

// MARK: - UISearchControllerDelegate

// Use these delegate functions for additional control over the search controller.

extension SearchMainTableViewController: UISearchControllerDelegate {
    
    func presentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //Swift.debugPrint("UISearchControllerDelegate invoked method: \(#function).")
    }
    
}


extension SearchMainTableViewController: SearchResultsCellDelegate {
    func cardRequested(forContact contact: Contact, linked: Bool) {
        if linked {
            CustomAlert.autoDismiss(presentFrom: self, withTitle: "You are already linked with \(contact.firstname + " " + contact.lastname)", andMessage: "")
        } else {
            CustomAlert.autoDismiss(presentFrom: self, withTitle: "Linked with \(contact.firstname + " " + contact.lastname)!", andMessage: "")
            newContactAdded = true
            Analytics.track(Analytics.Event.newContact)
        }
    }
    
    
}
