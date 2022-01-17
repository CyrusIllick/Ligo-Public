//
//  PasswordTableViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 6/18/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import Firebase

class PasswordTableViewController: UITableViewController {
    
    
    @IBOutlet weak var oldPasswordField: UITextField!
    
    @IBOutlet weak var newPasswordField: UITextField!
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    
    
    
    
    @IBAction func submitNewPassword(_ sender: UIButton){
        
        let user = Auth.auth().currentUser
        if let user = user {
            
            let emailVal: String = user.email ?? "mess up"
            
            let passwordText: String = newPasswordField.text ?? "X"
            
            if(!checkPassword(password: passwordText)){
                CustomAlert.error(presentFrom: self, withTitle: "New Password Error", andMessage: "Password must be at least 6 characters")
                oldPasswordField.text = ""
                newPasswordField.text = ""
                return
            }
            
            Auth.auth().signIn(withEmail: emailVal, password: oldPasswordField.text!) { [weak self] authResult, error in
                
                if let error = error {
                    print("there was an error \(error.localizedDescription)")
                    CustomAlert.error(presentFrom: self!, withTitle: "Did not authenticate", andMessage: "There was an error with your old password")
                    return
                }
                
                DataGrab.updatePassword(password: self!.newPasswordField.text!){ val in
                    if(val){
                        
                        print("Password, updated success")
                        
                        CustomAlert.error(presentFrom: self!, withTitle: "Password Updated", andMessage: "Sucessfull Password Update")
                        
                        self!.oldPasswordField.text = ""
                        self!.newPasswordField.text = ""
                        
                        Analytics.track(Analytics.Event.updatePassword)
                        return
                        
                    } else {
                        
                        CustomAlert.error(presentFrom: self!, withTitle: "Password did not update", andMessage: "Make sure that you filled out the form correctly")
                        self!.oldPasswordField.text = ""
                        self!.newPasswordField.text = ""
                        return
                    }
                }
                
                
            }
            
            
        } else {
            print("There was an issue with initial auth")
        }
        
        
        
    }
    
    
    
    func checkPassword(password: String) -> Bool{
        if(password.count < 6){
            CustomAlert.error(presentFrom: self, withTitle: "Invalid Password", andMessage: "Password must be at least 6 characters")
            return false
        } else {
            return true;
        }
    }
    

    
    // MARK: - Table view data source
    
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
