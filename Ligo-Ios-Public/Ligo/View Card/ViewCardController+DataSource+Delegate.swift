//
//  ViewCardController+DataSource.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/1/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import MessageUI

//MARK: -TableView Delegate and DataSource

extension ViewCardViewController: UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return datasource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource[section].detailTypes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = userDataTableView.dequeueReusableCell(withIdentifier: "UserDataCell", for: indexPath) as! ViewCardTableViewCell
        
        let section = datasource[indexPath.section]
        let detailType = section.detailTypes[indexPath.row]
        let data = section.detailValues[detailType] ?? ""

        cell.setupCell(type: detailType, data: data)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = NSIndexPath(row: indexPath.row, section: indexPath.section)
        let cell = tableView.cellForRow(at: indexPath as IndexPath) as! ViewCardTableViewCell
        
        goToWeb(whatSite: cell.getTypeOfCell(), userCalled: cell.getValueInCell())
    }
    
    
    func goToWeb(whatSite: String, userCalled: String){
        if(whatSite == "Instagram"){
            if let url = URL(string: "https://www.instagram.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Facebook"){
            if let url = URL(string: "https://facebook.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Snapchat"){
            if let url = URL(string: "https://snapchat.com/add/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Twitter"){
            if let url = URL(string: "https://twitter.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "linkedin"){
            if let url = URL(string: "\(userCalled)" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Youtube"){
            if let url = URL(string: "https://youtube.com/user\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Venmo"){
            if let url = URL(string: "https://venmo.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Github"){
            if let url = URL(string: "https://github.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "spotify"){
            if let url = URL(string: "https://open.spotify.com/user/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "tiktok"){
            if let url = URL(string: "https://tiktok.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "apple music"){
            if let url = URL(string: "https://music.apple.com/profile/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "sound cloud"){
            if let url = URL(string: "https://soundcloud.com/\(userCalled)/" ){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Email"){
           if !MFMailComposeViewController.canSendMail() {
               print("Mail services are not available")
               return
           }
          sendEmail(whatEmail: userCalled)
        }
        if(whatSite == "Phone"){
            if let url = URL(string: "tel://\(userCalled)"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        if(whatSite == "Website"){
            if let url = URL(string: "http://\(userCalled)"){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Website 2"){
            if let url = URL(string: "http://\(userCalled)"){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Website 3"){
            if let url = URL(string: "http://\(userCalled)"){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "Website 4"){
            if let url = URL(string: "http://\(userCalled)"){
                UIApplication.shared.open(url)
            }
        }
        if(whatSite == "whatsapp"){
            if let url = URL(string: "tel://\(userCalled)"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        
        
        
    }
    
    
    func sendEmail(whatEmail: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([whatEmail])
            mail.setMessageBody("", isHTML: false)

            present(mail, animated: true)
        } else {
            // show failure alert
            print("Something went wrong sending the email")
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = tableView.frame
        
        let title = UILabel()
        title.frame =  CGRect(x:0, y:20, width:headerFrame.size.width, height:20)
        title.text = self.tableView(tableView, titleForHeaderInSection: section)
        title.textColor = Theme.Rajah
        title.font = Theme.mainFontSemiBoldLarge
        
        let headerView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: headerFrame.size.width, height: headerFrame.size.height))
        headerView.backgroundColor = .white
        headerView.addSubview(title)
        
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func loadDataInto(withPerson info:Identity){
        
        self.setDetailCard(Section: "About Me", detail: "name", value: info.firstName + " " + info.lastName)
        ///self.setDetailCard(Section: "About Me", detail: "last name", value: info.lastName)

        
        self.setDetailCard(Section: "About Me", detail: "bio", value: info.bio)
        self.setDetailCard(Section: "About Me", detail: "work", value: info.work)

        
        
        self.setDetailCard(Section: "Contact Me", detail: "phone", value: info.phone)
        self.setDetailCard(Section: "Contact Me", detail: "email", value: info.email)
        self.setDetailCard(Section: "Contact Me", detail: "whatsapp", value: info.whatsapp)
        
        
       // self.setDetailCard(Section: "Contact Me", detail: "website", value: info.website)
        
        for (index,value) in info.websites.enumerated(){
            self.setDetailCard(Section: "Contact Me", detail: index == 0 ? "website" : "website \(index)", value: value)

            
        }

        
        self.setDetailCard(Section: "My Socials", detail: "facebook", value: info.facebook)
        self.setDetailCard(Section: "My Socials", detail: "instagram", value: info.instagram)
        self.setDetailCard(Section: "My Socials", detail: "snapchat", value: info.snapchat)
        self.setDetailCard(Section: "My Socials", detail: "twitter", value: info.twitter)
        self.setDetailCard(Section: "My Socials", detail: "tiktok", value: info.tiktok)
        
        
        self.setDetailCard(Section: "My Socials", detail: "linkedin", value: info.linkedin)
        self.setDetailCard(Section: "My Socials", detail: "github", value: info.github)
        self.setDetailCard(Section: "My Socials", detail: "apple music", value: info.applemusic)
        self.setDetailCard(Section: "My Socials", detail: "spotify", value: info.spotify)
        self.setDetailCard(Section: "My Socials", detail: "youtube", value: info.youtube)
        self.setDetailCard(Section: "My Socials", detail: "venmo", value: info.venmo)
        self.setDetailCard(Section: "My Socials", detail: "sound cloud", value: info.soundcloud)
        
    }
    
    func populateUserData() {
        guard let contact = contact else {return}
        let username = contact.username
        DataGrab.getFriendCard(username: username) { (info) in
           
            self.person = info
            self.loadDataInto(withPerson: info)
            
            self.userDataTableView.reloadData()
            
            let color1: UIColor = self.hexStringToUIColor(hex: info.grad1 ?? "FFFFFF")
            let color2: UIColor = self.hexStringToUIColor(hex: info.grad2 ?? "FFFFFF")
            self.initMyCardBackground(color1: color1, color2: color2)
            self.loadingIndicator(show:false)
            self.myCardBackground.isHidden = false

            if(info.isVerified ?? false){
                self.updateVerifiedImage()
            }
            

        }
        
    }

    
}



//MARK: - TableView DataSource Handlers
extension ViewCardViewController{
    fileprivate func setDetailCard(Section key:String, detail type:String, value:String?){
        if value == nil || value == ""{return}
        
        
        let cardSection = datasource.filter {
            $0.name == key
        }.first ?? CardSection(name: key)
        
        cardSection.addDetail(type: type, value: value ?? "")

        
        if !datasource.contains(cardSection){
            datasource.append(cardSection)
        }
        
    
    }
        
        

}
