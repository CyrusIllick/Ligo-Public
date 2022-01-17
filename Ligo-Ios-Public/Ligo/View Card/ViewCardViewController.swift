//
//  ViewCardViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 4/1/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import ContactsUI


class ViewCardViewController: UIViewController, CNContactViewControllerDelegate {
    
    // MARK: - Properties
    var contact: Contact?
    
    var person: Identity?
    
    var datasource = [CardSection]()
    
    // MARK: - IBOutlets
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userDataTableView: UITableView!
    @IBOutlet weak var myCardBackground: GradientView!
    @IBOutlet weak var bottomBlurView: UIView!
    @IBOutlet weak var verified: UIImageView!
   
    @IBOutlet weak var partnerImage: UIImageView!
    @IBOutlet weak var profileImage: ProfileView!
    
    fileprivate lazy var loadingIndicator:UIActivityIndicatorView = {
        let i = UIActivityIndicatorView()
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    let store = CNContactStore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = contact?.firstname
        
        self.populateUserData()
        self.userDataTableView.dataSource = self
        self.userDataTableView.delegate = self
        
        self.navigationController?.navigationBar.tintColor = .black
        self.setupProfileImage()
        self.getImage()
        self.initLoadingIndicator()
        self.myCardBackground.isHidden = true
        self.loadingIndicator(show:true)
        
        if contact?.username == me.username{
            deleteButton.isHidden = true
        }
        
    }
    
    
    @IBAction func deleteFriend(_ sender: Any) {
       let alert = AlertBox.showAlert(view: view, text: "Are you sure you want to delete this connection?", title: "Delete Connection")
        alert.addAction(action: nil, text: "No", dismissAction: true)
        alert.addAction(action: Action(action: {
            
            DataGrab.deleteFriend(who: self.person?.username ?? "") {
                  alert.hideAlert()
                HomeViewController.shouldRefresh = true
                self.navigationController?.popViewController(animated: true)
            }
            
            
        }), text: "Yes")
    }
    
  
    fileprivate func initLoadingIndicator(){
        view.addSubview(loadingIndicator)
        loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
     func loadingIndicator(show:Bool){
        if show{
            loadingIndicator.startAnimating()
            
        }else{
            loadingIndicator.stopAnimating()
        }
        
        loadingIndicator.isHidden = !show
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.setupTableView()
        
        if(person?.identity != "default"){
          
                self.getPartnerName(who:person?.identity ?? "" )
                
            
        }
        
    }
    
    func getPartnerName(who: String){
        loadPartnerInfo(withPartnerName: who)
    }
    
    
    
    fileprivate func setupTableView(){
        userDataTableView.tableFooterView = UIView(frame:CGRect(x: 0, y: 0, width: userDataTableView.frame.width, height: 80))
        addBlurBackground()
    }
    
    fileprivate func addBlurBackground(){
        let gradient = CAGradientLayer()
        gradient.frame = bottomBlurView.bounds
        gradient.colors = [ UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradient.locations = [0, 0.8]
        bottomBlurView.layer.insertSublayer(gradient, at: 0)
    }
    
    
    @IBAction func shareFriendCard(_ sender: Any) {
        let someText:String = "\(String(describing: contact!.firstname))'s ligo card"
        let objectsToShare:URL = URL(string: "https://ligo.best/user/" + contact!.username)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addTocContactsButton(_ sender: Any) {
        
        print("")
        
        
        let authStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        if(authStatus == .authorized){
            self.addToContacts()
        } else {
            self.requestAccess { (val) in
                if(val){
                    self.addToContacts()
                }
                else {
                    print("did not let me add to contacts")
                }
            }
        }
    }
    
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                DispatchQueue.main.async {
                    if granted {
                        completionHandler(true)
                    } else {
                        DispatchQueue.main.async {
                            self.showSettingsAlert(completionHandler)
                        }
                    }
                    
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Go to Settings to grant access.", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                completionHandler(false)
                UIApplication.shared.open(settings)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
    
    
    
    func initMyCardBackground(color1: UIColor, color2: UIColor) {
        myCardBackground.setColors(toStartColor: color1, andEndColor: color2)
        myCardBackground.layer.shadowOpacity = 0.5
        myCardBackground.setCornerRadius(to: 4)
        myCardBackground.layer.shadowColor = UIColor.black.cgColor
        myCardBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    
    func updateVerifiedImage(){
        verified.image = UIImage(systemName: "checkmark.seal.fill")
        verified.tintColor = UIColor.systemBlue
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
    
    
    func addToContacts(){
        
        let con = CNMutableContact()
        
        con.givenName = contact?.firstname ?? "Error name"
        con.middleName = contact?.lastname ?? "Error name"
        
        
        if(person?.phone != nil && person?.phone != ""){
            con.phoneNumbers.append(CNLabeledValue(label: "mobile", value: CNPhoneNumber(stringValue: person?.phone ?? "")))
        }
        if(person?.work != nil && person?.work != ""){
            con.organizationName.append(contentsOf: person?.work ?? "")
        }
        if(person?.facebook != nil  && person?.facebook != ""){
            con.socialProfiles.append(CNLabeledValue(label: "facebook", value: CNSocialProfile(urlString: "https://facebook.com/\(person!.facebook!)", username: person?.facebook, userIdentifier: nil, service: "Facebook")))
        }
        if(person?.email != nil && person?.email != "" ){
            let workEmail = CNLabeledValue(label: "Email", value: person!.email! as NSString)
            con.emailAddresses = [workEmail]
        }
        
        if(person?.snapchat != nil && person?.snapchat != "" ) {
            
            con.socialProfiles.append(CNLabeledValue(label: "snapchat", value: CNSocialProfile(urlString: "https://Snapchat.com/\(person!.snapchat!)", username: person?.snapchat, userIdentifier: nil, service: "Snapchat")))
            
        }
        if(person?.twitter != nil && person?.twitter != "" ){
            
            con.socialProfiles.append(CNLabeledValue(label: "twitter", value: CNSocialProfile(urlString: "https://twitter.com/\(person!.twitter!)", username: person?.twitter, userIdentifier: nil, service: "Twitter")))
            
        }
        if(person?.instagram != nil && person?.instagram != ""){
            
            con.socialProfiles.append(CNLabeledValue(label: "instagram", value: CNSocialProfile(urlString: "https://Instagram.com/\(person!.instagram!)", username: person?.instagram, userIdentifier: nil, service: "Instagram")))
            
        }
        if(person?.linkedin != nil && person?.linkedin != ""){
            
            
            con.socialProfiles.append(CNLabeledValue(label: "linkedin", value: CNSocialProfile(urlString: "https://linkedin.com/\(person!.linkedin!)", username: person?.linkedin, userIdentifier: nil, service: "LinkedIn")))
            
        }
  
        if(person?.github != nil && person?.github != "") {
            
            
            con.socialProfiles.append(CNLabeledValue(label: "github", value: CNSocialProfile(urlString: "https://github.com/\(person!.github!)", username: person?.github, userIdentifier: nil, service: "Github")))
            
        }
        if(person?.tiktok != nil && person?.tiktok != ""){
            con.socialProfiles.append(CNLabeledValue(label: "tiktok", value: CNSocialProfile(urlString: "https://tiktok.com/\(person!.tiktok!)", username: person?.tiktok, userIdentifier: nil, service: "Tiktok")))
            
        }
        if(person?.applemusic != nil && person?.applemusic != ""){
            con.socialProfiles.append(CNLabeledValue(label: "applemusic", value: CNSocialProfile(urlString: "https://itunes.apple.com/profile/\(person!.applemusic!)", username: person?.applemusic, userIdentifier: nil, service: "Apple Music")))
            
        }
        if(person?.spotify != nil && person?.spotify != ""){
            con.socialProfiles.append(CNLabeledValue(label: "spotify", value: CNSocialProfile(urlString: "http://open.spotify.com/user/\(person!.spotify!)", username: person?.spotify, userIdentifier: nil, service: "Spotify")))
            
        }
        if(person?.youtube != nil && person?.youtube != ""){
            
            
            
            con.socialProfiles.append(CNLabeledValue(label: "youtube", value: CNSocialProfile(urlString: "https://www.youtube.com/channel/\(person!.youtube!)", username: person?.youtube, userIdentifier: nil, service: "Youtube")))
            
        }
        if(person?.venmo != nil && person?.venmo != ""){
            con.socialProfiles.append(CNLabeledValue(label: "venmo", value: CNSocialProfile(urlString: "https://venmo.com/\(person!.venmo!)", username: person?.venmo, userIdentifier: nil, service: "Venmo")))
            
        }
        if(person?.soundcloud != nil && person?.soundcloud != ""){
            con.socialProfiles.append(CNLabeledValue(label: "soundcloud", value: CNSocialProfile(urlString: "https://soundcloud.com/\(person!.soundcloud!)", username: person?.soundcloud, userIdentifier: nil, service: "soundcloud")))
            
        }
        if(person?.whatsapp != nil && person?.whatsapp != ""){
            con.socialProfiles.append(CNLabeledValue(label: "whatsapp", value: CNSocialProfile(urlString: "https://wa.me/\(person!.whatsapp!)", username: person?.whatsapp, userIdentifier: nil, service: "Whatsapp")))
            
        }
        
        if let sites = person?.websites {
        for site in sites{
            let website = CNLabeledValue(label:"Website", value:site as NSString)
            con.urlAddresses.append(website)
        }
        
        }
        if(person?.website != nil && person?.website != ""){
              
              
              
              let website = CNLabeledValue(label:"Website", value:person!.website! as NSString)
              con.urlAddresses.append(website)
          }
          if(person?.website2 != nil && person?.website2 != ""){
              let website = CNLabeledValue(label:"Website", value:person!.website2! as NSString)
              con.urlAddresses.append(website)
          }
          if(person?.website3 != nil && person?.website3 != ""){
              let website = CNLabeledValue(label:"Website", value:person!.website3! as NSString)
              con.urlAddresses.append(website)
          }
          if(person?.website4 != nil && person?.website4 != ""){
              let website = CNLabeledValue(label:"Website", value:person!.website4! as NSString)
              con.urlAddresses.append(website)
              
          }
        
        
        // Save
        let saveRequest = CNSaveRequest()
        saveRequest.add(con, toContainerWithIdentifier: nil)
        try? store.execute(saveRequest)
        
        CustomAlert.error(presentFrom: self, withTitle: "Added To Contacts", andMessage: "This card will be in your contact list now")
    }
}

//MARK: Navigation

extension ViewCardViewController{
    fileprivate func setupProfileImage(){
        profileImage.isHidden = true
        
        profileImage.addRadius(rad: profileImage.frame.width / 2)
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = UIColor.white.cgColor
        
    }
    
    
    fileprivate func getImage(){
        print(contact?.username)
        profileImage.setImage(username: contact?.username ?? "") { (success) in
            if success{
      
                self.profileImage.isHidden = false
    
            }
        }
    }
}

//MARK: Partners
extension ViewCardViewController{
    
    fileprivate func loadPartnerInfo(withPartnerName partnerName:String){
        
        DataGrab.getPartnerInfo(withPartnerName: partnerName) { (partner) in
              
              guard let partner = partner else{return}
              
              if let photoURL = partner.profileImage{
                   let _ = ImageHelper.loadImage(urlString: photoURL, withCache: false) {(_, image) in
                           
                      self.partnerImage.image = image
                        }
              }
              self.setParnterData(withPartner: partner)
                }
                
                
      }
      
      
      fileprivate func setParnterData(withPartner partner:Partner){
        guard let person = person else{return}
        
          person.facebook =  partner.facebook ?? person.facebook
          person.instagram =  partner.instagram ?? person.instagram
          person.website =  partner.website ?? person.website
          person.website2 =  partner.website2 ?? person.website2
          person.website3 =  partner.website3 ?? person.website3
          person.website4 =  partner.website4 ?? person.website4
          person.email =  partner.email ?? person.email
          person.github =  partner.github ?? person.github
          person.tiktok =  partner.tiktok ?? person.tiktok
          person.linkedin =  partner.linkedin ?? person.linkedin
          person.soundcloud =  partner.soundcloud ?? person.soundcloud
          person.applemusic =  partner.applemusic ?? person.applemusic
          person.spotify =  partner.spotify ?? person.spotify
          person.snapchat =  partner.snapchat ?? person.snapchat
          person.twitter =  partner.twitter ?? person.twitter
          person.venmo =  partner.venmo ?? person.venmo
          person.youtube =  partner.youtube ?? person.youtube
          person.work =  partner.work ?? person.work
          person.whatsapp =  partner.whatsapp ?? person.whatsapp
          person.websites = partner.websites

          self.loadDataInto(withPerson: person)

          self.userDataTableView.reloadData()
          
      }
}
