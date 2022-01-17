//
//  ViewCardTableViewCell.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/1/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

class ViewCardTableViewCell: UITableViewCell {
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var userDataLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var copyIcon: UIImageView!
    
    
    
    func setupCell(type:String,data:String){
        userDataLabel.text = data.capitalized
        detailLabel.text = type.capitalized
        icon.image = UIImage(systemName: "phone")
        
    
        
        if type.contains("website"){
            icon.image = UIImage(systemName: "globe")
            
            return
        }
        
        switch type.capitalized{
        case "Facebook":
            icon.image = #imageLiteral(resourceName: "facebook")
            
        case "Snapchat":
            icon.image = #imageLiteral(resourceName: "snapchat")
            
        case "Twitter":
            icon.image = #imageLiteral(resourceName: "twitter")
        case "Instagram":
            icon.image = #imageLiteral(resourceName: "instagram")
            
        case "Linkedin":
            icon.image = #imageLiteral(resourceName: "linkedin")
            
        case "Youtube":
            icon.image = #imageLiteral(resourceName: "youtube")
        case "Venmo":
            icon.image = #imageLiteral(resourceName: "venmo")
        case "Github":
            icon.image = #imageLiteral(resourceName: "github")
        case "Spotify":
            icon.image = #imageLiteral(resourceName: "spotify")
            
            
        case "Tiktok":
            icon.image = #imageLiteral(resourceName: "tiktok")
            
            
        case "Apple Music":
            icon.image = #imageLiteral(resourceName: "applemusic")
            
        case "Sound Cloud":
            icon.image = #imageLiteral(resourceName: "soundcloud")
            
        case "Bio":
            icon.image = UIImage(systemName: "person.fill")
            
            
            
        case "Name":
            icon.image = UIImage(systemName: "person.fill")
            
        case "Email":
            icon.image = UIImage(systemName: "envelope.fill")
        case "Phone":
            icon.image = UIImage(systemName: "phone.fill")
        case "Work":
            icon.image = UIImage(systemName: "briefcase.fill")
            
        case "Website":
            icon.image = UIImage(systemName: "globe")
            
        case "Website 2":
            icon.image = UIImage(systemName: "globe")
        case "Website 3":
            icon.image = UIImage(systemName: "globe")
        case "Website 4":
            icon.image = UIImage(systemName: "globe")
        case "Whatsapp":
            icon.image = UIImage(systemName: "phone.fill")
            
        default:break
        }
        
        copyIcon.isHidden = type == "Bio"
        copyIcon.makeButton(withAction: #selector(copyField), andTarget: self)
        
        
    }
    
    func getValueInCell() -> String{
        return userDataLabel.text ?? ""
    }
    
    func getTypeOfCell() -> String {
        return detailLabel.text ?? ""
    }
    
    @objc fileprivate func copyField(){
        UIPasteboard.general.string = userDataLabel.text
        CustomAlert.showToast(message: "Copied!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
