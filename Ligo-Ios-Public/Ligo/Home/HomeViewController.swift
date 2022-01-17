//
//  HomeViewController.swift
//  Ligo
//  Created by Cyrus Illick on 3/24/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import Firebase
import SideMenu
import EasyTipView
import FirebaseCrashlytics


// MARK: - Global Variables that store users info, can be acessed anywhere in the app
var username: String = "CatchUsername"
var userPassword: String = "CatchPassword"
var userEmail: String = "CatchEmail"
var me: Identity = Identity(name: "CatchName", identity: "default",firstName: "",lastName: "")



class HomeViewController: BaseViewController {



    // MARK: - Properties
    var sections = [String]()
    var cardsSections = [String:[Contact]]()
    var selectedIndex:Int?
    var walletCellHeight:CGFloat = 65


    // MARK: - IBOutlets
    @IBOutlet weak var indexCollectionView: UICollectionView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var walletTableView: UITableView!
    @IBOutlet weak var myCardBackground: GradientView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var indexHeight: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var verified: UIImageView!
    @IBOutlet weak var emptyWalletLabels: UIStackView!
    @IBOutlet weak var linkCopyButton: UIButton!
    @IBOutlet weak var partnerIcon: UIImageView!
    var hamburgerBtn:UIBarButtonItem!
    
    static var shouldRefresh = false
    //MARK: - Calculuated Properties


    ////Alphabetical Index Height
    var totalIndexHeight:CGFloat{
        return CGFloat(self.sections.count * 25) + 20
    }


    ////TableView total height of cells
    var totalCardsHeight:CGFloat{
        var total:CGFloat = 0
        self.sections.forEach {
            total += CGFloat(cardsSections[$0]?.count ?? 0) * walletCellHeight
        }
        return total + 20
    }

    ////TableView Header Height
    var headerHeight:CGFloat{
           return (self.walletTableView.tableHeaderView?.frame.height ?? 0)

    }


    func showEmptyWalletsLabel(_ show:Bool){
        emptyWalletLabels.isHidden = !show
    }

    //MARK: - Initialization


