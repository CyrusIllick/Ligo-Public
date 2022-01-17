//
//  LogInViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/24/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import Firebase


//MARK: -Login Handling
extension LoginSignUpViewController{
    func logUserIn(withEmail email: String, password: String) {
        loadingView = LoadingView.showLoading(view: view)

        DataGrab.signIn(email: email, password: password, completion: { worked in
            
            DispatchQueue.main.async {
                
            if(worked){
             //   DataGrab.loadUserData(){
                    self.loadingView?.hideLoading()

                    self.performSegue(withIdentifier: "HomeSegue", sender: nil)
              //  }
            } else {
                self.loadingView?.hideLoading()

                CustomAlert.error(presentFrom: self, withTitle: "Invalid Credentials", andMessage: "Your username or password was incorrect. Please try again.")
                return
            }
                
            }
        })
    }

    
    // MARK: Debugging
    
    func debuggingLogin() {
        emailField.text = "cyrus@illick.edu"
        passwordField.text = "qqqqqq"
    }
}
