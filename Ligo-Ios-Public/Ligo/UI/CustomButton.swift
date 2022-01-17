


import Foundation
import UIKit
class CustomButton:UIView{
    fileprivate var action:Action?
    
    //MARK: - Properties
    var text:String?{
        didSet{
            self.mainText.text = self.text
        }
    }
    
    var fontColor:UIColor?{
        didSet{
            self.mainText.textColor = self.fontColor
        }
    }
    
    var font:UIFont?{
        didSet{
            self.mainText.font = self.font
        }
    }
    
     var mainView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        
        return v
    }()
    
    var cornerRadius:CGFloat?{didSet{
        self.mainView.layer.cornerRadius = self.cornerRadius ?? 0
        
        }}
    
    
    
    var bgColor: UIColor? {
        didSet{
            self.mainView.backgroundColor = self.bgColor
            // self.backgroundColor = UIColor.clear
        }
    }
    
    var withBorder:Bool = false {
        didSet{
            if self.withBorder{
                self.mainView.backgroundColor = self.secondaryColor
                self.mainView.layer.borderWidth = 2
                self.mainView.layer.borderColor = bgColor?.cgColor
            }
        }
    }
    
    var secondaryColor:UIColor = Theme.SoftPurple
    lazy var mainText:UILabel = {
        let t = UILabel()
        t.translatesAutoresizingMaskIntoConstraints = false
        //   t.font = UIFont(name: "Mo", size: <#T##CGFloat#>)
        t.textAlignment = .center
        t.textColor = .white
        t.numberOfLines = -1
        return t
    }()
    
    fileprivate lazy var icon:UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.contentMode = .scaleAspectFit
        return i
    }()
    
    
    fileprivate func setupViews(withIcon:Bool){
        
        addSubview(mainView)
        mainView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mainView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onClick)))
        
        if !withIcon{
            mainView.addSubview(mainText)
            mainText.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            mainText.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.9).isActive = true
            mainText.widthAnchor.constraint(equalTo:mainView.widthAnchor,multiplier: 0.8).isActive = true
            mainText.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
            return
        }
        
        
        mainView.addSubview(icon)
        icon.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        icon.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        icon.rightAnchor.constraint(equalTo: mainView.rightAnchor,constant: -8).isActive = true
        icon.widthAnchor.constraint(equalTo: mainView.widthAnchor, multiplier: 0.1).isActive = true
        
        mainView.addSubview(mainText)
        mainText.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        mainText.heightAnchor.constraint(equalTo: mainView.heightAnchor, multiplier: 0.9).isActive = true
        mainText.leftAnchor.constraint(equalTo: mainView.leftAnchor,constant: 8).isActive = true
        mainText.rightAnchor.constraint(equalTo: icon.leftAnchor,constant: -4).isActive = true
        
        
        
    }
    
    
    @objc fileprivate func onClick(){
        // mainView.addOnTapAnimation()
        self.action?.action()
        
    }
    
    //MARK: - Actions
    func addAction(_ action:Action?){
        self.action = action
    }
    
    //MARK: -Initializers
    init(iconImage:UIImage){
        super.init(frame:CGRect.zero)
        setupViews(withIcon:true)
        self.icon.image = iconImage
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews(withIcon: false)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews(withIcon:false)
    }
    
    
    
    
}


//MARK: - Action Type Object
final class Action: NSObject {
    
    private let _action: () -> ()
    
    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }
    
    @objc func action() {
        _action()
    }
    
}


