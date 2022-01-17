

import Foundation
import UIKit



class CustomSwitch:UIView{
    
    weak var delegate:CustomSwitchProtocol?
    fileprivate var state = CustomSwitchState.first
    
    lazy var currentState = {return state}()
    
    
    var colorSecondary:UIColor = .black{
        didSet{switchView?.backgroundColor = colorSecondary}
    }
    var colorPrimary:UIColor = .white{
        didSet{mainView?.backgroundColor = colorPrimary}
    }
    var colorTextSecondary:UIColor = .black{
        didSet{mainText.textColor = colorTextSecondary}
    }
    var colorTextPrimary:UIColor = .white{
        didSet{secondaryText.textColor = colorTextPrimary}
    }
    
    let mainText:UILabel = {
        let t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0)
        t.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        t.textAlignment = .center
        return t
    }()
    let secondaryText:UILabel = {
        let t = UILabel()
        t.backgroundColor = UIColor.white.withAlphaComponent(0)
        t.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        t.textAlignment = .center
        return t
    }()
    
    fileprivate lazy var switchView:UIView? = {[weak self] in
        guard let self = self else{return nil}
        let v = UIView(frame:CGRect(x: 0, y: 0, width: self.frame.width / 2, height: self.frame.height))
        v.backgroundColor = colorSecondary
        v.layer.cornerRadius = cornerRadius
        v.isUserInteractionEnabled = true
        return v
        }()
    
    fileprivate lazy var mainView:UIView? = {[weak self] in
        guard let self = self else{return nil}
        let v = UIView(frame:CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        v.backgroundColor = colorPrimary
        v.layer.cornerRadius = cornerRadius
        v.isUserInteractionEnabled = true
        //v.addShadow()
        
        return v
        }()
    
    
    
    
    
    
    var cornerRadius:CGFloat = 10 {
        didSet{
            mainView?.layer.cornerRadius = cornerRadius
            switchView?.layer.cornerRadius = cornerRadius
            
        }}
    
    
    fileprivate let text:UITextView = {
        let t = UITextView()
        return t
    }()
    
    
    
    fileprivate func setupView(){
        
        
        
        
        
        guard let mv = mainView else{return}
        self.addSubview(mv)
        guard let v = switchView else{return}
        self.addSubview(v)
        
        
        mainText.frame = CGRect(x: 0, y: 0, width: (frame.width / 2), height: frame.height)
        mainText.textColor = colorTextPrimary
        
        self.addSubview(mainText)
        let newX = frame.width - (frame.width / 2)
        secondaryText.frame = CGRect(x: newX, y: 0, width: (frame.width / 2), height: frame.height)
        secondaryText.textColor = colorTextSecondary
        self.addSubview(secondaryText)
        
        
        mv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeState)))
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeState)))
        
    }
    
    @objc func changeState(){
        //print("Changed state")
        if state == .first {
            
            let newX = frame.width - (frame.width / 2)
            secondaryText.textColor = colorTextPrimary
            mainText.textColor = colorTextSecondary
            
            //secondaryText.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
                self?.switchView?.transform =  CGAffineTransform(translationX: newX, y: 0)
                //  self?.secondaryText.alpha = 1
                
                self?.state.toggle()
                guard let state =  self?.state else{return}
                self?.delegate?.stateChanged(state: state)
            })
            
        }else{
            secondaryText.textColor = colorTextSecondary
            mainText.textColor = colorTextPrimary
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseIn, animations: {[weak self] in
                self?.switchView?.transform =  .identity
                // self?.secondaryText.alpha = 1
                self?.state.toggle()
                guard let state =  self?.state else{return}
                self?.delegate?.stateChanged(state: state)
            })
        }
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    enum CustomSwitchState{
        case first
        case second
        
        mutating func toggle(){
            self = self == .first ? .second : .first
        }
    }
}
protocol CustomSwitchProtocol:class{
    func stateChanged(state:CustomSwitch.CustomSwitchState)
}

extension UITextField{
    
    
    enum posForView{
        case right
        case left
    }
    func addLeftRightImage(pos:posForView, im:UIImage?, mode:ViewMode, tint:UIColor, width:CGFloat = 50, height:CGFloat = 42, radius:CGFloat = 10, leftPadding:CGFloat = 15, sizeOfIconDivider:CGFloat = 3){
        
        let view = UIView(frame:CGRect(x: 0, y: 0, width: width, height: height))
        view.layer.cornerRadius = radius
        
        if pos == .left{
            self.leftView = view
            self.leftViewMode = mode
        }else {
            self.rightView = view
            self.rightViewMode = mode
        }
        
        
        let image = UIImageView()
        image.image = im?.withRenderingMode(.alwaysTemplate)
        image.contentMode = .scaleAspectFit
        image.frame = CGRect(x: leftPadding, y: 0, width: width / sizeOfIconDivider, height: height)
        image.clipsToBounds = true
        image.layer.cornerRadius = radius
        image.tintColor = tint
        view.addSubview(image)
        
        
        
    }
}

