//
//  SettingsTableViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 6/17/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import Firebase

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var nameField: UILabel!
    
    var startEmail: String = "xx"
    
    fileprivate lazy var saveButton = {
        UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
    }()
    
    override func viewDidLoad() {
        loadUserData()
        super.viewDidLoad()
        emailField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    /* Creates the save button */
    func initSaveButton() {
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func didEdit(){
        initSaveButton()
    }
    
    
    func loadUserData(){
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            let email = user.email
            startEmail = email ?? "xxx"
            emailField.text = email
            
            //DataGrab2.loadUserData(){
                self.nameField.text = username
            //}
            
        } else {
            print("There was an issue authenticating")
            
        }
        
        Analytics.track(Analytics.Event.openedSettings)
    }
    
    
    @IBAction func deleteAccount(_ sender: UIButton){
        DataGrab.deleteAccount(){ val in
            
            if(val){
                
                CustomAlert.error(presentFrom: self, withTitle: "Account Deleted", andMessage: "Your account has been deleted")
                Analytics.track(Analytics.Event.deactivateAccount)
                
            } else {
                
                CustomAlert.error(presentFrom: self, withTitle: "Delete account failed", andMessage: "Log out and sign back in to delete account")
            }
            
        }
        
    }
    
    
    
    @objc func textFieldDidChange(textField: UITextField) {
        initSaveButton()
    }
    
    @objc func saveAction(){
        saveChange()
    }
    
    @IBAction func saveChanges(_ sender: UIButton){
        print("Changes Saved")
    }
    

    
    func saveChange(){
        if(emailField.text == startEmail){
            print("Did not change email")
            return
        }
        
        
        
        
        let emailVal: String = emailField.text ?? "x"
        
        if(!SettingsTableViewController.isValidEmail(emailVal)){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid email", andMessage: "please give a valid email")
            return
        } else{
            Auth.auth().currentUser?.updateEmail(to: emailVal) { (error) in
                if error != nil {
                    CustomAlert.error(presentFrom: self, withTitle: "Email Update Failed", andMessage: "Log out and log back in to update your email")
                    return
                }
                userEmail = emailVal
                CustomAlert.error(presentFrom: self, withTitle: "Email Updated", andMessage: "Your account has been linked to your new email")
                Analytics.track(Analytics.Event.updateLoginEmail)
                Analytics.track(Analytics.Event.saveSettingsChanges)
                return
            }
        }
    }
    
    
    //MARK: - Checkers
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
    
    private static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    //
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return 0
    //    }
    //
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
    //
    //         Configure the cell...
    //
    //        return cell
    //    }
    //
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
