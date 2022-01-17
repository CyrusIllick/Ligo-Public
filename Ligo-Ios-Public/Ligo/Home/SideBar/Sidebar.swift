//
//  SidebarNavigationController.swift
//  Ligo
//
//  Created by Cyrus Illick on 02/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit
import SideMenu
import EasyTipView

class Sidebar:BaseViewController{


    //MARK: - Properties
    @IBOutlet weak var editButton: UIStackView!

    @IBOutlet weak var Settings: UIStackView!
    
    @IBOutlet weak var viewWebCard: UIStackView!

    @IBOutlet weak var viewQRCode: UIStackView!

    //@IBOutlet weak var settingsButton: UIStackView!


    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        editButton.makeButton(withAction: #selector(openEditCard), andTarget: self)
        viewWebCard.makeButton(withAction: #selector(viewOnWeb), andTarget: self)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showMyTips()
    }


    //MARK: - View Setup
    fileprivate func setupNavigationBar(){
       self.hideNavigationShadow()

       //Disable Status Bar Hidden feature of SideBar
       let sideNav = (self.navigationController as! UISideMenuNavigationController)
       sideNav.sideMenuManager.menuFadeStatusBar = false
       sideNav.sideMenuManager.menuPresentMode = .menuSlideIn

       //Add background blur to the SideBar
       sideNav.sideMenuManager.menuBlurEffectStyle = .prominent
    }


    //MARK: - Actions
    @objc fileprivate func openEditCard(){
        performSegue(withIdentifier: "EditCardSegue", sender: nil)
        Analytics.track(Analytics.Event.openEditCard)
    }

    @objc func viewOnWeb(){
        if let url = URL(string: "https://ligo.best/user/\(username)" ){
           UIApplication.shared.open(url)
            Analytics.track(Analytics.Event.viewedOnWeb)
       }
    }

    @objc func viewQR(){
        if let url = URL(string: "https://qrfree.kaywa.com/?l=1&s=8&d=https%3A%2F%2Fligo.best%2F\(username)" ){
           UIApplication.shared.open(url)
            Analytics.track(Analytics.Event.viewQR)
       }
    }


    @IBAction func signOut(_ sender: Any) {
        print("Signing out")
       DataGrab.signOut { (val) in
           if(val){
              let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignUpViewController")
            vc.modalPresentationStyle = .fullScreen
            self.view.window?.rootViewController?.dismiss(animated: false, completion: nil)
            Analytics.track(Analytics.Event.signOut)


           } else{
               CustomAlert.error(presentFrom: self, withTitle: "Could not sign out", andMessage: "There was an error signing out")
           }
       }
    }



    @IBAction func closeSidebar(_ sender: Any) {
          dismiss(animated: true, completion: nil)
    }


   fileprivate func showMyTips(){
    if self.isFirstLaunch(screen: "SideBar"){
    self.showTip(tip: "Edit your card here!", onView: self.editButton, color: hexStringToUIColor(hex: me.grad1 ?? "FFFFFF"))
    }

    }
}
