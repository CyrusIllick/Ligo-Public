//
//  EditCardTableViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 3/25/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class EditCardViewController: UIViewController{
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var myCardBackground: GradientView!
    
    //MARK: - Properties
    var datasource = [CardSection]()
    static var websiteCount = 0
    
    fileprivate lazy var saveButton = {
        UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveAction))
    }()
    
    fileprivate var loadingView:LoadingView?
    fileprivate let imagePicker = UIImagePickerController()
    
    
    fileprivate var userImage:UIImage?
    
    fileprivate lazy var profileImage:ProfileView = {
        let i = ProfileView(frame:.zero)
        return i
    }()
    
    
    func initMyCardBackground() {
        let color1: UIColor = hexStringToUIColor(hex: me.grad1 ?? "FFFFFF")
        let color2: UIColor = hexStringToUIColor(hex: me.grad2 ?? "000000")
        myCardBackground.setColors(toStartColor: color1, andEndColor: color2)
    }
    
    
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //initSaveButton()
        loadInData()
        self.navigationController?.navigationBar.tintColor = .white
        initMyCardBackground()
        addImageHeaderView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initMyCardBackground()
    }
    
    /* Creates the save button */
    func initSaveButton() {
        navigationItem.rightBarButtonItem = saveButton
    }
    
    
    
    
    //MARK: - Actions
    @objc func saveAction() {
        saveCardInfo()
        Analytics.track(Analytics.Event.saveCard)
    }
    
    @objc func openChangeColor() {
        
        
        let storyboard = UIStoryboard(name: "ChangeColor", bundle: nil)
        
        
        let vc = storyboard.instantiateInitialViewController()!
        vc.modalPresentationStyle = .fullScreen
        
        self.present(vc, animated: true, completion: nil)
        
        
        
    }
    
    //MARK: - Helper functions
    
    //for color from database
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
}




//MARK: DataSource
extension EditCardViewController{
    
    ///Add detail under appropriate Section
    fileprivate func setDetailCard(Section key:String, detail type:String, value:String?){
        
        
        let cardSection = datasource.filter {
            $0.name == key
        }.first ?? CardSection(name: key)
        
        cardSection.addDetail(type: type, value: value ?? "")
        
        ///If section hasn't been added before
        if !datasource.contains(cardSection){
            datasource.append(cardSection)
        }
        
        
        
    }
    
    func removeWebsite(_ num:Int){
        let cardSection = datasource.filter {
            $0.name == "Contact Me"
        }.first ?? CardSection(name: "Contact Me")
        
        if let index = cardSection.detailTypes.firstIndex(of: "website \(num)"){
        cardSection.detailTypes.remove(at: index)
        tableView.reloadData()
        EditCardViewController.websiteCount -= 1
            
            initSaveButton()
        }
    }
    
    func addSite(){
        EditCardViewController.websiteCount += 1
        
        self.setDetailCard(Section: "Contact Me", detail: "website \(EditCardViewController.websiteCount)", value: me.website2)
        self.tableView.reloadData()
        initSaveButton()
    }
    
    
    
    //MARK: - Connecting to database
    
    /// Loads data from global user identity
    func loadInData() {
        
        DataGrab.getCard{value in
            self.nameLabel.text = me.username
            
            
            self.setDetailCard(Section: "About Me", detail: "username", value: me.username)
            self.setDetailCard(Section: "About Me", detail: "first name", value: me.firstName)
            self.setDetailCard(Section: "About Me", detail: "last name", value: me.lastName)
            
            self.setDetailCard(Section: "About Me", detail: "bio", value: me.bio)
            self.setDetailCard(Section: "About Me", detail: "work", value: me.work)
            
            
            self.setDetailCard(Section: "Contact Me", detail: "phone", value: me.phone)
            self.setDetailCard(Section: "Contact Me", detail: "email", value: me.email)
            self.setDetailCard(Section: "Contact Me", detail: "whatsapp", value: me.whatsapp)
          
                
            self.setDetailCard(Section: "Contact Me", detail: "website", value:  me.websites.count == 0 ? "" : me.websites[0])
            
            self.setDetailCard(Section: "Contact Me", detail: "AddWebsite", value: me.website)

            for (index,value) in me.websites.enumerated(){
                if index == 0 {continue}
                self.setDetailCard(Section: "Contact Me", detail: "website \(index)", value: value)

                
            }
            
            EditCardViewController.websiteCount = (me.websites.count == 0) ? 0 : me.websites.count - 1
            print("MY WESB \(me.websites)")
            
            
            self.setDetailCard(Section: "My Socials", detail: "facebook", value: me.facebook)
            self.setDetailCard(Section: "My Socials", detail: "instagram", value: me.instagram)
            self.setDetailCard(Section: "My Socials", detail: "snapchat", value: me.snapchat)
            self.setDetailCard(Section: "My Socials", detail: "twitter", value: me.twitter)
            self.setDetailCard(Section: "My Socials", detail: "tiktok", value: me.tiktok)
            
            
            self.setDetailCard(Section: "My Socials", detail: "linkedin", value: me.linkedin)
            self.setDetailCard(Section: "My Socials", detail: "github", value: me.github)
            self.setDetailCard(Section: "My Socials", detail: "apple music", value: me.applemusic)
            self.setDetailCard(Section: "My Socials", detail: "spotify", value: me.spotify)
            self.setDetailCard(Section: "My Socials", detail: "youtube", value: me.youtube)
            self.setDetailCard(Section: "My Socials", detail: "venmo", value: me.venmo)
            self.setDetailCard(Section: "My Socials", detail: "sound cloud", value: me.soundcloud)
            
            
            self.tableView.reloadData()
            self.setProfilePicture()
        }
    }
    

