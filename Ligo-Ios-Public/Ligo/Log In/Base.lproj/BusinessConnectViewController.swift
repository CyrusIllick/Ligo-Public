//
//  BusinessConnectViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 7/4/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

class BusinessConnectViewController: UIViewController {

    
    @IBOutlet weak var disconnectButton: UIButton!

    @IBOutlet weak var IdField: UITextField!
    
    @IBOutlet weak var connectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(me.identity != "default"){
            IdField.text = me.identity
            disconnectButton.isHidden = false
        }

        connectButton.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func ConnectToBusiness(_ sender: UIButton){
        
        let BizID: String = IdField.text ?? "default"
        if(BizID.count == 0){
            return
        }
        DataGrab.partnerExistsCheck(who: BizID){ exists in
            if(exists){
                DataGrab.updateField(type: "identity", to: BizID){
                    me.identity = BizID
                    print("successful business ID found")
                    
                    DataGrab.getPartnerInfo(who: BizID){ val in
                        me.grad1 = val["grad1"]
                        me.grad2 = val["grad2"]
                        
                        
                        DataGrab.updateField(type: "grad1", to: me.grad1 ?? "ffffff") {
                            
                            DataGrab.updateField(type: "grad2", to: me.grad2 ?? "ffffff") {
                                CustomAlert.error(presentFrom: self, withTitle: "Business Added ", andMessage: "Your card is now a connected member with \(BizID)")
                                self.dismiss(animated: true, completion: nil)
                                Analytics.track(Analytics.Event.connectedToBusiness)
                            }
                        }
                    }
                }
                
            } else {
                
                CustomAlert.error(presentFrom: self, withTitle: "Business Does Not Exist ", andMessage: "The Partner that you tried entering is not connected with Ligo")
                
            }
        }
    }
    
    @IBAction func DisconnectBusiness(_ sender: UIButton){
        let BizID: String = IdField.text ?? "default"
        DataGrab.updateField(type: "identity", to: "default"){
            
             CustomAlert.error(presentFrom: self, withTitle: "Business Removed ", andMessage: "Your card is no longer connected with \(BizID)")
            me.identity = "default"
            self.disconnectButton.isHidden = true
            self.IdField.text = ""
            self.dismiss(animated: true, completion: nil)

        }
        
    }
    
    ///Used to get colors from values taken from database
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
