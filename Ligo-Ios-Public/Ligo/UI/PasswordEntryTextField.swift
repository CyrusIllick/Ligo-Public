

import Foundation
import UIKit


class PasswordEntryTextField: UITextField{
    
    // MARK: - Properties
    fileprivate var realText:String?
    fileprivate var showingPasswordImage:UIImage?
    fileprivate var hidingPasswordImage:UIImage?
    fileprivate var showPasswordView:UIImageView?

    
    fileprivate var showingPassword = false {
        didSet{
            showPasswordView?.image = showingPassword ? showingPasswordImage : hidingPasswordImage
        }
    }
    
    
    
    //MARK: - View Setup
    public func setTint(_ color:UIColor){
           showPasswordView?.tintColor = color
       }

       
       fileprivate func createTextField(placeholder:String, image:UIImage){
           self.addLeftRightImage(pos: .left, im: image, mode: .always, tint: #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))
           self.borderStyle = UITextField.BorderStyle.none
           self.placeholder = placeholder
           self.clearsOnBeginEditing = false
           self.clearsOnInsertion = false
           

       }


       //MARK: - Initializers
       override func awakeFromNib() {
           super.awakeFromNib()
           createTextField(placeholder: "", image: #imageLiteral(resourceName: "passwordIcon"))

       }
       
       init(frame:CGRect, placholder:String, image:UIImage){
           super.init(frame:frame)
           createTextField(placeholder: placholder, image: image)
       }
    
       
     
       
       required init?(coder aDecoder: NSCoder) {
           super.init(coder: aDecoder)
       }
       
    
    
    //MARK: - Add show/hide password buttons
    public func initalizeShowHideFeature(showImage:UIImage, hideImage:UIImage){
        isSecureTextEntry = true
        showingPasswordImage = showImage
        hidingPasswordImage = hideImage        
        let view = UIView(frame:CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height))
        
        let size = view.frame.height / 2
        showPasswordView =  UIImageView(frame: CGRect(x: 15, y: 0, width: size  , height: self.frame.height))
        
        showPasswordView?.image = hidingPasswordImage
        showPasswordView?.isUserInteractionEnabled = true
        showPasswordView?.contentMode = UIImageView.ContentMode.scaleAspectFit
        showPasswordView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(switchOnText)))
        
         view.addSubview(showPasswordView!)
        
        
        
        self.rightView = view
        self.rightViewMode = .whileEditing
        self.isSecureTextEntry = !showingPassword
        
    }
    
    
    
    
   
    
   
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Hack to prevent text from getting cleared
        // http://stackoverflow.com/a/29195723/1417922
        //Setting the new text.
        let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string)
        textField.text = updatedString
        
        //Setting the cursor at the right place
        let selectedRange = NSMakeRange(range.location + string.count, 0)
        let from = textField.position(from: textField.beginningOfDocument, offset:selectedRange.location)!
        let to = textField.position(from: from, offset:selectedRange.length)!
        textField.selectedTextRange = textField.textRange(from: from, to: to)
        
        //Sending an action
        textField.sendActions(for: .editingChanged)
        
        return false
    }
    
    
   //MARK: - Actions
    override func becomeFirstResponder() -> Bool {
           super.becomeFirstResponder()
           
           if !isSecureTextEntry { return true  }
           
           //if let currentText = text { insertText(currentText) }
           
           return true
       }
       
       func setSecureMode(_ secure:Bool)
       {
           
           self.isSecureTextEntry = secure
           
           let tempText = self.text;
           self.text = " ";
           self.text = tempText;
           
           
       }
       
    
    @objc fileprivate func switchOnText(){
        showingPassword = !showingPassword
        // self.isSecureTextEntry = !showingPassword
        setSecureMode(!showingPassword)
        self.clearsOnBeginEditing = false
        self.clearsOnInsertion = false
        
        
    }
}

