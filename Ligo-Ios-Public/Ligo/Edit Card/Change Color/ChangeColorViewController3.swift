//
//  ChangeColorViewController3.swift
//  Ligo
//
//  Created by Cyrus Illick on 6/18/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit


class ChangeColorViewController: UIViewController{
    
    
    @IBOutlet weak var btnSelectFirst: CustomButton!
    @IBOutlet weak var btnSelectSecond: CustomButton!
    @IBOutlet weak var myCardBackground: GradientView!
    
    
    var myColors = [MyColor]()
    
    var selectedButton = CustomButton()
    
    var firstPressed = false
    
    var color1 = UIColor.blue
    var color2 = UIColor.green
    
    var color1Hex = "FFFFFF"
    var color2Hex = "FFFFFF"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initmyCardBackground()
        initButtons()
        initColors()
    }
    
    func initButtons(){
        btnSelectSecond.bgColor = hexStringToUIColor(hex: me.grad2 ?? "000000")
        btnSelectSecond.secondaryColor = .white
        btnSelectSecond.fontColor = .white
        btnSelectSecond.text = "Select\nSecond\nColor"
        btnSelectSecond.mainText.textAlignment = .center
        btnSelectSecond.font = Theme.mainFontBoldMedium
        btnSelectSecond.cornerRadius = 50
        //btnSelectSecond.withBorder = true
        btnSelectSecond.mainView.addShadow()
        
        btnSelectFirst.bgColor =  hexStringToUIColor(hex: me.grad1 ?? "000000")
        btnSelectFirst.secondaryColor = .white
        btnSelectFirst.fontColor = .white
        btnSelectFirst.text = "Select\nFirst\nColor"
        btnSelectFirst.mainText.textAlignment = .center
        btnSelectFirst.font = Theme.mainFontBoldMedium
        btnSelectFirst.cornerRadius = 50

        
        btnSelectFirst.mainView.addShadow()
        
        btnSelectFirst.addAction(Action(action: {
            self.onClickFirst()
        }))
        btnSelectSecond.addAction(Action(action: {
            self.onClickSecond()
        }))
    }
    
    func initmyCardBackground(){
        myCardBackground.setCornerRadius(to: 4)
        color1 = hexStringToUIColor(hex: me.grad1 ?? "FF00FF")
        color2 = hexStringToUIColor(hex: me.grad2 ?? "FFFFFF")
        color1Hex = me.grad1 ?? "FFFFFF"
        color2Hex = me.grad2 ?? "FFFFFF"
        myCardBackground.setColors(toStartColor: color1, andEndColor: color2)
        myCardBackground.layer.shadowOpacity = 0.5
        myCardBackground.layer.shadowColor = UIColor.black.cgColor
        myCardBackground.layer.shadowOffset = CGSize(width: 0, height: 2)
        
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
    
    
    
    
    func onClickFirst() {
        firstPressed = true
        selectedButton = btnSelectFirst
        
        //Shows color picker with list of colors
        ColorPicker.showAlert(view: view, vc: self, title: "Pick your color").addColors(myColors)
    }
    func onClickSecond() {
        firstPressed = false
        selectedButton = btnSelectSecond
        
        //Shows color picker with list of colors
        ColorPicker.showAlert(view: view, vc: self, title: "Pick your color").addColors(myColors)
        
        
    }
    
    
    
    
    ///Calls the update colors function and alerts the user
    //TODO: - After the user saves they should go immediately back to the home screen
    @IBAction func saveNewColorsButton(_ sender: Any) {
        saveNewColors()
        Analytics.track(Analytics.Event.updateCardColors)
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    ///Updates colors to the database
    func saveNewColors(){
        me.grad1 = color1Hex
        me.grad2 = color2Hex
        DataGrab.updateField(type: "grad1", to: color1Hex) {
            
            DataGrab.updateField(type: "grad2", to: self.color2Hex) {

                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}


extension ChangeColorViewController{
    
    //MARK: -Add Available Colors
    fileprivate func initColors(){
        myColors.append(MyColor(name: "Grey", fontColor: .white, hexVal: "34495E"))
        myColors.append(MyColor(name: "White", fontColor: .black, hexVal: "F0F3F4"))
        myColors.append(MyColor(name: "Navy Blue", fontColor: .white, hexVal: "21618C"))
        myColors.append(MyColor(name: "Purple", fontColor: .white, hexVal: "A569BD"))
        myColors.append(MyColor(name: "Yellow", fontColor: .black, hexVal: "F4D03F"))
        myColors.append(MyColor(name: "Red", fontColor: .white, hexVal: "E74C3C"))
        myColors.append(MyColor(name: "Green", fontColor: .white, hexVal: "117A65"))
        myColors.append(MyColor(name: "Orange", fontColor: .white, hexVal: "E59866"))
        myColors.append(MyColor(name: "Light Green", fontColor: .black, hexVal: "58D68D"))
        myColors.append(MyColor(name: "Soft Green", fontColor: .black, hexVal: "7FBEAB"))
        myColors.append(MyColor(name: "Soft Blue", fontColor: .black, hexVal: "B8D4E3"))
        myColors.append(MyColor(name: "Soft Purple", fontColor: .black, hexVal: "A7ACD9"))
        myColors.append(MyColor(name: "Soft Grape", fontColor: .white, hexVal: "9E8FB2"))
        myColors.append(MyColor(name: "Tan", fontColor: .black, hexVal: "F0CEA0"))
        myColors.append(MyColor(name: "Elephant", fontColor: .white, hexVal: "8D99AE"))
        myColors.append(MyColor(name: "Orchid", fontColor: .black, hexVal: "F5A6E6"))
        myColors.append(MyColor(name: "Black", fontColor: .white, hexVal: "000000"))
        myColors.append(MyColor(name: "Sand", fontColor: .black, hexVal: "F0A868"))
        myColors.append(MyColor(name: "Dark Purple", fontColor: .white, hexVal: "261132"))
        myColors.append(MyColor(name: "Icterine", fontColor: .black, hexVal: "EDF060"))
        myColors.append(MyColor(name: "Raisin", fontColor: .white, hexVal: "2E2532"))
        myColors.append(MyColor(name: "Flame", fontColor: .white, hexVal: "EC4E20"))
        myColors.append(MyColor(name: "Morning Blue", fontColor: .black, hexVal: "8DAA9D"))
        myColors.append(MyColor(name: "Violet", fontColor: .white, hexVal: "372554"))
        myColors.append(MyColor(name: "Turquoise", fontColor: .black, hexVal: "6DD3CE"))
        myColors.append(MyColor(name: "Popping Purple", fontColor: .white, hexVal: "623CEA"))
        myColors.append(MyColor(name: "Dutch White", fontColor: .black, hexVal: "DBD5B2"))
        myColors.append(MyColor(name: "Redwood", fontColor: .white, hexVal: "A15E49"))
        myColors.append(MyColor(name: "Thistle", fontColor: .black, hexVal: "CAB1BD"))

        btnSelectFirst.text = myColors.filter({ (a) -> Bool in
            a.getColor() == btnSelectFirst.bgColor
        }).first?.name ?? "Select Color"
        
        btnSelectSecond.text = myColors.filter({ (a) -> Bool in
            a.getColor() == btnSelectSecond.bgColor
        }).first?.name ?? "Select Color"
        
    }
    
    
}

extension ChangeColorViewController:ColorPickerProtocol{
    func didPick(color: MyColor) {
        
        if firstPressed{
            color1 = color.getColor()
            color1Hex = color.hexVal
        }else{
            color2 = color.getColor()
            color2Hex = color.hexVal
        }
        
        selectedButton.bgColor = color.getColor()
        selectedButton.text = color.name
        selectedButton.fontColor = color.fontColor
        myCardBackground.setColors(toStartColor: color1, andEndColor: color2)
        
    }
    
    
}