    fileprivate func setProfilePicture(){
        
        
        if let photoURL = me.profileImage{
            print(photoURL == "")
            profileImage.setImage(url: photoURL)
        }else{
            profileImage.showPlaceholder()
        }
    }
    
    
    
    // Called when the user clicks save
    // Only updates fields to the database
    // that have been changed
    func saveCardInfo(){
        view.endEditing(true)
        loadingView = LoadingView.showLoading(view: view)
        print("Starting to Save Data")
        // Uncomment next line for debugging
        // printUserData()
        
        // Dealing with asyn aspect of accesing a database
        let group = DispatchGroup()
        group.enter()
        
        
        
        var details = [String:String]()
        for card in datasource{
            details.merge(dict: card.detailValues)
        }
        
        
        DispatchQueue.main.async {
            self.loadingView?.hideLoading()
            if((details["username"] ?? "").count == 0){
                CustomAlert.autoDismiss(presentFrom: self, withTitle: "You must have a username", andMessage: "Your card must have a name")
                return
            }
            
            if((details["first name"] ?? "").count == 0){
                CustomAlert.autoDismiss(presentFrom: self, withTitle: "You must have a first name", andMessage: "Your card must have a name")
                return
            }
            if((details["last name"] ?? "").count == 0){
                CustomAlert.autoDismiss(presentFrom: self, withTitle: "You must have a last name", andMessage: "Your card must have a name")
                return
            }
            
            
            if(details["username"] ?? "" != me.username){
                me.username =  details["username"] ?? ""
                DataGrab.updateField(type: "username", to:details["username"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateUsername)

            }
          

            if(details["first name"] ?? "" != me.firstName){
                me.firstName = details["first name"]?.capitalizingFirstLetter() ?? ""
                DataGrab.updateField(type: "firstName", to:details["first name"]?.capitalizingFirstLetter() ?? "", completion: {})
                Analytics.track(Analytics.Event.updateFirstName)
            }
            
            if(details["last name"] ?? "" != me.lastName){
                me.lastName = details["last name"]?.capitalizingFirstLetter() ?? ""
                DataGrab.updateField(type: "lastName", to:details["last name"]?.capitalizingFirstLetter() ?? "", completion: {})
                Analytics.track(Analytics.Event.updateLastName)
            }
            
            if(details["bio"] ?? "" != me.bio){
                me.bio = details["bio"] ?? ""
                DataGrab.updateField(type: "bio", to:details["bio"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateBio)
            }
            
            if(details["work"] ?? "" != me.work){
                me.work = details["work"] ?? ""
                DataGrab.updateField(type: "work", to: details["work"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateWork)
            }
            
            if(details["phone"] ?? "" != me.phone){
                me.phone = details["phone"] ?? ""
                DataGrab.updateField(type: "phone", to: details["phone"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updatePhone)
            }
            if(details["whatsapp"] ?? "" != me.whatsapp){
                me.whatsapp = details["whatsapp"] ?? ""
                DataGrab.updateField(type: "whatsapp", to: details["whatsapp"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateWhatsapp)
            }
            
            
            if(details["email"] ?? "" != me.email){
                me.email = details["email"] ?? ""
                DataGrab.updateField(type: "email", to: details["email"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateCardEmail)
            }
            
            var mySites = [String]()
            mySites.append(details["website"] ?? "")
            
            
            if EditCardViewController.websiteCount >= 1{
                
            for i in 1...EditCardViewController.websiteCount{
                if details["website \(i)"]  == nil{continue}
                mySites.append(details["website \(i)"] ?? "")
            }
            }
            me.websites = mySites
            Analytics.track(Analytics.Event.updateWebsite)
            DataGrab.saveWebsites(sites: mySites, completion: {})

//            if(details["website"] ?? "" != me.website){
//                me.website = details["website"] ?? ""
//                DataGrab.updateField(type: "website", to: details["website"] ?? "", completion: {})
//                Analytics.track(Analytics.Event.updateWebsite)
//            }
//            if(details["website 2"] ?? "" != me.website2){
//                me.website2 = details["website 2"] ?? ""
//                DataGrab.updateField(type: "website2", to: details["website 2"] ?? "", completion: {})
//                Analytics.track(Analytics.Event.updateWebsite2)
//            }
//            if(details["website 3"] ?? "" != me.website3){
//                me.website3 = details["website 3"] ?? ""
//                DataGrab.updateField(type: "website3", to: details["website 3"] ?? "", completion: {})
//                Analytics.track(Analytics.Event.updateWebsite3)
//            }
//            if(details["website 4"] ?? "" != me.website4){
//                me.website4 = details["website 4"] ?? ""
//                DataGrab.updateField(type: "website4", to: details["website 4"] ?? "", completion: {})
//                Analytics.track(Analytics.Event.updateWebsite4)
//            }
            
            
            if(details["facebook"] ?? "" != me.facebook){
                me.facebook = details["facebook"] ?? ""
                DataGrab.updateField(type: "facebook", to: details["facebook"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateFacebook)
            }
            
            if(details["instagram"] ?? "" != me.instagram){
                me.instagram = details["instagram"] ?? ""
                DataGrab.updateField(type: "instagram", to: details["instagram"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateInstagram)
            }
            
            if(details["snapchat"] ?? "" != me.snapchat){
                me.snapchat = details["snapchat"] ?? ""
                DataGrab.updateField(type: "snapchat", to: details["snapchat"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateSnapchat)
            }
            
            if(details["twitter"] ?? "" != me.twitter){
                me.twitter = details["twitter"] ?? ""
                DataGrab.updateField(type: "twitter", to: details["twitter"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateTwitter)
            }
            if(details["linkedin"] ?? "" != me.linkedin){
                me.linkedin = details["linkedin"] ?? ""
                DataGrab.updateField(type: "linkedin", to: details["linkedin"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateLinkedin)
            }
            if(details["github"] ?? "" != me.github){
                me.github = details["github"] ?? ""
                DataGrab.updateField(type: "github", to: details["github"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateGithub)
            }
            if(details["venmo"] ?? "" != me.venmo){
                me.venmo = details["venmo"] ?? ""
                DataGrab.updateField(type: "venmo", to: details["venmo"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateVenmo)
            }
            if(details["spotify"] ?? "" != me.spotify){
                me.spotify = details["spotify"] ?? ""
                DataGrab.updateField(type: "spotify", to: details["spotify"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateSpotify)
            }
            if(details["apple music"] ?? "" != me.applemusic){
                me.applemusic = details["apple music"] ?? ""
                DataGrab.updateField(type: "applemusic", to: details["apple music"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateAppleMusic)
            }
            
            
            if(details["youtube"] ?? "" != me.youtube){
                me.youtube = details["youtube"] ?? ""
                DataGrab.updateField(type: "youtube", to: details["youtube"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateYoutube)
            }
            if(details["sound cloud"] ?? "" != me.soundcloud){
                me.soundcloud = details["sound cloud"] ?? ""
                DataGrab.updateField(type: "soundcloud", to: details["sound cloud"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateSoundCloud)
            }
            if(details["tiktok"] ?? "" != me.tiktok){
                me.tiktok = details["tiktok"] ?? ""
                DataGrab.updateField(type: "tiktok", to: details["tiktok"] ?? "", completion: {})
                Analytics.track(Analytics.Event.updateTiktok)
            }
            
            /* This line stopes the async aspect of the program */
            group.leave()
        }
        
        
        group.notify(queue: .main){
            self.loadingView?.hideLoading()
            CustomAlert.success(presentFrom: self, withTitle: "Saved", andMessage: "Your card updates were saved")
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    
    //    // MARK: - Debugging
    //    func printUserData() {
    //        guard let userData = userData else {return}
    //        for group in userData {
    //            for detail in group {
    //                print(detail)
    //            }
    //        }
    //    }
    
}



//MARK: - Commented out code we might want for later


//    // Override to support conditional editing of the table view.
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }


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
extension EditCardViewController{
    
    fileprivate func addImageHeaderView(){
        let headerView = UIView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        self.tableView.tableHeaderView = headerView
        
        headerView.widthAnchor.constraint(equalTo:self.tableView.widthAnchor).isActive = true
        
        headerView.addSubview(profileImage)
        
        profileImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profileImage.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        profileImage.topAnchor.constraint(equalTo: headerView.topAnchor).isActive = true
        
        
        profileImage.addRadius(rad: 45)
        profileImage.layer.borderWidth = 5
        profileImage.layer.borderColor = Theme.Rajah.cgColor
        
        
        let editIcon = UIImageView()
        editIcon.translatesAutoresizingMaskIntoConstraints = false
        editIcon.image = UIImage(systemName: "camera.fill")
        editIcon.contentMode = .scaleAspectFit
        
        
        editIcon.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editIcon.widthAnchor.constraint(equalToConstant: 30).isActive = true
        editIcon.tintColor = .black
        
        headerView.addSubview(editIcon)
        editIcon.bottomAnchor.constraint(equalTo: profileImage.bottomAnchor,constant: 4).isActive = true
        editIcon.rightAnchor.constraint(equalTo: profileImage.rightAnchor,constant: -8).isActive = true
        
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectPhoto)))
        
        let editCardIcon = UIImageView(image: UIImage(systemName: "paintbrush.fill"))
        editCardIcon.contentMode = .scaleAspectFit
        editCardIcon.tintColor = Theme.Rajah
        editCardIcon.translatesAutoresizingMaskIntoConstraints = false
        editCardIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        editCardIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        let editCardLabel = UILabel()
        editCardLabel.font = Theme.mainFontSemiBoldMedium
        editCardLabel.textColor = Theme.Rajah
        editCardLabel.translatesAutoresizingMaskIntoConstraints = false
        editCardLabel.text = "Change Card Colors"
        
        let editCardStack = UIStackView(arrangedSubviews: [editCardIcon,editCardLabel])
        editCardStack.translatesAutoresizingMaskIntoConstraints = false
        editCardStack.axis = .horizontal
        editCardStack.distribution = .equalSpacing
        editCardStack.spacing = 8
        editCardStack.alignment = .center
       
        headerView.addSubview(editCardStack)
        editCardStack.heightAnchor.constraint(equalToConstant: 25).isActive = true

        editCardStack.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        editCardStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
        editCardStack.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openChangeColor)))
    }
    
    
    
    // @objc fileprivate func selectPhoto(){}
    
}


extension EditCardViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    @objc fileprivate func selectPhoto()
    {
        
        imagePicker.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        /*If you want work actionsheet on ipad
         then you have to use popoverPresentationController to present the actionsheet,
         otherwise app will crash on iPad */
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = profileImage
            alert.popoverPresentationController?.sourceRect = profileImage.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = .camera
            imagePicker.cameraCaptureMode = .photo
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            CustomAlert.error(presentFrom: self, withTitle: "Warning", andMessage: "You don't have camera")
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    
    internal func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.setImage(image: pickedImage)
            userImage = pickedImage
            uploadImage(image: pickedImage)
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    fileprivate func showError(){
        let alertController = UIAlertController (title: "An error occurred", message: "An unknown error occurred while splitting the image. ", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}



extension EditCardViewController{
    
    fileprivate func uploadImage(image:UIImage){
        let loadingView = LoadingView.showLoading(view: view)
        
        DataGrab.uploadImage(image: image, user: me.username) { (url, error) in
            if error != nil{
                print(error!)
                loadingView.hideLoading()
                CustomAlert.error(presentFrom: self, withTitle: "An error occurred", andMessage: "An error occurred while uploading your new profile picture.")
                return
            }
            
            me.profileImage = url?.absoluteString
            
            DataGrab.updateField(type: "profileImage", to: url?.absoluteString ?? "") {
                print("Uploaded")
                loadingView.hideLoading()
            }
        }
        Analytics.track(Analytics.Event.updateProfilePicture)
    }
    
}


