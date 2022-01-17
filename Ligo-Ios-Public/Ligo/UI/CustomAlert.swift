

import Foundation
import UIKit

class CustomAlert {
    
    // MARK: - Alert
    
    /// Error alert
    static func error(presentFrom viewController: UIViewController, withTitle title: String, andMessage message: String) {
        
        let customAlert = AlertBox.showAlert(view: viewController.view, text: message, title: title)
        customAlert.addAction(action: nil, text: "Okay", dismissAction: true)

    }
    
    /// Success Alert
    static func success(presentFrom viewController: UIViewController, withTitle title: String, andMessage message: String) {
      
        let customAlert = AlertBox.showAlert(view: viewController.view, text: message, title: title)
        customAlert.addAction(action: nil, text: "Okay!", dismissAction: true)
        
        
//        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "Ok!", style: .default, handler: nil)
//        alert.addAction(okAction)
//        viewController.present(alert, animated: true, completion: nil)
    }
    
    /// Self Dismiss
    static func autoDismiss(presentFrom viewController: UIViewController, withTitle title: String, andMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
    

    static func showToast(message : String) {
     
        guard let view = AppDelegate.MainUIView() else{return}
        
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.backgroundColor = Theme.Rajah
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = Theme.mainFontSemiBoldMedium
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 2
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        view.addSubview(toastLabel)
        
        toastLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,constant: -16).isActive = true
        toastLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4).isActive = true
        toastLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        UIView.animate(withDuration: 1.0, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }

}
