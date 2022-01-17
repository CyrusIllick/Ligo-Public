

import Foundation
import UIKit


protocol ColorPickerProtocol{
    func didPick(color:MyColor)
}


class ColorPicker:UIView{
    
    var colors = [MyColor]()
    fileprivate let cellID = "cellID"
    var delegate:ColorPickerProtocol?
    
    fileprivate lazy var buttonStack:UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.spacing = 8
        s.distribution = .fillEqually
        return s
    }()
    
    func addColors(_ colors:[MyColor]){
        self.colors = colors
        colorCollections.reloadData()
    }
    
    
    fileprivate func buttonCreator(text:String) -> CustomButton{
        
        let b = CustomButton(frame: CGRect.zero)
        
        b.bgColor = Theme.Rajah
        b.secondaryColor = .white
        b.fontColor = .white
        b.mainText.textAlignment = .center
        b.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        b.text = text
        
        return b
        
    }
    
    func hideAlert(){
        self.removeFromSuperview()
    }
    
    func addAction(action:Action?,text:String, dismissAction:Bool = false){
        let button = buttonCreator(text: text)
        
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        // button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.addAction(action)
        if dismissAction{
            button.addAction(Action(action: {[weak self] in
                print("Clicked")
                self?.dismissClicked()
            }))
        }
        
        buttonStack.addArrangedSubview(button)
        
    }
    
    fileprivate func dismissClicked(){
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.background.alpha = 0
            self.background.transform = CGAffineTransform(translationX: 0, y: -500)
            self.alpha = 0
        }, completion: { (_) in
            self.hideAlert()
        })
        
        
    }
    
    static func showAlert(view:UIView,vc:ColorPickerProtocol, title:String) -> ColorPicker{
        //  let currentWindow:UIWindow? = UIApplication.shared.keyWindow
        
        
        let mainView = AppDelegate.MainUIView() ?? view
        //print("currentWindow \(currentWindow)")
      
        
        let loadingView = ColorPicker()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(loadingView)
        
        loadingView.background.alpha = 0
        loadingView.background.transform = CGAffineTransform(translationX: 0, y: -500)
        
        loadingView.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        loadingView.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
        loadingView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        
        //loadingView.text.text = text
        loadingView.delegate = vc
        loadingView.titleLabel.text = title
        
        let boxWidth = view.frame.width * 0.9
        
        loadingView.heightAlert?.constant = 150 + title.height(withConstrainedWidth: boxWidth, font: UIFont.systemFont(ofSize: 16, weight: .bold))
        loadingView.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            loadingView.background.alpha = 1
            loadingView.background.transform = .identity
        })
        
        return loadingView
    }
    
    
    lazy var overly:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    fileprivate lazy var background:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.addShadow(radius: 0.5, height: 1, width: 1, opacity: 0.2, color: UIColor.black.cgColor)
        v.addRadius(rad: 15)
        return v
    }()
    
    fileprivate lazy var text:UILabel = {
        let f = UILabel()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.font =  UIFont.systemFont(ofSize: 16)
        f.textColor =  UIColor.black
        f.numberOfLines = -1
        f.textAlignment = .center
        return f
    }()
    
    fileprivate lazy var titleLabel:UILabel = {
        let f = UILabel()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.font =  Theme.mainFontSemiBoldLarge
        f.textColor = UIColor.black
        f.text = ""
        f.numberOfLines = -1
        f.textAlignment = .center
        return f
    }()
    
    fileprivate lazy var logo:UIImageView = {
        let im = UIImageView(image: #imageLiteral(resourceName: "circleLogo"))
        im.translatesAutoresizingMaskIntoConstraints = false
        im.contentMode = .scaleAspectFit
        im.layer.cornerRadius = 50
        im.layer.masksToBounds = true
        return im
    }()
    
    fileprivate lazy var colorCollections:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let c = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.backgroundColor = .clear
        c.delegate = self
        c.dataSource = self
        c.register(ColorCell.self, forCellWithReuseIdentifier: cellID)
        c.showsHorizontalScrollIndicator = true
        //c.layer.cornerRadius = 5
        layout.scrollDirection = .horizontal
        
       // c.backgroundColor = .red
        return c
    }()
    
    
    var heightAlert:NSLayoutConstraint?
    var heightAlertConstant:CGFloat = 200
    fileprivate func setupViews(){
        
        
        self.addSubview(overly)
        
        overly.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        overly.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        overly.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        overly.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        overly.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissOnTap)))
        
        self.addSubview(background)
        background.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.9).isActive = true
        
        heightAlert = background.heightAnchor.constraint(equalToConstant: heightAlertConstant)
        heightAlert?.isActive = true
        
        background.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        background.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        
