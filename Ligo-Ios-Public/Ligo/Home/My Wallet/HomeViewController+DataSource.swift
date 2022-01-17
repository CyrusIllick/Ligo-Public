//
//  HomeViewController+DataSource.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/1/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    ///Number of alphabetical sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    ///Number of cards in each alphabetical section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardsSections[sections[section]]?.count ?? 0
    }
    
    ///Setup Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletUITableViewCell
        
        if let section = cardsSections[sections[indexPath.section]]{
            let contactName = section[indexPath.row].firstname + " " + section[indexPath.row].lastname
            cell.titleLabel.text = contactName
            
        }
        return cell
    }
    
    
    ///On Select Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        if let card = cardsSections[section]?[indexPath.row]{
            
            DataGrab.userExists(who: card.username) { (val) in
                if(val) {
                    if (self.navigationController?.topViewController != self)  { return}
                    self.performSegue(withIdentifier: "ViewCardSegue", sender: card)
                } else {
                    CustomAlert.error(presentFrom: self, withTitle: "This user no longer exists", andMessage: "This user doesnt exist anymore.")
                }
            }
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - TableView Setup
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return walletCellHeight
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude
    }
    
    
    // MARK: - Editing
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    
    ///Populates the data of the wallet
    func populateDataSource() {
        resetDatasource()
    
        
        DataGrab.getFriends { (people) in
            me.friends = people
            self.showEmptyWalletsLabel(people.count == 0)
            
            
            
            DataGrab.usernamesToNames(usernames: people) { (contacts) in
                         
                for i in contacts{
                    self.addToDataSource(card:i)

                }
                        self.didLoadWallet()
                         self.reloadTable()
                     }
        }
    }
}


//MARK: -TableView Helper Functions
extension HomeViewController{
    
    ///Add Card to Alphabetical Section Dictionary
    fileprivate func addToDataSource(card:Contact){
        let name = card.firstname.trimmingCharacters(in: .whitespacesAndNewlines)
        let sectionName = String(name.first ?? "#").uppercased()
        
        ///If section already exists
        if var section = cardsSections[sectionName]{
            section.append(card)
            ///This makes sure that the 
            cardsSections[sectionName] = section.sorted(by: { $0.firstname.lowercased() < $1.firstname.lowercased() })
        }
            ///Create new section
        else{
            let section = [card]
            cardsSections[sectionName] = section
            sections.append(sectionName)
            
        }
        sections = sections.sorted()
        
        
    }
    
    
    
    fileprivate func reloadTable(){
        
        self.walletTableView.reloadData()
        self.indexCollectionView.reloadData()
        self.updateIndexListHeight()
        
    }
    
    func resetDatasource(){
        self.cardsSections = [String:[Contact]]()
        self.sections = [String]()
        self.reloadTable()
    }
    
}
