

import Foundation
import UIKit
class RoveWalkThrough:UIView{
    
    fileprivate lazy var overlay:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        v.alpha = 0
        v.isHidden = true
        return v
    }()
    fileprivate var mainView:UIView!
    fileprivate var walkThrough = [Tutorial]()
    
    
    
    static func CreateTutorial(hints:[Tutorial], view mainView:UIView) -> RoveWalkThrough{
        let walkthrough = RoveWalkThrough()
        walkthrough.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(walkthrough)

        walkthrough.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
               walkthrough.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
               walkthrough.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
               walkthrough.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        
        walkthrough.mainView = mainView
        walkthrough.walkThrough = hints
        

        return walkthrough
    }
    
    
    fileprivate func setupViews(){
           self.addSubview(overlay)

           overlay.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                  overlay.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                  overlay.topAnchor.constraint(equalTo: topAnchor).isActive = true
                  overlay.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
           
           
       }
    
    
    func startTutorial(){
        showHint()
    }
    
    
    var circleHintView:UIView!
    fileprivate func showHint(){
        //   setupViews()

        guard let tutorial = walkThrough.first else{
            self.overlay.removeFromSuperview()
            return}
        let centerView = tutorial.view
        let hint = tutorial.hint
        print(hint)
        
           overlay.isHidden = false
        
        let hintCircleHeight = centerView.frame.height * 1.25
        let hintCircleWidth = centerView.frame.width * 1.25

        
        circleHintView = UIView(frame:CGRect(x: 0, y: 0, width: hintCircleWidth, height: hintCircleHeight))
        circleHintView.backgroundColor = .white
        circleHintView.center = centerView.center
        circleHintView.layer.cornerRadius = 10
        circleHintView.alpha = 0
    
    
        mainView.bringSubviewToFront(overlay)
        mainView.bringSubviewToFront(centerView)
        overlay.addSubview(circleHintView)
           
           
           UIView.animate(withDuration: 0.25) {
               self.overlay.alpha = 0.8
            self.circleHintView.alpha = 1
           }
           
           mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideHint)))
           
       }
       
       @objc fileprivate func hideHint(){
           
           UIView.animate(withDuration: 0.25, animations: {
            
            self.overlay.alpha = 0
            
            
            self.circleHintView.alpha = 0
           }) { (_) in
              
            
            self.circleHintView.removeFromSuperview()
            self.nextHint()
           }
        
      
       }

    
    fileprivate func nextHint(){
        if walkThrough.count > 0{
            walkThrough.removeFirst()
                  showHint()
        }else{
            self.overlay.removeFromSuperview()
        }
    }
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    struct Tutorial{
        let hint:String
        let view:UIView
    }
    
    
}
