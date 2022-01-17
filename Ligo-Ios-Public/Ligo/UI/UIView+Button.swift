

import UIKit

extension UIView {
    
    /// Makes UIView execute an action when tapped
    /// - Parameters:
    ///     - action: Action to be executed when tapped
    ///     - target: Recipient of actiion message
    func makeButton(withAction action: Selector, andTarget target: Any?) {
        isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: target, action: action)
        self.addGestureRecognizer(tapGesture)
    }
}