//        background.addSubview(logo)
//        logo.topAnchor.constraint(equalTo: background.topAnchor,constant:8).isActive = true
//        logo.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true
//
//        logo.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
//
//
        background.addSubview(buttonStack)
        buttonStack.bottomAnchor.constraint(equalTo: background.bottomAnchor,constant: -8).isActive = true
//        buttonStack.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 16).isActive = true
//        buttonStack.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -16).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 0).isActive = true
        buttonStack.widthAnchor.constraint(equalToConstant: 100).isActive = true
        buttonStack.centerXAnchor.constraint(equalTo: background.centerXAnchor).isActive = true
        
        
        
        background.addSubview(titleLabel)
        titleLabel.topAnchor.constraint(equalTo: background.topAnchor,constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -8).isActive = true
        
        background.addSubview(colorCollections)
        colorCollections.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,constant: 16).isActive = true
        colorCollections.leftAnchor.constraint(equalTo: background.leftAnchor,constant: 4).isActive = true
        colorCollections.rightAnchor.constraint(equalTo: background.rightAnchor,constant: -4).isActive = true
        colorCollections.bottomAnchor.constraint(equalTo: buttonStack.topAnchor,constant: -16).isActive = true
//
    }
    var buttonHeight:CGFloat = 30
    var buttonWidth:CGFloat = 100
    
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }


    @objc fileprivate func dismissOnTap(){
        self.dismissClicked()
    }
}


extension ColorPicker:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ColorCell
        
        
        cell.color.backgroundColor = colors[indexPath.row].getColor()
        cell.colorVal = colors[indexPath.row]
        cell.colorName.text = colors[indexPath.row].name
        cell.delegate = self
        cell.colorName.textColor = colors[indexPath.row].fontColor
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height - 10, height: collectionView.frame.height - 10)
    }
    
}
extension ColorPicker:ColorPickerProtocol{
    func didPick(color: MyColor) {
        self.delegate?.didPick(color: color)
        self.dismissClicked()
        
    }
    
    
}


class ColorCell:UICollectionViewCell{
    
    var delegate:ColorPickerProtocol?
    var colorVal:MyColor!
    
    fileprivate lazy var color:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .yellow
        return v
    }()
    
    fileprivate lazy var colorName:UILabel = {
        let f = UILabel()
        f.translatesAutoresizingMaskIntoConstraints = false
        f.font = Theme.mainFontSemiBoldMedium
        f.textColor = UIColor.black
        f.text = "Yellow"
        f.numberOfLines = -1
        f.textAlignment = .center
        return f
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        self.addSubview(color)
        color.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
          color.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
          color.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
          color.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        color.addSubview(colorName)
       
        colorName.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
                 colorName.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
                 colorName.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                 colorName.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
               
        self.makeButton(withAction: #selector(didPick), andTarget: self)

    }
    
    @objc fileprivate func didPick(){
        delegate?.didPick(color: colorVal)
        print("picked")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       color.layer.cornerRadius = self.frame.width / 2
        color.addShadow()
        //color.layer.borderWidth = 1
       // color.layer.borderColor = UIColor.black.cgColor
    }
    
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}



struct MyColor{
    let name:String
    let fontColor:UIColor
    var hexVal:String
    
    
    func getColor() -> UIColor{
        return hexStringToUIColor(hex:self.hexVal)
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
