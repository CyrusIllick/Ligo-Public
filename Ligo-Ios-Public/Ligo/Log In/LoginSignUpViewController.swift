//
//  LViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 01/06/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import FirebaseAuth
class LoginSignUpViewController: UIViewController {
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var customSwitch: CustomSwitch!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logoBg: GradientView!
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameStack: UIStackView!
    @IBOutlet weak var lastNameStack: UIStackView!
    @IBOutlet weak var usernameStack: UIStackView!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: PasswordEntryTextField!
    @IBOutlet weak var loginBtn: CustomButton!
    @IBOutlet weak var confirmPasswordStack: UIStackView!
    @IBOutlet weak var confirmField: PasswordEntryTextField!
    
    @IBOutlet weak var forgotBtn: UIButton!
    
    
    
   
    //TNC View
    fileprivate lazy var checkBoxView:TNCView = {
        let v = TNCView(viewController: self, frame: .zero)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    //@IBOutlet weak var TermsOfService: UIButton!
    
    
    //MARK: - Properties
    var loadingView:LoadingView?
    
    fileprivate var state:CustomSwitch.CustomSwitchState = .first{
        didSet{
            let text = state == .first ? "Login" : "Sign up"
            loginBtn.text = text
            
            //headerHeightConstraint. = self.state == .first ? 0.3 : 0.15
            
            UIView.animate(withDuration: 0.25) {
                self.logoBg.layoutIfNeeded()
                self.checkBoxView.alpha = self.state == .first ? 0 : 1
                self.confirmPasswordStack.alpha = self.state == .first ? 0 : 1
                self.usernameStack.alpha = self.state == .first ? 0 : 1
                
                self.forgotBtn.alpha = self.state == .first ? 1 : 0
                
                self.firstNameStack.alpha = self.state == .first ? 0 : 1
                self.lastNameStack.alpha = self.state == .first ? 0 : 1

                
            }
            forgotBtn.isHidden = state == .second
            
            
            checkBoxView.isHidden = state == .first
            
            usernameStack.isHidden = state == .first
            confirmPasswordStack.isHidden = state == .first

            firstNameStack.isHidden = state == .first
            lastNameStack.isHidden = state == .first

            
        }
    }
    
    
    @IBAction func Terms(_ sender: Any) {
        if let url = URL(string: "https://ligo.best/#tos") {
            UIApplication.shared.open(url)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        state = .second
        
        customSwitch.changeState()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initalizeFields()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupViews()
        animateView()
    }
}


//MARK: - View Setup
extension LoginSignUpViewController{
    
    
    //MARK: - OnLoad Animations
    fileprivate func animateView(){
        logo.alpha = 0
        logo.transform = CGAffineTransform(rotationAngle: CGFloat.pi).concatenating(CGAffineTransform(scaleX: 0.4, y: 0.4))
        
        
        
        mainStackView.alpha = 0
        customSwitch.alpha = 0
        
        UIView.animate(withDuration: 1, delay: 0.25, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
            self.logo.alpha = 1
            self.logo.transform = .identity
            self.mainStackView.alpha = 1
            self.customSwitch.alpha = 1
            
        }, completion: nil)
    }
    
    
    
    //MARK: - Adds the neccessary borders and radius to each field.
    fileprivate func initalizeFields(){
        
        emailField.layer.cornerRadius = 20
        emailField.layer.masksToBounds = true
        
        passwordField.clipsToBounds = true
        passwordField.layer.cornerRadius = 20
        
        confirmField.clipsToBounds = true
        confirmField.layer.cornerRadius = 20
        
        
        usernameField.layer.cornerRadius = 20
        usernameField.layer.masksToBounds = true
        
        firstNameField.layer.cornerRadius = 20
        firstNameField.layer.masksToBounds = true
        
        lastNameField.layer.cornerRadius = 20
        lastNameField.layer.masksToBounds = true
        
        
        
    }
    
    
    
    /// Setups the fields to display icons on the right, also adds styling to the login button and the Custom Switch.
    fileprivate func setupViews(){
        initMyCardBackground()
        
        
        emailField.borderStyle = .none
        emailField.addLeftRightImage(pos: .left, im: UIImage(systemName: "envelope.fill"), mode: .always, tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        
        
        usernameField.borderStyle = .none
        usernameField.addLeftRightImage(pos: .left, im: UIImage(systemName: "person.fill"), mode: .always, tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        
        firstNameField.borderStyle = .none
        firstNameField.addLeftRightImage(pos: .left, im: UIImage(systemName: "person.fill"), mode: .always, tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        
        lastNameField.borderStyle = .none
        lastNameField.addLeftRightImage(pos: .left, im: UIImage(systemName: "person.fill"), mode: .always, tint: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        
        loginBtn.bgColor = Theme.Rajah
        loginBtn.secondaryColor = .white
        loginBtn.fontColor = .white
        loginBtn.text = "Sign up"
        loginBtn.mainText.textAlignment = .center
        loginBtn.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        
        
        passwordField.initalizeShowHideFeature(showImage:#imageLiteral(resourceName: "showPassword"), hideImage: #imageLiteral(resourceName: "hidePassword"))
        passwordField.setTint(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        
        confirmField.initalizeShowHideFeature(showImage:#imageLiteral(resourceName: "showPassword"), hideImage: #imageLiteral(resourceName: "hidePassword"))
        confirmField.setTint(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        

        customSwitch.colorSecondary = Theme.Rajah
        customSwitch.colorPrimary = Theme.AlmostWhite
        
        customSwitch.cornerRadius = 20
        customSwitch.mainText.text = "Login"
        customSwitch.secondaryText.text = "Sign up"
        customSwitch.delegate = self
        
        loginBtn.addAction(Action(action: {
            self.signUpLoginButtonPressed()
        }))
        
        setupCheckBox()
        
        
    }
    
    
    fileprivate func setupCheckBox(){
        checkBoxView.widthAnchor.constraint(equalToConstant:255).isActive = true
        checkBoxView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmPasswordStack.addArrangedSubview(checkBoxView)
        checkBoxView.checkBoxPrimaryColor = Theme.Rajah
        
        checkBoxView.termsAndConditionsButtonColor = Theme.Rajah
        checkBoxView.errorAlertTitle = "Error"
        checkBoxView.errorAlertDesc = "Please accept the terms and conditions to proceed."
        checkBoxView.urlToOpen = "https://ligo.best/tos"
    }
    
    
    //MARK: - Setup gradient background behind logo.
    func initMyCardBackground() {
        logoBg.setCornerRadius(to: 0)
        logoBg.setColors(toStartColor: Theme.SoftPurple, andEndColor: Theme.Rajah)
        
    }
}


//MARK: -Login/Signup Action
extension LoginSignUpViewController{
    
    //MARK: - Forgot Password Button Click
    @IBAction func forgotPassword(_ sender: Any) {
        //Show's the dialogue
        let resetView = PasswordResetView.showAlert(view: view, title: "Reset your password")

        //On clicking reset password
        resetView.addAction(action: Action(action: {
           
            //Hide keyboard
            resetView.emailField.resignFirstResponder()
               
            //Get email from textfield
               guard let email = resetView.emailField.text else{
                   CustomAlert.error(presentFrom: self, withTitle: "Error", andMessage: "The email you have entered is invalid")
                   return
               }
               
            //Check if email is valid
               if !LoginSignUpViewController.isValidEmail(email){
                   CustomAlert.error(presentFrom: self, withTitle: "Error", andMessage: "The email you have entered is invalid")
                   return
               }
               
            //Hide alert and show loading
               resetView.hideAlert()
               self.loadingView = LoadingView.showLoading(view: self.view)
               
            
            //Attempt reset of password with given email
               DataGrab.resetPassword(email: email) { (error) in
                   
                //If an error occurs, (i.e email not in db, network error)
                if error == nil{
                       CustomAlert.error(presentFrom: self, withTitle: "Password Reset", andMessage: "We've sent you an email to reset your password")
                //On successful reset operation
                }else{
                       CustomAlert.error(presentFrom: self, withTitle: "Error", andMessage:error!)
                   }
                   self.loadingView?.hideLoading()
               }
               print("Reset password")
           }), text: "Reset")
           resetView.addAction(action: nil, text: "Cancel", dismissAction: true)
       }
    
    
    ///Calls the signup user function when button is pressed
    @objc fileprivate func signUpLoginButtonPressed() {
        if self.state == .first{
            logUserIn(withEmail: emailField.text ?? "", password: passwordField.text ?? "")
        }else{
            if confirmField.text != passwordField.text{
                CustomAlert.error(presentFrom: self, withTitle: "Error", andMessage: "Your passwords do not match!")
                return
            }
            checkBoxView.verifyCheck {[weak self] in
                self?.signUserUp()
            }
        }
        
        //Closes the keyboard in case it is currently open
        view.endEditing(true)
    }
}





//MARK: - Login/Signup Mode
extension LoginSignUpViewController:CustomSwitchProtocol{
    
    
    /// Called when the user changes the mode from login to sign up or viceversa.
    /// - Parameter state: State of the CustomSwitch | First or Second
    func stateChanged(state:CustomSwitch.CustomSwitchState){
        self.state = state
        self.view.endEditing(true)
    }
    
}
