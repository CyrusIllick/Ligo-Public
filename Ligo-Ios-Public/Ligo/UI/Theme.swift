

import Foundation
import UIKit

class Theme{
    
//    static let Rajah:UIColor = UIColor(named:"Rajah")!
//    static let SoftPurple:UIColor = UIColor(named:"Soft Purple")!
    

    // Color1 = 4FA3A7
    // Color2 = 8BEB93
    
    static let Rajah: UIColor = hexStringToUIColor(hex: "4FA3A7")
    static let SoftPurple: UIColor = hexStringToUIColor(hex: "8BEB93")
    static let AlmostWhite:UIColor = UIColor(named:"Almost White")!

    static let mainFontBoldLarge =  UIFont(name: "Montserrat-Bold", size: 16)
    
    static let mainFontBoldMedium =  UIFont(name: "Montserrat-Bold", size: 14)
    
    
    static let mainFontSemiBoldLarge =  UIFont(name: "Montserrat-SemiBold", size: 16)
     
     static let mainFontSemiBoldMedium =  UIFont(name: "Montserrat-SemiBold", size: 14)
    
    
    

    //for color from database
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}



/**
FONTS

Montserrat ["Montserrat-Regular", "Montserrat-ExtraBold", "Montserrat-BoldItalic", "Montserrat-Black", "Montserrat-Medium", "Montserrat-Bold", "Montserrat-Light", "Montserrat-SemiBold", "Montserrat-LightItalic", "Montserrat-ExtraLight", "Montserrat-ExtraLightItalic", "Montserrat-SemiBoldItalic", "Montserrat-ThinItalic", "Montserrat-Thin", "Montserrat-BlackItalic", "Montserrat-Italic", "Montserrat-MediumItalic", "Montserrat-ExtraBoldItalic"]
*/


