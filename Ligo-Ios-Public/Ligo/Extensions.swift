//
//  BaseViewController.swift
//  The DoorStep Library
//
//  Created by Cyrus Illick on 22/02/2020.
//  Copyright © 2020 Ligo. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController{
    
    
    func hideNavigationShadow(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}


extension UITextField {
    
    // Next step here
    
    func underlined(){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}
extension UIView{
    func addShadow()
    {
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.5)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 0.0
        
    }
    func addShadow(radius:CGFloat, height:CGFloat, width:CGFloat, opacity:Float, color:CGColor){
        
        self.layer.shadowColor = color
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: width, height: height)
        self.layer.cornerRadius = 10
    }
    
    func addRadius(rad:CGFloat){
        self.layer.masksToBounds = true
        self.layer.cornerRadius = rad
    }
    
    
    
    
}



