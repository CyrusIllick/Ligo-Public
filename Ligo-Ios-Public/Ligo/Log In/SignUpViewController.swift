//
//  SignUpViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/29/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit


//MARK: -Signup Handling
extension LoginSignUpViewController{
    
    ///Creates a new user and puts their information from the text fields into the database
    func signUserUp() {
        var email = emailField.text?.trimmingCharacters(in: .whitespaces) ?? ""
        email = email.lowercased()
        let name = usernameField.text ?? ""
        let password = passwordField.text ?? ""
        let firstname = firstNameField.text?.capitalizingFirstLetter() ?? ""
        let lastname = lastNameField.text?.capitalizingFirstLetter() ?? ""
        
        if(firstname.replacingOccurrences(of: " ", with: "") == ""){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid First Name", andMessage: "please give a valid first name")
            return
        }
        
        if(lastname.replacingOccurrences(of: " ", with: "") == ""){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid Last Name", andMessage: "please give a valid last name")
            return
        }
        
        if(LoginSignUpViewController.isValidEmail(email) == false){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid email", andMessage: "please give a valid email")
            return
        }
        if(password.count < 6){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid Password", andMessage: "Password must be at least 6 characters")
            return
        }
        if(LoginSignUpViewController.isAlphanumeric(name) == false){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid username", andMessage: "Name must have no spaces and include only certain characters")
            return
        }

        
        loadingView = LoadingView.showLoading(view: view)

        DataGrab.userExists(who: name) { (val) in

             DispatchQueue.main.async {
            if(val){
                self.loadingView?.hideLoading()

                
                CustomAlert.error(presentFrom: self, withTitle: "Username Taken", andMessage: "Pick another username, this one is taken")
                return
            }else{
                
                DataGrab.createUser(email: email, password: password, newUsername: name,firstName: firstname,lastName: lastname) { (error) in
                    
                    self.loadingView?.hideLoading()

                    
                    if(error == nil){
                        //DataGrab2.createCard(name: name) {
                            self.performSegue(withIdentifier: "HomeSegue", sender: nil)
                       // }
                    }else{
                        CustomAlert.error(presentFrom: self, withTitle: "An error occurred", andMessage: error!)
                        
                        print("Something went wrong in signing up")
                        return
                    }
                }
                }
            }
        }
    }
    
    
    //MARK: - Chekers
    
    private static func isAlphanumeric(_ input: String) -> Bool {
        guard input != "" else {return false}
        let alphanumericSet = CharacterSet.alphanumerics
    
        let strippedInput = input.rangeOfCharacter(from: alphanumericSet.inverted)
        return strippedInput == nil
    }
    
    private static func lengthWithinRange(_ input: String, min: Int, max: Int) -> Bool {
            let inputLength = input.count
            return (inputLength >= min && inputLength <= max)
    }
    
     static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
