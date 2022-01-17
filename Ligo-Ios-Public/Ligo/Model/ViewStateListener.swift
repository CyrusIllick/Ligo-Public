//
//  ViewDismissedListener.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/2/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation

protocol ViewStateListener {
    func popUpViewDismissed()
    func viewNeedsRefresh()
}

extension ViewStateListener {
    func popUpViewDismissed() {}
    func viewNeedsRefresh() {}
}
