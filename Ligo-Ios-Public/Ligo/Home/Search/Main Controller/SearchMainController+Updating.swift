//
//  SearchMainController+Updating.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/28/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

extension SearchMainTableViewController: UISearchResultsUpdating {
    private func findMatches(searchString: String) -> NSCompoundPredicate {
        
        var searchItemsPredicate = [NSPredicate]()
        
        let searchStringExpression = NSExpression(forConstantValue: searchString)
        
        // Contact name matching
        let firstNameExpression = NSExpression(forKeyPath: Contact.ExpressionKeys.firstname.rawValue)
        let lastNameExpression = NSExpression(forKeyPath: Contact.ExpressionKeys.lastname.rawValue)

        let firstNameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: firstNameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: [.caseInsensitive, .diacriticInsensitive])
        
          let lastNameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: lastNameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: [.caseInsensitive, .diacriticInsensitive])
        
        searchItemsPredicate.append(firstNameSearchComparisonPredicate)
        searchItemsPredicate.append(lastNameSearchComparisonPredicate)

        // Contact username matching
        let usernameExpression = NSExpression(forKeyPath: Contact.ExpressionKeys.username.rawValue)
        let usernameSearchComparisonPredicate = NSComparisonPredicate(leftExpression: usernameExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: [.caseInsensitive, .diacriticInsensitive])
        searchItemsPredicate.append(usernameSearchComparisonPredicate)
        
        // Handle the scoping
        var finalCompoundPredicate: NSCompoundPredicate!
        let selectedScopeButtonIndex = searchController.searchBar.selectedScopeButtonIndex
        if selectedScopeButtonIndex > 0 {
            // TODO: - Code to narrow search further here
        } else {
            finalCompoundPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
        }
        return finalCompoundPredicate
    }
    
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchResults = myCards
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            findMatches(searchString: searchString)
        }
        
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        if let resultsController = searchController.searchResultsController as? SearchResultsTableViewController {
            resultsController.filteredContacts = filteredResults
            resultsController.tableView.reloadData()
            
            resultsController.resultsLabel.text = resultsController.filteredContacts.isEmpty ?
            NSLocalizedString("NoItemsFoundTitle", comment: "") :
            String(format: NSLocalizedString("Items found: %ld", comment: ""),
                   resultsController.filteredContacts.count)
        }
    }
}
