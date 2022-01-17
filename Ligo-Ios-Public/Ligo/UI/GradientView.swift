
import UIKit

class GradientView: UIView {
    
    // MARK: - Properties
    
    // Gradient layer property
    var gradientLayer: CAGradientLayer!
    
    // MARK: - Data Structures
    
    // Options for different ways the gradient could be oriented
    enum Orientation {
        case topDown, bottomUp, leftRight, rightLeft
        case diagonalLeftRight, diagonalRightLeft
    }
    
    // MARK: - Initialization
    
    override open class var layerClass: AnyClass {
       return CAGradientLayer.classForCoder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        gradientLayer = layer as? CAGradientLayer
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
    }
    
    // MARK: - Customize Gradient
    
    /// Sets the gradient to the given colors
    /// - Parameters:
    ///     - color1: Starting color of gradient
    ///     - color2: Ending color of gradient
    func setColors(toStartColor color1: UIColor, andEndColor color2: UIColor) {
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
    }
    
    /// Changes the orientation of the gradient
    /// - Parameters:
    ///     - orientation: Orientation of color start and end points
    func setOrientation(to orientation: Orientation) {
        switch orientation {
        case .topDown:
            gradientLayer.startPoint = .init(x: 0, y: 0)
            gradientLayer.endPoint = .init(x: 0, y: 1)
        case .bottomUp:
            gradientLayer.startPoint = .init(x: 0, y: 1)
            gradientLayer.endPoint = .init(x: 0, y: 0)
        case .leftRight:
            gradientLayer.startPoint = .init(x: 0, y: 0)
            gradientLayer.endPoint = .init(x: 1, y: 0)
        case .rightLeft:
            gradientLayer.startPoint = .init(x: 1, y: 0)
            gradientLayer.endPoint = .init(x: 0, y: 0)
        case .diagonalLeftRight:
            gradientLayer.startPoint = .init(x: 0, y: 0)
            gradientLayer.endPoint = .init(x: 1, y: 1)
        case .diagonalRightLeft:
            gradientLayer.startPoint = .init(x: 1, y: 0)
            gradientLayer.endPoint = .init(x: 0, y: 1)
        }
    }
    
    // MARK: - Customize View
    
    /// Sets the corner radius of the view
    /// - Parameters:
    ///     - cornerRadius: Corner radius in pixels
    func setCornerRadius(to cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
