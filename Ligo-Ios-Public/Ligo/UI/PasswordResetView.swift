

import Foundation
import UIKit
class PasswordResetView:UIView{
    
    fileprivate lazy var buttonStack:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.spacing = 8
        s.distribution = .fillEqually
        return s
    }()
    
    
    fileprivate func buttonCreator(text:String) -> CustomButton{
        
        let b = CustomButton(frame: CGRect.zero)
        
        b.bgColor = Theme.Rajah
        b.secondaryColor = .white
        b.fontColor = .white
        b.mainText.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        b.text = text
        
        return b
        
    }
    
    func hideAlert(){
        self.removeFromSuperview()
    }
    
    func addAction(action:Action?,text:String, dismissAction:Bool = false){
        let button = buttonCreator(text: text)
        
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        // button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.addAction(action)
        if dismissAction{
            self.emailField.resignFirstResponder()
            button.addAction(Action(action: {[weak self] in
                print("Clicked")
                self?.dismissClicked()
            }))
        }
        
        buttonStack.addArrangedSubview(button)
        
    }
    
    fileprivate func dismissClicked(){
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.background.alpha = 0
            self.background.transform = CGAffineTransform(translationX: 0, y: -500)
            self.alpha = 0
        }, completion: { (_) in
            self.hideAlert()
        })
        
        
    }
    
    static func showAlert(view:UIView, title:String) -> PasswordResetView{
      //  let currentWindow:UIWindow? = UIApplication.shared.keyWindow
        
 
        let mainView = AppDelegate.MainUIView() ?? view
        //print("currentWindow \(currentWindow)")
        
        let loadingView = PasswordResetView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(loadingView)
        
        loadingView.background.alpha = 0
        loadingView.background.transform = CGAffineTransform(translationX: 0, y: -500)
        
        loadingView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        
        //loadingView.text.text = text
        loadingView.titleLabel.text = title
        
        let boxWidth = view.frame.width * 0.9
        
        loadingView.heightAlert?.constant = 210 + title.height(withConstrainedWidth: boxWidth, font: UIFont.systemFont(ofSize: 16, weight: .bold)) + loadingView.buttonHeight
        loadingView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            loadingView.background.alpha = 1
            loadingView.background.transform = .identity
        })
        
        return loadingView
    }
    
    
    lazy var overly:UIScrollView = {
        let v = UIScrollView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var background:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.addShadow(radius: 0.5, height: 1, width: 1, opacity: 0.2, color: UIColor.black.cgColor)
        v.addRadius(rad: 15)
        return v
    }()
    
  
    
    let emailField:UITextField = {
        let field = UITextField()
        field.placeholder = "Your email"
        field.clipsToBounds = true
          field.layer.cornerRadius = 20
        
        field.addLeftRightImage(pos: .left, im: UIImage(systemName: "envelope.fill"), mode: .always, tint: .black)
        field.keyboardType = UIKeyboardType.emailAddress
        
        field.borderStyle = .none
        field.backgroundColor = Theme.AlmostWhite
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    fileprivate lazy var titleLabel:UILabel = {
        let f = UILabel()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.font =  UIFont.systemFont(ofSize: 16, weight: .bold)
        f.textColor = UIColor.black
        f.text = ""
        f.numberOfLines = -1
        f.textAlignment = .center
        return f
    }()
    
    fileprivate lazy var logo:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "circleLogo"))
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        im.layer.cornerRadius = 50
        im.layer.masksToBounds = true
        return im
    }()
    
    var heightAlert:NSLayoutConstraint?
    var heightAlertConstant:CGFloat = 200
    var positionYConstraint:NSLayoutConstraint?
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
           
            
            var aRect : CGRect = overly.frame
             aRect.size.height -= keyboardSize.height
             
            
             //print(activeField)
             
                 
                 print("YOLO")
                  let activeFieldFrame = self.convert(emailField.frame, from: emailField.superview)
                 print(activeFieldFrame.maxY)
                 print(aRect.maxY)

                 if (activeFieldFrame.maxY > aRect.maxY)
                 {
                    positionYConstraint?.constant -= activeFieldFrame.maxY - aRect.maxY + 50

                    UIView.animate(withDuration: 0.25) {
                        self.background.layoutIfNeeded()
                    }

            }
                
                
            }
            
            
            
        
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        positionYConstraint?.constant = 0

        UIView.animate(withDuration: 0.25) {
            self.background.layoutIfNeeded()
        }
        //positionYConstraint?.constant = 0
    }

    fileprivate func setupViews(){
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        
        self.addSubview(overly)
        
        overly.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        overly.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        overly.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        overly.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        overly.addSubview(background)
        background.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        
        
        
      //  background.heightAnchor.constraint(equalTo: overly.heightAnchor, multiplier: 0.3).isActive = true
        heightAlert = background.heightAnchor.constraint(equalToConstant: heightAlertConstant)
        heightAlert?.isActive = true
        
        background.centerXAnchor.constraint(equalTo: overly.centerXAnchor).isActive = true
        positionYConstraint = background.centerYAnchor.constraint(equalTo: overly.centerYAnchor)
        positionYConstraint?.isActive = true
        
        
        background.addSubview(logo)
        logo.topAnchor.constraint(equalTo: background.topAnchor,constant:8).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
        
       
        
        
        
        
        
        background.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor,constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -8).isActive = true
        
        background.addSubview(emailField)
        emailField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 16).isActive = true
        emailField.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 16).isActive = true
        emailField.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -16).isActive = true
       
         emailField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        background.addSubview(buttonStack)
               buttonStack.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -8).isActive = true
               buttonStack.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 16).isActive = true
               buttonStack.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -16).isActive = true
               buttonStack.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       // overly.contentSize = background.frame.size
    }
    
    
    var buttonHeight:CGFloat = 35
    var buttonWidth:CGFloat = 100
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}

