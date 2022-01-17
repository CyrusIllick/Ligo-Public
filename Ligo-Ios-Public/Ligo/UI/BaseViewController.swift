

import Foundation
import UIKit
import EasyTipView

class BaseViewController:UIViewController{
    fileprivate var tips = [Tip]()
    fileprivate var tipIndex = 0
    
    var tipView:EasyTipView?
    var overlay:UIView!
    
    
    func isFirstLaunch(screen:String) -> Bool{
      if UserDefaults.standard.bool(forKey: "firstLaunch \(screen)") == false{
            UserDefaults.standard.set(true, forKey: "firstLaunch \(screen)")
            return true
        }
        return false
    }

    func setupTutorial(tips:[Tip]){
        self.tips = tips
        
    }
    func startTutorial(){
        nextTip()
    }
    
    func showTip(tip:String, onView:UIView, color:UIColor,padding:CGFloat = 4, radius:CGFloat = 5){
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = Theme.mainFontBoldMedium!
        preferences.drawing.foregroundColor = UIColor.white
        preferences.drawing.backgroundColor = color
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom
        preferences.drawing.arrowHeight = 10
        tipView = EasyTipView(text: tip, preferences: preferences, delegate: nil)
        
        if let mainView = (AppDelegate.MainUIView() ?? self.navigationController?.view){
        overlay = UIView(frame: mainView.frame)
        overlay.backgroundColor = UIColor.clear
        mainView.addSubview(overlay)
        
        let mainBg = UIBezierPath(rect: overlay.frame)
        let highlightView = onView.convert(onView.bounds, to: mainView)
        
        
        let roundedFrame = UIBezierPath(roundedRect: CGRect(x: highlightView.minX - padding/2, y: highlightView.minY - padding/2 , width: highlightView.width + padding, height: highlightView.height + padding), cornerRadius: radius)
        
        mainBg.append(roundedFrame)
        mainBg.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = mainBg.cgPath
        fillLayer.fillRule = CAShapeLayerFillRule.evenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.8
        overlay.layer.addSublayer(fillLayer)
        
        tipView?.show(forView: onView, withinSuperview: mainView)
        overlay.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTipView)))
        }
    }
    
    @objc fileprivate func closeTipView(){
        self.tipView?.dismiss()
        overlay?.removeFromSuperview()
        nextTip()
    }
    
     func closeTip(){
          self.tipView?.dismiss()
          overlay?.removeFromSuperview()
      }
    
    
    fileprivate func nextTip(){
        if tipIndex >= tips.count{return}
        let nextip = tips[tipIndex]
        showTip(tip: nextip.title, onView: nextip.onView, color: nextip.bgColor, padding: nextip.padding,radius: nextip.radius)
        tipIndex += 1
    }
    
    
    func hexStringToUIColor (hex:String) -> UIColor {
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

struct Tip{
    var bgColor:UIColor
    var title:String
    var padding:CGFloat
    var onView:UIView
    var radius:CGFloat
    
}
