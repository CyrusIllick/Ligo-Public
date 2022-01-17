//
//  PopUpViewController.swift
//  Ligo
//
//  Created by Cyrus Illick on 6/21/20.
//  Copyright © 2020 Ligo. All rights reserved.
//

import UIKit
import SwiftUI


class PopUpViewController: UIViewController {

    @IBOutlet weak var qrView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initQR()
        
        
        
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        qrView.addGestureRecognizer(tapGestureRecognizer)

        // Do any additional setup after loading the view.
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view != self.qrView
        { self.dismiss(animated: true, completion: nil) }
    }
    
    func initQR(){
        qrView.layer.cornerRadius = 5
        qrView.layer.shadowOpacity = 0.2
        qrView.layer.shadowColor = UIColor.black.cgColor
        struct ContentView: View{
            var body: some View{
                VStack{
                   Text("Hello")
                   QRCodeView(url: "https://ligo.best/user/\(username)")
                }

            }
        }
        
        
        struct ContentView_Previews: PreviewProvider{
            static var previews: some View{
                ContentView()
            }
        }

    }
    
    
    @objc func dismissView(){
        dismiss(animated: true, completion: nil)
    }
    

}

struct PopUpViewController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