    override func viewDidLoad() {
        super.viewDidLoad()

        walletTableView.dataSource = self
        walletTableView.delegate = self
        walletTableView.showsVerticalScrollIndicator = false
        authenticateUserAndConfigureView()
        initIndexCollectionView()
        setupViews()
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.CardTapped))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        self.myCardBackground.addGestureRecognizer(singleTap)
        self.myCardBackground.isUserInteractionEnabled = true
    }

    @IBAction func showQRCode(_ sender: Any) {
        print("Clicked me")
        let _ = QRCodeView1.showAlert(view: self.view, text: "https://ligo.best/user/\(me.username)")
        Analytics.track(Analytics.Event.viewQR)
    }



    @objc func CardTapped() {
        let myContact: Contact = Contact(firstname: me.firstName, lastname: me.lastName, username: me.username)
        Analytics.track(Analytics.Event.cardTapped)
         performSegue(withIdentifier: "ViewCardSegue", sender: myContact)
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if HomeViewController.shouldRefresh{
            populateDataSource()
            HomeViewController.shouldRefresh = false
        }
        
        initMyCardBackground()
    }


    /// Gets called when the homeview controller becomes the top controller
    /// It is important so when the user updates their card, it is then updated
    /// to the home controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHomeView()


      //  let picker = ColorPicker.showAlert(view: view, text: "", title: "Color Picker")
        //picker.addAction(action: nil, text: "Done")

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // navigationController?.setNavigationBarHidden(false, animated: true)
    }


    func didLoadWallet(){
        loadingIndicator.isHidden = true
        walletTableView.tableHeaderView?.isHidden = false
    }


    ///sets card background to custom background, also sets seach button to custom color
    func initMyCardBackground() {
        let color1 = hexStringToUIColor(hex: me.grad1 ?? "FFFFFF")
        let color2 = hexStringToUIColor(hex: me.grad2 ?? "FFFFFF")
        myCardBackground.setCornerRadius(to: 4)
        myCardBackground.setColors(toStartColor: color1, andEndColor: color2)
        myCardBackground.layer.shadowOpacity = 0.5
        myCardBackground.layer.shadowColor = UIColor.black.cgColor
        myCardBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchView.backgroundColor = color2
    }

    //MARK: - Loading Data Setting home view

    /// Gets called when the homecontroller is loaded for the first time, This will be more important
    /// when we make it so users stay signed in
    func authenticateUserAndConfigureView() {

        if Auth.auth().currentUser == nil {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginSignUpViewController")
            vc.modalPresentationStyle = .fullScreen
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        } else {
            // Completion handlers are used here to make sure things work in sync
            loadUserData()
        }
    }

    fileprivate func loadUserData(){


        DataGrab.getCard { (val) in

            guard let val = val else{

                CustomAlert.error(presentFrom: self, withTitle: "An error occurred", andMessage: "We are unable to connect to our server. Please ensure that you have a working connection to the internet.")
                return

            }

            me = val
           
            print("Identiy of this card is " + me.identity)
            if(me.identity != "default"){
                
                self.getPartnerName(who: me.identity)
            }else{
                self.partnerIcon.image = nil
            }
            
            
            self.initMyCardBackground()
            self.usernameLabel.text = me.firstName
            self.typeLabel.text = me.bio ?? ""
            self.showStarterScreen()
            StoreReviewHelper.checkAndAskForReview()

            self.populateDataSource()
            DataGrab.requestFirebaseFID()


            if(me.isVerified ?? false){
                self.updateVerifiedImage()
            }

            Analytics.identifyUser(withId: me.username, andUsername: me.username)
            Analytics.setProperty(Analytics.PropertyField.firstName, userProperty: me.firstName)
            Analytics.setProperty(Analytics.PropertyField.lastName, userProperty: me.lastName)
            Analytics.setProperty(Analytics.PropertyField.email, userProperty: me.email)

        }



    }


    func getPartnerName(who: String){
        DataGrab.getPartnerInfo(who: who) { (val) in
            print("PARTNER \(val)")
            print(val["photourl"] ?? "")
            let _ = ImageHelper.loadImage(urlString: val["photourl"] ?? "", withCache: true) { (a, image) in
                if a == val["photourl"] ?? ""{
                    
                    self.partnerIcon.image = image
                }
            }

        }
    }

    /// Called to make sure fields on home screen are up to date
    /// whenever homeview controller is on screen
    func updateHomeView(){
        self.usernameLabel.text = me.firstName
        self.typeLabel.text = me.bio ?? ""
        if(me.identity != "default" ){
            self.getPartnerName(who: me.identity)
        }else{
            self.partnerIcon.image = nil
        }
        initMyCardBackground()
    }


    func updateVerifiedImage(){
        verified.image = UIImage(systemName: "checkmark.seal.fill")
        verified.tintColor = UIColor.systemBlue
    }

    // MARK: - Actions

    ///Sets up the public private switch
    //TODO: - We should be able to delete this with no issue
    @IBAction func publicPrivateSwitched(_ sender: UISwitch) {
        print("Switch is not be doing anything any more")
    }


    /// Search button view shows up
    @objc fileprivate func searchButtonPressed() {
        performSegue(withIdentifier: "SearchSegue", sender: nil)
        Analytics.track(Analytics.Event.searchButtonPressed)
    }

    ///Try to link with a user button
    //TODO: - We should be able to delete this with no issue
    @IBAction func linkRequestsButtonPressed() {
        performSegue(withIdentifier: "LinkRequestsSegue", sender: nil)
       // Analytics.track("Link Requests Button Pressed")
    }


    ///Gets called when the share button is pressed
    @IBAction func sharePressed(_ sender: Any) {

        Analytics.track(Analytics.Event.cardShared)

        let someText:String = "Check Out my card"
        let objectsToShare:URL = URL(string: "https://ligo.best/user/" + username)!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        self.present(activityViewController, animated: true, completion: nil)
    }


    @IBAction func CopyLinkPressed(_ sender: Any) {
        UIPasteboard.general.string = "https://ligo.best/user/\(username)"
        CustomAlert.showToast(message: "Copied Your URL!")
        Analytics.track(Analytics.Event.copyLinkPressed)
    }



    // MARK: - Navigation

    ///Segues to other controllers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ViewCardSegue") {
            guard let contactToView = sender as? Contact else {return}
            let destinationVC = segue.destination as! ViewCardViewController
            destinationVC.contact = contactToView
        }
        if (segue.identifier == "SearchSegue") {
            let destinationVC = segue.destination as! SearchMainTableViewController
            destinationVC.delegate = self
        }
    }

}

