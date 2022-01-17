//
//  HomeViewController+ViewStateListener.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/2/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

extension HomeViewController: ViewStateListener {
    func popUpViewDismissed() {
         populateDataSource()
    }
}
