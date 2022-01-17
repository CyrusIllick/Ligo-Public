

import Foundation
import UIKit

class ProfileView:UIImageView{
    var mainColor:UIColor = Theme.Rajah{
        didSet{
            tintColor = mainColor
            loadingView.tintColor = mainColor
        }
    }
    
    var placeholder:UIImage? = UIImage(systemName: "person.fill"){
        didSet{
            self.image = placeholder
        }
    }
    
    fileprivate lazy var loadingView:UIActivityIndicatorView = {
        let v = UIActivityIndicatorView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.tintColor = mainColor
        v.color = mainColor
        return v
    }()
    
    
    fileprivate func showLoading(_ show:Bool){
        
        if show && self.loadingView.isAnimating{
            return
        }
        
        self.image = show ?  nil : self.image
        self.loadingView.isHidden = show
        if show{
            self.loadingView.startAnimating()}
        else{
            self.loadingView.stopAnimating()
        }
    }
    
    func setImage(url:String){
        showLoading(true)
        
        let _ = ImageHelper.loadImage(urlString: url, withCache: false) {(_, image) in
            self.showLoading(false)
            self.image = image
        }
        
        
        
        
    }
    
    func setImage(username uid:String, completion:@escaping (Bool) -> Void){
        showLoading(true)
        
        print("UIDDD \(uid)")
        DataGrab.getImageURL(username: uid) { (photoURL) in

            guard let photoURL = photoURL else{
                self.showLoading(false)
                completion(false)
                self.showPlaceholder()
                return
            }
            completion(true)
            self.setImage(url: photoURL)
            
            
        }
        
        
    }
    
    func setImage(image:UIImage){
        self.image = image
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        
    }
    
    
    
    fileprivate func setupViews(){
        
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = mainColor
        contentMode = .scaleAspectFill
        
        
        
        
        self.addSubview(loadingView)
        loadingView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
    
    func showPlaceholder(){
        self.image = self.placeholder

    }
    
}
