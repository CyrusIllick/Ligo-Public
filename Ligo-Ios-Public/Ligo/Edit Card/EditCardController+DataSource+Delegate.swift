//
//  EditCardController+DataSource.swift
//  Ligo
//
//  Created by Cyrus Illick on 04/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Tableview delegate
extension EditCardViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].detailTypes.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = datasource[indexPath.section]
        let detailType = section.detailTypes[indexPath.row]
        let data = section.detailValues[detailType] ?? ""
        
        if detailType == "AddWebsite"{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddInfo", for: indexPath) as! AddInfoTableViewCell
            cell.disable(EditCardViewController.websiteCount == 19)
            cell.didAddSite = {[weak self] in
                
                self?.addSite()
            }
            return cell

        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! EditCardTableViewCell

        cell.section = section.name
        cell.detailType = detailType
        cell.delegate = self
        cell.setupCell(type: detailType, data: data)
        
        cell.didRemoveItem = {[weak self] websiteCount in
            self?.removeWebsite(websiteCount)
            
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let section = datasource[indexPath.section]
        let detailType = section.detailTypes[indexPath.row]
        
        if detailType == "AddWebsite"{
            return 40
        }
        
        return 75
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let title = UILabel()
        title.frame =  CGRect(x:0, y:0, width:headerFrame.size.width, height:20)
        title.text = self.tableView(tableView, titleForHeaderInSection: section)
        title.textColor = Theme.Rajah
        title.font = Theme.mainFontSemiBoldLarge
        
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = .white
        headerView.addSubview(title)
        
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    
}



//MARK: - Detail Edit Delegate
extension EditCardViewController: EditCardCellDelegate {
    func detailUpdated(_ cell: EditCardTableViewCell) {
        //activeField = cell.textField
        initSaveButton()
        let section = cell.section
        let detailType = cell.detailType ?? ""
        
        let newValue = cell.textField.text
        if newValue != nil {
            
            if let card = datasource.filter({ (a) -> Bool in
                a.name == section
            }).first{
                card.detailValues[detailType] = newValue
                
            }
        }
    }
}
