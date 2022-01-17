//
//  EditCardTableViewCell.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/27/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit

protocol EditCardCellDelegate {
    func detailUpdated(_ cell: EditCardTableViewCell)
}

class EditCardTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    var delegate: EditCardCellDelegate?
    var section:String!
    var detailType:String!
    var websiteCount = -1
    
    var didRemoveItem:((Int) -> Void)?
    
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var icon: UIImageView!
    // MARK: - IBOutlets
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBAction func removeItem(_ sender: Any) {
        if websiteCount == -1 {return}
        didRemoveItem?(websiteCount)
    }
    
    func setupCell(type:String,data:String){
        textField.placeholder = ""
        textField.text = data
        detailLabel.text = type.capitalized
        icon.image = UIImage(systemName: "phone")
        
        textField.isEnabled =  !(type.capitalized == "Username")
        detailLabel.alpha =  type.capitalized == "Username" ?  0.6 : 1
        textField.alpha =  type.capitalized == "Username" ?  0.6 : 1

        removeButton.isHidden = true

        if type.contains("website"){
            websiteCount = Int(type.replacingOccurrences(of: "website", with: "").trimmingCharacters(in: .whitespaces)) ?? -1
            removeButton.isHidden = type.replacingOccurrences(of: "website", with: "").count == 0
        }
        
        if type.contains("website"){
            icon.image = UIImage(systemName: "globe")
            
            return
        }
        
        switch type.capitalized{
        case "Username":
            icon.image = UIImage(systemName: "person")
            
        case "First Name":
            icon.image = UIImage(systemName: "person.fill")
            
        case "Last Name":
            icon.image = UIImage(systemName: "person.fill")
            
        case "Facebook":
            icon.image = #imageLiteral(resourceName: "facebook")
            textField.placeholder = "username"
            
        case "Snapchat":
            icon.image = #imageLiteral(resourceName: "snapchat")
            textField.placeholder = "username"
        case "Twitter":
            icon.image = #imageLiteral(resourceName: "twitter")
            textField.placeholder = "username"
        case "Instagram":
            icon.image = #imageLiteral(resourceName: "instagram")
            textField.placeholder = "username"
            
        case "Linkedin":
            icon.image = #imageLiteral(resourceName: "linkedin")
            textField.placeholder = "Copy paste your LinkedIn URL"
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
            textField.placeholder = "Tell us about yourself!"
            
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
        //textField.placeholder = "This is optional"
        case "Website 3":
            icon.image = UIImage(systemName: "globe")
        //textField.placeholder = "This is optional"
        case "Website 4":
            icon.image = UIImage(systemName: "globe")
            // textField.placeholder = "This is optional"
            
        case "Whatsapp":
            icon.image = UIImage(systemName: "globe")
            
        default:break
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        textField.borderStyle = .none
        textField.addLeftRightImage(pos: .left, im: nil, mode: .always, tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),width: 10,leftPadding: 0,sizeOfIconDivider: 0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func textFieldDidChange() {
        delegate?.detailUpdated(self)
    }
    
    
    
}
