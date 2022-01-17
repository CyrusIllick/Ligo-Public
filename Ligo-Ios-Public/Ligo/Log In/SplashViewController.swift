//
//  SplashViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 05/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SplashViewController:UIViewController{
    
    @IBOutlet weak var logoIcon: UIImageView!
    
    @IBOutlet weak var textLabels: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLabels.alpha = 0
        logoIcon.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        
      
        logoIcon.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 3/2)
        
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5, delay: 1.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.logoIcon.transform = .identity
            self.logoIcon.alpha = 1
            self.textLabels.alpha = 1
        }) { (_) in
            if Auth.auth().currentUser != nil {
                self.performSegue(withIdentifier: "HomeSegue", sender: nil)
            }else{
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
                
            }
        }
    }
}
