

import Foundation
import UIKit
class AlertBox:UIView{
    
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
    
    static func showAlert(view:UIView,text:String, title:String) -> AlertBox{
      //  let currentWindow:UIWindow? = UIApplication.shared.keyWindow
        
 
        let mainView = AppDelegate.MainUIView() ?? view
        //print("currentWindow \(currentWindow)")
        
        let loadingView = AlertBox()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(loadingView)
        
        loadingView.background.alpha = 0
        loadingView.background.transform = CGAffineTransform(translationX: 0, y: -500)
        
        loadingView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        
        loadingView.text.text = text
        loadingView.titleLabel.text = title
        
        let boxWidth = view.frame.width * 0.9
        
        loadingView.heightAlert?.constant = 200 + title.height(withConstrainedWidth: boxWidth, font: UIFont.systemFont(ofSize: 16, weight: .bold)) + text.height(withConstrainedWidth: boxWidth, font:  UIFont.systemFont(ofSize: 16))
        loadingView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            loadingView.background.alpha = 1
            loadingView.background.transform = .identity
        })
        
        return loadingView
    }
    
    
    lazy var overly:UIView = {
        let v = UIView()
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
    
    fileprivate lazy var text:UILabel = {
        let f = UILabel()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.font =  UIFont.systemFont(ofSize: 16)
        f.textColor =  UIColor.black
        f.numberOfLines = -1
        f.textAlignment = .center
        return f
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
        let im = UIImageView(image: #imageLiteral(resourceName: "LigoLogCircle"))
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        im.layer.cornerRadius = 50
        im.layer.masksToBounds = true
        return im
    }()
    
    var heightAlert:NSLayoutConstraint?
    var heightAlertConstant:CGFloat = 200
    fileprivate func setupViews(){
        
        
        self.addSubview(overly)
        
        overly.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        overly.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        overly.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        overly.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        self.addSubview(background)
        background.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        
        heightAlert = background.heightAnchor.constraint(equalToConstant: heightAlertConstant)
        heightAlert?.isActive = true
        
        background.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
        background.addSubview(logo)
        logo.topAnchor.constraint(equalTo: background.topAnchor,constant:8).isActive = true
        logo.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        logo.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
        
        background.addSubview(buttonStack)
        buttonStack.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -8).isActive = true
        buttonStack.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 16).isActive = true
        buttonStack.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -16).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        
        
        
        
        
        background.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: logo.bottomAnchor,constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -8).isActive = true
        
        background.addSubview(text)
        text.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 0).isActive = true
        text.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 8).isActive = true
        text.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -8).isActive = true
        text.bottomAnchor.constraint(equalTo: buttonStack.topAnchor,constant: -8).isActive = true
        
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

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
