

import Foundation
import UIKit

class LoadingView:UIView{
    
    lazy var text:UILabel = {
        let f = UILabel()
        f.translatesAutoresizingMaskIntoConstraints = false
    
        f.text = ""
        f.textAlignment = .center
        return f
        
    }()
    
    lazy var overly:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var logo:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "LigoLogCircle"))
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        return im
    }()
    
    fileprivate func setupViews(){
        
        self.addSubview(overly)
        
        overly.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        overly.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        overly.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        overly.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        
        let dialogue = UIView()
        dialogue.translatesAutoresizingMaskIntoConstraints = false
        dialogue.backgroundColor = UIColor.white.withAlphaComponent(0)
        dialogue.layer.cornerRadius = 5
        dialogue.layer.shadowColor = UIColor.black.cgColor
        dialogue.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.addSubview(dialogue)
        dialogue.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        dialogue.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        dialogue.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dialogue.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        dialogue.addSubview(logo)
        logo.widthAnchor.constraint(equalTo: dialogue.widthAnchor, multiplier: 0.6).isActive = true
        logo.heightAnchor.constraint(equalTo: dialogue.heightAnchor, multiplier: 0.6).isActive = true
        logo.topAnchor.constraint(equalTo: dialogue.topAnchor,constant: 8).isActive = true
        logo.centerXAnchor.constraint(equalTo: dialogue.centerXAnchor).isActive = true
        
        dialogue.addSubview(text)
        text.topAnchor.constraint(equalTo: logo.bottomAnchor,constant: 16).isActive = true
        text.centerXAnchor.constraint(equalTo: dialogue.centerXAnchor).isActive = true

        
        makeLogoPulsate(logo: logo, num: 1)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logo.layer.cornerRadius = logo.frame.width / 2
    }
    func hideLoading(){
        self.removeFromSuperview()
    }
    
    static func showLoading(view vcView:UIView) -> LoadingView{
        let view = AppDelegate.MainUIView() ?? vcView
              
        let loadingView = LoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        
        loadingView.logo.layer.cornerRadius = loadingView.logo.frame.width / 2
        loadingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        return loadingView
    }
    
    
    private func makeLogoPulsate(logo:UIView, num:Int){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            if num % 2 != 0{
                logo.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)}else{
                logo.transform = CGAffineTransform.identity
            }
        }) { [weak self](_) in
            guard let self = self else{return}
            self.makeLogoPulsate(logo: logo, num:num+1)
        }
    }
    
   private override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