//MARK: - UI Setup
extension HomeViewController{


    fileprivate func setupViews(){
        self.hideNavigationShadow()
        setupSearch()
        setupTableView()
        addSideBar()
    }

    //TableView Setup
    fileprivate func setupTableView(){
        walletTableView.sectionHeaderHeight = UITableView.automaticDimension

        walletTableView.estimatedRowHeight = 350
    }

    //Setup SideBar
    fileprivate func addSideBar(){
        hamburgerBtn = UIBarButtonItem(image: #imageLiteral(resourceName: "hamburgerIcon").withRenderingMode(.alwaysTemplate), style: .done, target: self, action: #selector(openSidebar))
        hamburgerBtn.tintColor = .lightGray
        self.navigationItem.rightBarButtonItem = hamburgerBtn
    }



    //Search Icon Setup
    fileprivate func setupSearch(){
        searchView.backgroundColor = Theme.SoftPurple
        searchView.layer.cornerRadius = 25
        searchView.makeButton(withAction: #selector(searchButtonPressed), andTarget: self)
        searchView.layer.shadowOffset = CGSize(width: 0, height: 2)
        searchView.layer.shadowColor = UIColor.lightGray.cgColor
        searchView.layer.shadowOpacity = 0.4
    }

    @objc fileprivate func openSidebar(){
        Analytics.track(Analytics.Event.openSidebar)
        performSegue(withIdentifier: "openSidebar", sender: nil)
        closeTip()
    }

}
struct cutomError:Error{

}


//MARK: - Tutorial
extension HomeViewController{


    fileprivate func showStarterScreen(){
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)

        Crashlytics.crashlytics().checkForUnsentReports { _ in
            Crashlytics.crashlytics().sendUnsentReports()
        }
        if !self.isFirstLaunch(screen: "HomeScreenViewController"){return}

        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.85)

        let mainView = AppDelegate.MainUIView() ?? self.view!
        mainView.addSubview(overlay)
        overlay.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        overlay.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        overlay.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        overlay.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true


        let label = UILabel()
        label.font = Theme.mainFontBoldLarge
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to ligo,\nShare all of your profiles at once!"
        label.numberOfLines = -1
        label.textAlignment = .center

        overlay.addSubview(label)
        label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor).isActive = true

        let startButton = CustomButton()
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.text = "Start"
        startButton.bgColor = hexStringToUIColor(hex: me.grad1 ?? "FFFFFF")
        startButton.fontColor = .white

        startButton.addAction(Action(action: {
            overlay.removeFromSuperview()
            self.initMyTutorial()
        }))

        overlay.addSubview(startButton)
        startButton.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 16).isActive = true
        startButton.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        startButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        startButton.widthAnchor.constraint(equalToConstant: 50).isActive = true

    }

    @objc fileprivate func initMyTutorial(){

               guard let hamburgericon = self.hamburgerBtn.view else {return}

               setupTutorial(tips: [
                   Tip(bgColor: hexStringToUIColor(hex: me.grad1 ?? "FFFFFF"), title: "You can add all your information to your card by heading over to edit card!", padding: 4, onView: hamburgericon, radius: 5),

                   Tip(bgColor: hexStringToUIColor(hex: me.grad2 ?? "FFFFFF"), title: "Make your card private by going to settings", padding: 4, onView: hamburgericon, radius: 5),


                   Tip(bgColor: hexStringToUIColor(hex: me.grad1 ?? "FFFFFF"), title: "Search for your friends!", padding: 4, onView: searchView, radius: 25),

                   Tip(bgColor: hexStringToUIColor(hex: me.grad1 ?? "FFFFFF"), title: "Share your card with people!", padding: 4, onView: shareButton, radius: 5)

               ])
               startTutorial()
    }





}
extension UIBarButtonItem {
    var view: UIView? {
        return perform(#selector(getter: UIViewController.view)).takeRetainedValue() as? UIView
    }
}
