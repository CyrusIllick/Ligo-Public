

import Foundation
import UIKit

class QRCodeView1:UIView{
    
    lazy var overly:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var qrCode:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
      fileprivate func setupViews(){
          
          
          self.addSubview(overly)
          
          overly.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
          overly.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
          overly.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
          overly.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    
        
        overly.addSubview(qrCode)
        qrCode.centerXAnchor.constraint(equalTo: overly.centerXAnchor).isActive = true
        qrCode.centerYAnchor.constraint(equalTo: overly.centerYAnchor).isActive = true

        qrCode.widthAnchor.constraint(equalTo: overly.widthAnchor, multiplier: 0.5).isActive = true
        qrCode.heightAnchor.constraint(equalTo: overly.widthAnchor, multiplier: 0.5).isActive = true

        overly.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissClicked)))
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    static func showAlert(view:UIView,text:String) -> QRCodeView1{
         //  let currentWindow:UIWindow? = UIApplication.shared.keyWindow
           

        
        
           let mainView = AppDelegate.MainUIView() ?? view
           //print("currentWindow \(currentWindow)")
           
           let qrView = QRCodeView1()
           qrView.translatesAutoresizingMaskIntoConstraints = false
           
        qrView.qrCode.image = qrView.generateQRCode(from:text)

        mainView.addSubview(qrView)
           
           qrView.qrCode.alpha = 0
           qrView.qrCode.transform = CGAffineTransform(translationX: 0, y: -500)
           
           qrView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
           qrView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
           qrView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
           qrView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
           
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            qrView.qrCode.alpha = 1
            qrView.qrCode.transform = .identity
        })
        
        return qrView
    
    }
    @objc fileprivate func dismissClicked(){
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.qrCode.alpha = 0
            self.qrCode.transform = CGAffineTransform(translationX: 0, y: -500)
            self.alpha = 0
        }, completion: { (_) in
            self.hideAlert()
        })
        
        
    }
    
    func hideAlert(){
        self.removeFromSuperview()
    }
    
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)

            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }

        return nil
    }
    
    
}
