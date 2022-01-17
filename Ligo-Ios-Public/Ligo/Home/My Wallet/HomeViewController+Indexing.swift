//
//  HomeViewController+Indexing.swift
//  Ligo
//
//  Created by Cyrus Illick on 06/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit


extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate{
   
    
    ///Number of alphabetical indexes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    
    ///Index Cell Setup
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "indexCell", for: indexPath) as! IndexCollectionViewCell
        let section = sections[indexPath.row].uppercased()
        cell.nameLabel.text = section
        cell.section = indexPath.row
        cell.delegate = self
        cell.setSelected(bool: selectedIndex == indexPath.row)

        return cell
    }
    
   
    //MARK: -CollectionView Setup
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 15)
    }
    
}


//MARK: - Scroll Handling
extension HomeViewController{
    
///Get current  top most visible  cell's section and select the section on indexes collectionview
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
      
    
    if self.walletTableView.indexPathsForVisibleRows?.count == 0{
        return
    }
      let firstVisibleIndexPath = self.walletTableView.indexPathsForVisibleRows?[0]

      let oldIndex = self.selectedIndex
             self.selectedIndex = firstVisibleIndexPath == nil ? -1 : firstVisibleIndexPath!.section
      if oldIndex != self.selectedIndex{
          self.indexCollectionView.reloadData()
      }
  }

      ///Triggered when Wallet TableView is scrolled
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let scrollViewContentHeight = totalCardsHeight
      
      ///Check if wallet tableview has enough height to be scrolled
      if scrollView.frame.height > scrollViewContentHeight{
          return
      }
      
      ///Slowly show the index collectionview as the user scrolls
      indexCollectionView.alpha = min(1,scrollView.contentOffset.y/headerHeight)

        indexCollectionView.backgroundColor = hexStringToUIColor(hex: me.grad1 ?? "5FB4A2")
        
      ///Change title
      self.navigationItem.title = scrollView.contentOffset.y >= headerHeight  ? "My Wallet" : ""
       
    }
    
    

    
}

extension HomeViewController:IndexProtocol{
    
    //MARK: - Index Selections
    @objc func didPan(toSelectCells panGesture: UIPanGestureRecognizer) {
        
        let location: CGPoint = panGesture.location(in: indexCollectionView)
        if let indexPath = indexCollectionView.indexPathForItem(at: location){
            //print(sections[indexPath.row])
            selected(section: indexPath.row)
        }
    }
    
    //MARK: - Did Select Index
    func selected(section: Int) {
        print(sections[section])
        walletTableView.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        selectedIndex = section
        indexCollectionView.reloadData()
    }
    
    
}

//MARK: -Index CollectionView Setup
extension HomeViewController{
    //MARK: - Index CollectionView Setup
    func initIndexCollectionView(){
        
        
         // let color2 = hexStringToUIColor(hex: me.grad2 ?? "FFFFFF")
         indexCollectionView.backgroundColor = Theme.SoftPurple
         indexCollectionView.layer.cornerRadius = 8
         indexCollectionView.delegate = self
         indexCollectionView.dataSource = self
         indexCollectionView.alpha = 0
         indexCollectionView.isScrollEnabled = false
         addSwipeGestureIndexCV()

     }
     
    
     ///Add swipe gesture to list
     fileprivate func addSwipeGestureIndexCV(){
         let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPan(toSelectCells:)))
         panGesture.delegate = self
         indexCollectionView.addGestureRecognizer(panGesture)
     }
    
    func updateIndexListHeight(){
           let height = totalIndexHeight
           indexHeight.constant = height
           indexCollectionView.layoutIfNeeded()
           
             self.indexCollectionView.contentInset.top = max((self.indexCollectionView.frame.height - self.indexCollectionView.contentSize.height) / 2, 0)
       }
       
}

